#!/bin/bash

# Get GPU and VRAM usage from radeontop
read -r _ gpu_usage _ vram_usage _ < <(radeontop -d - -l 1 | grep -E 'gpu|vram')

# Get GPU temperature from sensors
gpu_temp=$(sensors | grep -E 'edge' | awk '{print $2}' | sed 's/+//' | sed 's/°C//')

# Get GPU clock from radeontop
gpu_clk=$(radeontop -d - -l 1 | grep 'sclk' | awk '{print $3}')

echo "GPU: $gpu_usage% | VRAM: $vram_usage% | $gpu_temp°C | $gpu_clk MHz"
