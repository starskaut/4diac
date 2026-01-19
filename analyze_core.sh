#!/bin/bash

# Analyze core dump files using GDB
# Generates crash reports with backtraces

if [ -z "$1" ]; then
    echo "Usage: $0 <program_name>"
    echo "Example: $0 python3"
    exit 1
fi

PROGRAM=$1
CORE_DIR="./core_dumps"
REPORT_DIR="$CORE_DIR/crash_reports"

echo "[INFO] ============================================"
echo "[INFO]    Core Dump Analyzer v2.0"
echo "[INFO] ============================================"
echo ""

# Create report directory if it doesn't exist
mkdir -p "$REPORT_DIR"

# Check kernel settings
echo "[INFO] Checking kernel settings..."
if [ -r /proc/sys/kernel/core_pattern ]; then
    PATTERN=$(cat /proc/sys/kernel/core_pattern)
    echo "[✓] kernel.core_pattern = $PATTERN"
fi

LIMIT=$(ulimit -c)
echo "[✓] ulimit -c = $LIMIT"
echo ""

# Find and analyze core files
echo "[INFO] Searching for core files..."
CORE_COUNT=0

# Look for core files in project directory
for corefile in core core.* $CORE_DIR/core.*; do
    if [ -f "$corefile" ]; then
        CORE_COUNT=$((CORE_COUNT + 1))
        echo "[✓] Found: $corefile"
        
        # Generate report
        REPORT_FILE="$REPORT_DIR/$(basename $corefile).report.txt"
        
        echo "[INFO] Analyzing: $corefile"
        
        # Run GDB and get backtrace
        gdb -batch -ex "bt full" -ex "quit" $PROGRAM "$corefile" > "$REPORT_FILE" 2>&1
        
        echo "[✓] Report saved: $REPORT_FILE"
        echo ""
    fi
done

# Also check in home cores directory
if [ -d "$HOME/cores" ]; then
    for corefile in "$HOME/cores"/core.*; do
        if [ -f "$corefile" ]; then
            CORE_COUNT=$((CORE_COUNT + 1))
            echo "[✓] Found: $corefile"
            
            REPORT_FILE="$REPORT_DIR/$(basename $corefile).report.txt"
            echo "[INFO] Analyzing: $corefile"
            
            gdb -batch -ex "bt full" -ex "quit" $PROGRAM "$corefile" > "$REPORT_FILE" 2>&1
            
            echo "[✓] Report saved: $REPORT_FILE"
            echo ""
        fi
    done
fi

# Generate summary
SUMMARY_FILE="$REPORT_DIR/SUMMARY.txt"
cat > "$SUMMARY_FILE" << EOF
Core Dump Analysis Summary
==========================
Generated: $(date)
Program: $PROGRAM
Total core files found: $CORE_COUNT

Report files:
EOF

for reportfile in "$REPORT_DIR"/*.report.txt; do
    if [ -f "$reportfile" ]; then
        echo "  - $(basename $reportfile)" >> "$SUMMARY_FILE"
    fi
done

echo "" >> "$SUMMARY_FILE"
echo "All reports are in: $REPORT_DIR/" >> "$SUMMARY_FILE"

echo "[INFO] ============================================"
if [ $CORE_COUNT -eq 0 ]; then
    echo "[!] No core files found"
else
    echo "[✓] Analysis complete! Found $CORE_COUNT core file(s)"
fi
echo "[✓] Summary saved: $SUMMARY_FILE"
echo ""
