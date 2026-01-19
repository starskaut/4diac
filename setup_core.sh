#!/bin/bash

# Setup core dump configuration for WSL2
# Enables core dump generation for debugging

echo "[INFO] Core Dump Setup v1.0"
echo "[INFO] ============================================"

# Enable unlimited core size
echo "[INFO] Enabling unlimited core size..."
ulimit -c unlimited
echo "[✓] ulimit -c = $(ulimit -c)"

# Create core dumps directory
CORE_DIR="$HOME/cores"
if [ ! -d "$CORE_DIR" ]; then
    mkdir -p "$CORE_DIR"
    echo "[✓] Created core dump directory: $CORE_DIR"
else
    echo "[✓] Core dump directory exists: $CORE_DIR"
fi

# Set core pattern (if permissions allow)
if [ -w /proc/sys/kernel/core_pattern ]; then
    echo "[INFO] Setting kernel.core_pattern..."
    echo "$CORE_DIR/core.%e.%p.%t" | sudo tee /proc/sys/kernel/core_pattern > /dev/null
    echo "[✓] kernel.core_pattern configured"
else
    echo "[!] Cannot write to /proc/sys/kernel/core_pattern (may need sudo)"
fi

# Create local core_dumps directory for this project
if [ ! -d "./core_dumps" ]; then
    mkdir -p ./core_dumps/crash_reports
    echo "[✓] Created ./core_dumps directory"
fi

echo "[INFO] ============================================"
echo "[✓] Setup complete!"
echo ""
echo "Core dump settings:"
echo "  - Core file limit: $(ulimit -c)"
echo "  - Core directory: $CORE_DIR"
echo "  - Project cores: ./core_dumps/"
