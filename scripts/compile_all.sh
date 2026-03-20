#!/bin/bash
# Compile all .spin2 files in the project root with DEBUG enabled using PNut_TS
# Usage: ./scripts/compile_all.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

pass=0
fail=0
failed_files=()

echo "=== Compiling all .spin2 files with DEBUG ==="
echo "    Using: $(pnut_ts --version 2>&1 | head -1)"
echo ""

for file in "$PROJECT_DIR"/*.spin2; do
    filename="$(basename "$file")"
    echo "--- Compiling: $filename ---"
    output="$(pnut_ts -d -l -m "$file" 2>&1)"
    rc=$?
    echo "$output"
    if [ $rc -ne 0 ] || echo "$output" | grep -q ":error:"; then
        ((fail++))
        failed_files+=("$filename")
    else
        ((pass++))
    fi
    echo ""
done

echo "=== Results ==="
echo "  Passed: $pass"
echo "  Failed: $fail"
if [ $fail -gt 0 ]; then
    echo "  Failed files:"
    for f in "${failed_files[@]}"; do
        echo "    - $f"
    done
    exit 1
fi
echo "  All files compiled successfully!"
exit 0
