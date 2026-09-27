"""P2.4B-1 — regeneration templates for the slots that failed P2.4B-0.

Every geometric value comes from the frozen P1.5 manifest; the kept pieces (torso, boots) are
composited with their current metadata through the same placement rule the Lab uses. Nothing is
measured from artwork. Output: one PNG template per slot at 2x (1024) and 3x (1536) plus a JSON
sidecar with the joint coordinates in template pixels, and a contact sheet.

Usage (from the repo root or the sandbox dir):
    python sandbox/golden_rig_lab/tools/make_regen_templates.py
"""
from __future__ import annotations

import json
import math
import os
import sys

from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
SANDBOX = os.path.abspath(os.path.join(HERE, ".."))
REPO = os.path.abspath(os.path.join(SANDBOX, "..", ".."))
MANIFEST = os.path.join(REPO, "docs", "05-visual", "agent-contract", "manifests", "vanguard_sword_shield.rig.json")
PARTS_DIR = os.path.join(SANDBOX, "metadata", "parts", "armor_blackguard_01")
OUT_DIR = os.path.join(REPO, "docs", "05-visual", "p2_4b", "regen_templates_p2_4b_1")

KEPT = ["torso", "lower_leg_boot_l", "lower_leg_boot_r"]
# slot -> (bone, proximal marker, distal marker, z, lane, side note)
REGEN = {
    "upper_arm_l": ("upper_arm_l", "SHOULDER_L", "ELBOW_L", 30, "armor_far (behind torso)"),
    "upper_arm_r": ("upper_arm_r", "SHOULDER_R", "ELBOW_R", 85, "armor_near (in front of torso)"),
    "forearm_hand_l": ("forearm_hand_l", "ELBOW_L", "HAND_L", 31, "armor_far"),
    "forearm_hand_r": ("forearm_hand_r", "ELBOW_R", "HAND_R", 86, "armor_near"),
    "thigh_l": ("thigh_l", "HIP_L", "KNEE_L", 40, "legs"),
    "thigh_r": ("thigh_r", "HIP_R", "KNEE_R", 42, "legs"),
    "waist_tabard": ("hip", "HIP", None, 51, "torso+1 (over torso and legs, under near arm)"),
}
SCALES = [2, 3]


def v(a):
    return (float(a[0]), float(a[1]))


def load_json(p):
    with open(p, encoding="utf-8") as f:
        return json.load(f)


def placement_rect(vm, pivot_abs, k):
    """Top-left and size, in template px, of a part placed by the Lab's invariant."""
    w, h = vm["source_size"]
    s = float(vm["scale_to_logical"])
    px, py = vm["pivot_source"]
    ox, oy = vm.get("canvas_offset", [0, 0])
    tlx = (pivot_abs[0] - (px - ox) * s) * k
    tly = (pivot_abs[1] - (py - oy) * s) * k
    return (tlx, tly), (w * s * k, h * s * k)


def font(size):
    for name in ["arial.ttf", "DejaVuSans.ttf", "segoeui.ttf"]:
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            continue
    return ImageFont.load_default()


