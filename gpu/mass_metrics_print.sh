# Print NVIDIA Profiler metrics (GPU)
awk -f extract_metrics.awk gpu-comp/lapGPU1-metrics.log
awk -f extract_metrics.awk gpu-comp/lapGPU2-metrics.log
awk -f extract_metrics.awk gpu-comp/lapGPU3-metrics.log
awk -f extract_metrics.awk gpu-comp/lapGPU4-metrics.log
awk -f extract_metrics.awk gpu-comp/lapGPU5-metrics.log
awk -f extract_metrics.awk gpu-comp/lapGPU6-metrics.log
