#!/bin/bash
# Recompile modified .spin2 files and compare .bin output against .bin.GOLD baselines
# Usage: ./scripts/check_reformat.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

pass=0
fail=0
skip=0
checked=0

echo "=== Checking reformatted .spin2 files ==="
echo "    Using: $(pnut_ts --version 2>&1 | head -1)"
echo ""

for file in "$PROJECT_DIR"/*.spin2; do
    filename="$(basename "$file")"
    binfile="${file%.spin2}.bin"
    goldfile="${file%.spin2}.bin.GOLD"

    # Skip if no gold file exists
    if [ ! -f "$goldfile" ]; then
        echo "  SKIP: $filename (no .bin.GOLD file)"
        ((skip++))
        continue
    fi

    # Skip if source is older than the .bin file (not modified since last compile)
    if [ -f "$binfile" ] && [ "$binfile" -nt "$file" ]; then
        continue
    fi

    ((checked++))

    # Compile with debug (suppress output)
    output="$(pnut_ts -d "$file" 2>&1)"
    rc=$?
    if [ $rc -ne 0 ] || echo "$output" | grep -q ":error:"; then
        echo "  FAIL: $filename (compile error)"
        ((fail++))
        continue
    fi

    # Compare md5 sums
    md5_bin=$(md5 -q "$binfile")
    md5_gold=$(md5 -q "$goldfile")
    if [ "$md5_bin" = "$md5_gold" ]; then
        echo "  PASS: $filename"
        ((pass++))
    else
        echo "  FAIL: $filename (md5 mismatch)"
        echo "        .bin:      $md5_bin"
        echo "        .bin.GOLD: $md5_gold"
        ((fail++))
    fi
done

echo ""
echo "=== Results: $pass passed, $fail failed, $skip skipped ==="
if [ $checked -eq 0 ] && [ $skip -eq 0 ]; then
    echo "  Nothing to check — no .spin2 files newer than their .bin"
fi
if [ $fail -gt 0 ]; then
    exit 1
fi
exit 0
