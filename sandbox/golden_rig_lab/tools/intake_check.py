"""P2.4B-1 intake check for regenerated FRONT_3Q candidates.

Checks a delivered file BEFORE it enters the Lab, using only file facts and the frozen template
geometry (regen_templates.json): PNG signature, RGBA with real transparency, size = k x 512,
alpha not touching the canvas edge (GR052), opaque pixels present at the template joints, and
prints the metadata block the Lab would use if the template framing was followed.

Usage:
    python sandbox/golden_rig_lab/tools/intake_check.py <slot> <file.png> [<slot> <file.png> ...]
Exit code 1 if any file fails a hard check.
"""
from __future__ import annotations

import json
import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
TEMPLATES = os.path.join(REPO, "docs", "05-visual", "p2_4b", "regen_templates_p2_4b_1", "regen_templates.json")
PNG_SIG = b"\x89PNG\r\n\x1a\n"


def check(slot: str, path: str, templates: dict) -> tuple[bool, list[str], dict | None]:
    msgs, hard_fail = [], False
    if slot not in templates:
        return False, [f"unknown slot {slot}"], None
    with open(path, "rb") as f:
        head = f.read(8)
    if head != PNG_SIG:
        return False, [f"GR012 FAIL: not a PNG (signature {head[:4].hex()}); JPEG/other containers cannot carry alpha"], None
    im = Image.open(path)
    msgs.append(f"mode={im.mode} size={im.size[0]}x{im.size[1]}")
    if im.mode != "RGBA":
        msgs.append("GR012 FAIL: not RGBA")
        hard_fail = True
    im = im.convert("RGBA")
    w, h = im.size
    if w != h or (w % 512) != 0:
        msgs.append(f"GR011 FAIL: size must be k x 512 square (got {w}x{h})")
        hard_fail = True
        return False, msgs, None
    k = w // 512
    tkey = f"{k}x"
    if tkey not in templates[slot]:
        msgs.append(f"WARN: no template at {k}x (have {list(templates[slot].keys())}); joint check uses logical coords x{k}")
    a = im.getchannel("A")
    hist = a.histogram()
    transparent = hist[0] / (w * h)
    if transparent < 0.05:
        msgs.append(f"GR012 FAIL: only {transparent:.1%} fully transparent pixels — background is not transparent")
        hard_fail = True
    bbox = a.getbbox()
    if bbox is None:
        msgs.append("FAIL: image is fully transparent")
        return False, msgs, None
    touches = [n for n, cond in [("left", bbox[0] <= 0), ("top", bbox[1] <= 0), ("right", bbox[2] >= w), ("bottom", bbox[3] >= h)] if cond]
    if touches:
        msgs.append(f"GR052 WARN: alpha touches canvas edge: {', '.join(touches)}")
    # corners must be transparent (catches black/white backgrounds with a tiny alpha halo)
    corners = [im.getpixel((2, 2))[3], im.getpixel((w - 3, 2))[3], im.getpixel((2, h - 3))[3], im.getpixel((w - 3, h - 3))[3]]
    if max(corners) > 0:
        msgs.append(f"GR012 FAIL: canvas corners are not transparent (alpha {corners})")
        hard_fail = True
    t = templates[slot].get(tkey) or templates[slot]["2x"]
    kk = k / t["scale_k"]
    prox = [c * kk for c in t["proximal"]["template_px"]]
    px = a.load()

    def covered(pt, radius=int(6 * k)):
        x0, y0 = int(pt[0]), int(pt[1])
        hits = 0
        for dx in range(-radius, radius + 1, max(1, radius // 3)):
            for dy in range(-radius, radius + 1, max(1, radius // 3)):
                xx, yy = x0 + dx, y0 + dy
                if 0 <= xx < w and 0 <= yy < h and px[xx, yy] > 64:
                    hits += 1
        return hits > 0

    if not covered(prox):
        msgs.append(f"FIT WARN: no opaque pixels near proximal joint {t['proximal']['marker']} at template px {prox} — was the template framing followed?")
    if "distal" in t:
        dist = [c * kk for c in t["distal"]["template_px"]]
        if not covered(dist):
            msgs.append(f"FIT WARN: no opaque pixels near distal joint {t['distal']['marker']} at template px {dist}")
    meta = {
        "texture": f"res://assets/armor/armor_blackguard_01/front_3q/{os.path.basename(path)}",
        "source_size": [w, h],
        "source_canvas_size": [w, h],
        "canvas_offset": [0, 0],
        "pivot_source": [t["proximal"]["logical"][0] * k, t["proximal"]["logical"][1] * k],
        "pivot_marker": t["proximal"]["marker"],
        "scale_to_logical": 1.0 / k,
        "z_index": t["z_index"],
        "status": "candidate_p2_4b_1",
    }
    if "distal" in t:
        meta["distal_source"] = [t["distal"]["logical"][0] * k, t["distal"]["logical"][1] * k]
        meta["distal_marker"] = t["distal"]["marker"]
    return not hard_fail, msgs, meta


def main(argv):
    if len(argv) < 2 or len(argv) % 2 != 0:
        print(__doc__)
        return 2
    with open(TEMPLATES, encoding="utf-8") as f:
        templates = json.load(f)["templates"]
    any_fail = False
    for slot, path in zip(argv[0::2], argv[1::2]):
        ok, msgs, meta = check(slot, path, templates)
        any_fail |= not ok
        print(f"== {slot}: {'OK' if ok else 'FAIL'}  ({path})")
        for m in msgs:
            print("   ", m)
        if meta:
            print("    proposed front_3q metadata:", json.dumps(meta))
    return 1 if any_fail else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
