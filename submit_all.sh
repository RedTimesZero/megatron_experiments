#!/bin/bash
# ===============================================
# 批次提交所有實驗作業
# ===============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOB_DIR="$SCRIPT_DIR/job_scripts"

echo "=========================================="
echo "開始批次提交 Megatron-LM 實驗"
echo "=========================================="

# # 配置清單
configs=(
    "balanced_mbs1:Balanced MBS=1"
    "balanced_mbs16:Balanced MBS=16"
    "tp_mbs1:TP-focused MBS=1"
)

# 配置清單
# configs=(
#     # "pp_mbs1:Maximum PP MBS=1"
#     # "pp_mbs16:Maximum PP MBS=16"
#     # "maxtp_mbs1:Maximum TP MBS=1"
#     "maxtp_mbs16:Maximum TP MBS=16"
# )


# 提交所有作業
for config in "${configs[@]}"; do
    name="${config%%:*}"
    desc="${config#*:}"
    
    echo ""
    echo "提交: $desc"
    job_file="$JOB_DIR/job_${name}.sh"
    
    if [ -f "$job_file" ]; then
        job_id=$(sbatch "$job_file" | awk '{print $4}')
        echo "  → 作業 ID: $job_id"
        sleep 1  # 避免過快提交
    else
        echo "  ✗ 找不到檔案: $job_file"
    fi
done

echo ""
echo "=========================================="
echo "所有作業已提交！"
echo "=========================================="
echo ""
echo "查看作業狀態: squeue -u \$USER"
echo "查看結果: ls -lh $SCRIPT_DIR/results/"
echo ""
