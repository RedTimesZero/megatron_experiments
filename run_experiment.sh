#!/bin/bash
# ===============================================
# Megatron-LM Llama2-7B 單次實驗運行腳本
# ===============================================

set -e

# 檢查參數
if [ $# -lt 3 ]; then
    echo "用法: $0 <TP> <PP> <MICRO_BATCH_SIZE> [實驗名稱]"
    echo "範例: $0 2 2 1 balanced_mbs1"
    exit 1
fi

TP=$1
PP=$2
MICRO_BATCH=$3
EXP_NAME=${4:-"exp_tp${TP}_pp${PP}_mbs${MICRO_BATCH}"}

# 計算 DP 和 Global Batch Size
TOTAL_GPUS=8
DP=$((TOTAL_GPUS / (TP * PP)))
GLOBAL_BATCH=$((MICRO_BATCH * DP))

echo "=========================================="
echo "實驗配置: $EXP_NAME"
echo "=========================================="
echo "TP=$TP, PP=$PP, DP=$DP"
echo "Micro Batch Size=$MICRO_BATCH"
echo "Global Batch Size=$GLOBAL_BATCH"
echo "=========================================="

MEGATRON_HOME="/work/u4876763/pretrain_megatron"

# 進入 pretrain_megatron 目錄並執行他們的 run.sh
cd "$MEGATRON_HOME"

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

# 調用他們的 run.sh，傳遞參數
bash ./run.sh \
    --tp "$TP" \
    --pp "$PP" \
    --micro-batch "$MICRO_BATCH" \
    --global-batch "$GLOBAL_BATCH"

EXIT_CODE=$?
echo ""
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ 實驗 $EXP_NAME 完成！"
else
    echo "✗ 實驗 $EXP_NAME 失敗 (exit code: $EXIT_CODE)"
fi
echo "=========================================="

exit $EXIT_CODE
