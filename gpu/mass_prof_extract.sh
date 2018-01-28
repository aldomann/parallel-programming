# Extract perf stat info (CPU)
awk -f extract_perf.awk cpu-comp/lapCPU1-perf.log > results/lapCPU1.dat
awk -f extract_perf.awk cpu-comp/lapCPU2-perf.log > results/lapCPU2.dat
awk -f extract_perf.awk cpu-comp/lapCPU3-perf.log > results/lapCPU3.dat
awk -f extract_perf.awk cpu-comp/lapCPU4-perf.log > results/lapCPU4.dat

# Extract NVIDIA Profiler info (GPU)
awk -f extract_nvp.awk gpu-comp/lapGPU1-nvp-bad.log > results/lapGPU1-bad.dat
awk -f extract_nvp.awk gpu-comp/lapGPU1-nvp.log > results/lapGPU1.dat
awk -f extract_nvp.awk gpu-comp/lapGPU2-nvp.log > results/lapGPU2.dat
awk -f extract_nvp.awk gpu-comp/lapGPU3-nvp.log > results/lapGPU3.dat
awk -f extract_nvp.awk gpu-comp/lapGPU4-nvp.log > results/lapGPU4.dat
awk -f extract_nvp.awk gpu-comp/lapGPU5-nvp.log > results/lapGPU5.dat
awk -f extract_nvp.awk gpu-comp/lapGPU6-nvp.log > results/lapGPU6.dat
