"""Before/after comparison of two Golden Rig Lab validation snapshots (…__validation.json).

Usage:
    python compare_validation.py <before.json> <after.json> [<out.md>]
Prints (and optionally writes) a Markdown report: per-slot errors, warnings and distal-fit
drift/angle before vs after, plus resolved / new / persisting error codes.
"""
from __future__ import annotations

import json
import sys


def load(p):
    with open(p, encoding="utf-8") as f:
        return json.load(f)


def codes(items):
    return sorted({m.split(" ", 1)[0] for m in items})


def fmt_fit(fit):
    if not fit:
        return "-", "-"
    return f"{fit['drift_px']:.1f}", f"{fit['angle_mismatch_deg']:+.1f}"


def main(argv):
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except (AttributeError, ValueError):
        pass
    if len(argv) < 2:
        print(__doc__)
        return 2
    before, after = load(argv[0]), load(argv[1])
    lines = []
    lines.append(f"# Validation comparison - {after.get('armor_set')} / {after.get('view')} / {after.get('facing')}")
    lines.append("")
    lines.append(f"| | before | after |\n|---|---:|---:|")
    lines.append(f"| rig verified (GR022/GR023) | {before.get('rig_verified')} | {after.get('rig_verified')} |")
    lines.append(f"| errors | {before.get('error_count')} | {after.get('error_count')} |")
    lines.append(f"| warnings | {before.get('warning_count')} | {after.get('warning_count')} |")
    lines.append(f"| ok | {before.get('ok')} | {after.get('ok')} |")
    lines.append("")
    lines.append("| slot | texture before -> after | errors before -> after | drift px before -> after | angle deg before -> after | resolved | new |")
    lines.append("|---|---|---|---:|---:|---|---|")
    slots = sorted(set(before["slots"]) | set(after["slots"]))
    for s in slots:
        b = before["slots"].get(s, {})
        a = after["slots"].get(s, {})
        bc, ac = codes(b.get("errors", [])), codes(a.get("errors", []))
        bd, ba = fmt_fit(b.get("fit"))
        ad, aa = fmt_fit(a.get("fit"))
        resolved = sorted(set(bc) - set(ac))
        new = sorted(set(ac) - set(bc))
        lines.append(f"| {s} | {b.get('texture','-')} -> {a.get('texture','-')} | {len(b.get('errors',[]))} -> {len(a.get('errors',[]))} | {bd} -> {ad} | {ba} -> {aa} | {', '.join(resolved) or '-'} | {', '.join(new) or '-'} |")
    lines.append("")
    lines.append("## Remaining errors (after)")
    for s in slots:
        for e in after["slots"].get(s, {}).get("errors", []):
            lines.append(f"- **{s}**: {e}")
    for e in after.get("global_errors", []):
        lines.append(f"- **global**: {e}")
    lines.append("")
    lines.append("## Remaining warnings (after)")
    for s in slots:
        for wmsg in after["slots"].get(s, {}).get("warnings", []):
            lines.append(f"- {s}: {wmsg}")
    out = "\n".join(lines) + "\n"
    print(out)
    if len(argv) >= 3:
        with open(argv[2], "w", encoding="utf-8") as f:
            f.write(out)
        print("wrote", argv[2])
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
