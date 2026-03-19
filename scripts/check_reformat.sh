#!/bin/bash
# Recompile modified .spin2 files and compare .bin output against .bin.GOLD baselines
# Usage: ./scripts/check_reformat.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

pass=0
fail=0
skip=0
failed_files=()
no_gold_files=()

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
        echo "--- Skipping: $filename (no .bin.GOLD file) ---"
        no_gold_files+=("$filename")
        ((skip++))
        echo ""
        continue
    fi

    # Skip if source is older than the .bin file (not modified since last compile)
    if [ -f "$binfile" ] && [ "$binfile" -nt "$file" ]; then
        continue
    fi

    echo "--- Checking: $filename (modified) ---"
    ((checked++))

    # Compile with debug
    output="$(pnut_ts -d "$file" 2>&1)"
    rc=$?
    echo "$output"
    if [ $rc -ne 0 ] || echo "$output" | grep -q ":error:"; then
        echo "  FAIL: Compilation error"
        ((fail++))
        failed_files+=("$filename (compile error)")
        echo ""
        continue
    fi

    # Compare md5 sums
    md5_bin=$(md5 -q "$binfile")
    md5_gold=$(md5 -q "$goldfile")
    if [ "$md5_bin" = "$md5_gold" ]; then
        echo "  PASS: md5 match ($md5_bin)"
        ((pass++))
    else
        echo "  FAIL: md5 mismatch"
        echo "    .bin:      $md5_bin"
        echo "    .bin.GOLD: $md5_gold"
        ((fail++))
        failed_files+=("$filename (md5 mismatch)")
    fi
    echo ""
done

echo "=== Results ==="
echo "  Passed:  $pass"
echo "  Failed:  $fail"
echo "  Skipped: $skip"
if [ ${#no_gold_files[@]} -gt 0 ]; then
    echo "  Missing .gold files:"
    for f in "${no_gold_files[@]}"; do
        echo "    - $f"
    done
fi
if [ $fail -gt 0 ]; then
    echo "  Failed files:"
    for f in "${failed_files[@]}"; do
        echo "    - $f"
    done
    exit 1
fi
if [ $checked -eq 0 ] && [ $skip -eq 0 ]; then
    echo "  No .spin2 files newer than their .bin.GOLD — nothing to check."
elif [ $fail -eq 0 ] && [ $pass -gt 0 ]; then
    echo "  All reformatted files produce identical binaries!"
fi
exit 0