def main():
    m = load_json(MANIFEST)
    markers = {k: v(x) for k, x in m["geometry"]["primary_markers_absolute"].items()}
    markers.update({k: v(x) for k, x in m["geometry"]["secondary_pivots_absolute"].items()})
    bones = {b["id"]: b for b in m["bones"]}
    canvas = (m["logical_canvas"]["width"], m["logical_canvas"]["height"])
    axis_x, ground_y = m["center_axis_x"], m["ground_y"]
    os.makedirs(OUT_DIR, exist_ok=True)

    kept_layers = []
    for slot in KEPT:
        part = load_json(os.path.join(PARTS_DIR, f"{slot}.visual_part.json"))
        vm = part["views"]["front_3q"]
        tex = os.path.join(SANDBOX, vm["texture"].replace("res://", ""))
        bone = bones[part["attachment"]["target"]]
        kept_layers.append((slot, vm, Image.open(tex).convert("RGBA"), v(bone["pivot_absolute"]), vm["z_index"]))
    kept_layers.sort(key=lambda t: t[4])

    sidecar = {"manifest": os.path.relpath(MANIFEST, REPO), "logical_canvas": canvas, "templates": {}}
    sheet_cells = []
    for slot, (bone_id, prox, dist, z, lane) in REGEN.items():
        for k in SCALES:
            W, H = canvas[0] * k, canvas[1] * k
            img = Image.new("RGBA", (W, H), (70, 70, 74, 255))
            d = ImageDraw.Draw(img)
            # kept context pieces, dimmed
            for kslot, vm, tex, pivot_abs, _z in kept_layers:
                (tlx, tly), (w, h) = placement_rect(vm, pivot_abs, k)
                layer = tex.resize((max(1, int(round(w))), max(1, int(round(h)))), Image.LANCZOS)
                a = layer.getchannel("A").point(lambda p: int(p * 0.55))
                layer.putalpha(a)
                img.alpha_composite(layer, (int(round(tlx)), int(round(tly))))
            d = ImageDraw.Draw(img)
            # canvas, axis, ground
            d.rectangle([0, 0, W - 1, H - 1], outline=(255, 255, 255, 140), width=2)
            d.line([(axis_x * k, 0), (axis_x * k, H)], fill=(80, 220, 255, 160), width=2)
            d.line([(0, ground_y * k), (W, ground_y * k)], fill=(255, 150, 50, 220), width=2)
            # all bones faint
            for b in m["bones"]:
                if b.get("end_marker"):
                    p0 = v(b["pivot_absolute"]); p1 = markers[b["end_marker"]]
                    d.line([(p0[0] * k, p0[1] * k), (p1[0] * k, p1[1] * k)], fill=(255, 255, 255, 70), width=2)
            f_big, f_small = font(9 * k), font(6 * k)
            p_prox = markers[prox]
            entry = {"scale_k": k, "template_size": [W, H], "bone": bone_id, "z_index": z, "lane": lane,
                     "proximal": {"marker": prox, "logical": list(p_prox), "template_px": [p_prox[0] * k, p_prox[1] * k]}}
            if dist:
                p_dist = markers[dist]
                d.line([(p_prox[0] * k, p_prox[1] * k), (p_dist[0] * k, p_dist[1] * k)], fill=(255, 240, 40, 255), width=3 * k // 2 + 1)
                length = math.dist(p_prox, p_dist)
                ang = math.degrees(math.atan2(p_dist[0] - p_prox[0], p_dist[1] - p_prox[1]))  # from vertical, + = to the right
                for p, name, col in [(p_prox, prox, (255, 60, 60, 255)), (p_dist, dist, (255, 60, 60, 255))]:
                    r = 3 * k
                    d.ellipse([p[0] * k - r, p[1] * k - r, p[0] * k + r, p[1] * k + r], outline=col, width=2)
                    d.text((p[0] * k + 5 * k, p[1] * k - 6 * k), f"{name} ({int(p[0])},{int(p[1])})", fill=col, font=f_small)
                entry["distal"] = {"marker": dist, "logical": list(p_dist), "template_px": [p_dist[0] * k, p_dist[1] * k]}
                entry["bone_length_logical"] = length
                entry["bone_angle_from_vertical_deg"] = ang
                info = [f"SLOT {slot}  z={z}  {lane}",
                        f"paint the piece ON THIS CANVAS, transparent background",
                        f"proximal joint {prox} at template px ({p_prox[0]*k:.0f},{p_prox[1]*k:.0f})",
                        f"distal joint {dist} at template px ({p_dist[0]*k:.0f},{p_dist[1]*k:.0f})",
                        f"bone length {length:.1f} logical px = {length*k:.0f} template px, {ang:+.1f} deg from vertical",
                        f"keep the whole piece inside the canvas (no alpha touching edges)"]
            else:
                r = 3 * k
                d.ellipse([p_prox[0] * k - r, p_prox[1] * k - r, p_prox[0] * k + r, p_prox[1] * k + r], outline=(255, 60, 60, 255), width=2)
                d.text((p_prox[0] * k + 5 * k, p_prox[1] * k - 6 * k), f"{prox} ({int(p_prox[0])},{int(p_prox[1])})", fill=(255, 60, 60, 255), font=f_small)
                # cloth envelope hint: hips width from HIP_L/HIP_R +- 20 logical, hangs to mid-shin (KNEE y + 40)
                hl, hr = markers["HIP_L"], markers["HIP_R"]
                top_y = p_prox[1]; bot_y = markers["KNEE_L"][1] + 40
                left_x, right_x = hl[0] - 22, hr[0] + 22
                d.rectangle([left_x * k, top_y * k, right_x * k, bot_y * k], outline=(255, 240, 40, 255), width=2)
                entry["cloth_envelope_logical"] = {"top_y": top_y, "bottom_y_max": bot_y, "left_x": left_x, "right_x": right_x,
                                                   "note": "hanging cloth/faulds only, NO belt (torso owns the waist); must end above ground_y"}
                info = [f"SLOT {slot}  z={z}  {lane}",
                        "hanging cloth / faulds ONLY - no belt, no buckle (torso owns the waist in v1)",
                        f"top edge at HIP line y={top_y:.0f} (template px {top_y*k:.0f}); attach point HIP ({p_prox[0]:.0f},{p_prox[1]:.0f})",
                        f"bottom must stay above y={bot_y:.0f} logical (template px {bot_y*k:.0f}); never below ground y={ground_y}",
                        f"width envelope x {left_x:.0f}..{right_x:.0f} logical (yellow box)",
                        "transparent background, piece fully inside the canvas"]
            y = 4 * k
            for line in info:
                d.text((4 * k, y), line, fill=(255, 255, 255, 255), font=f_big)
                y += 11 * k
            d.text((4 * k, H - 12 * k), f"template {W}x{H} = {k}x logical 512  |  rig {m['rig_id']} {m['status']}  |  FRONT_3Q facing right", fill=(255, 255, 255, 200), font=f_small)
            name = f"regen_template__{slot}__front3q__{k}x.png"
            img.save(os.path.join(OUT_DIR, name))
            sidecar["templates"].setdefault(slot, {})[f"{k}x"] = dict(entry, file=name)
            if k == 2:
                sheet_cells.append((slot, img))
    with open(os.path.join(OUT_DIR, "regen_templates.json"), "w", encoding="utf-8") as f:
        json.dump(sidecar, f, indent="\t")
    # contact sheet (2x templates, 4 columns)
    cols = 4
    cw = 512
    rows = (len(sheet_cells) + cols - 1) // cols
    sheet = Image.new("RGBA", (cols * cw, rows * (cw + 24)), (40, 40, 44, 255))
    sd = ImageDraw.Draw(sheet)
    for i, (slot, img) in enumerate(sheet_cells):
        x, y = (i % cols) * cw, (i // cols) * (cw + 24)
        sheet.paste(img.resize((cw, cw), Image.LANCZOS), (x, y))
        sd.text((x + 4, y + cw + 4), slot, fill=(255, 255, 255, 255), font=font(14))
    sheet.save(os.path.join(OUT_DIR, "regen_templates__contact_sheet.png"))
    print("wrote", len(REGEN) * len(SCALES), "templates +", "regen_templates.json ->", OUT_DIR)


if __name__ == "__main__":
    sys.exit(main())
