#!/bin/bash
# Megatron-LM Llama2-7B 訓練啟動腳本 (修復版)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEGATRON_HOME="/work/u4876763/pretrain_megatron"

cd "$MEGATRON_HOME"

# 預設參數
TP_SIZE=2
PP_SIZE=2
MICRO_BATCH_SIZE=1
GLOBAL_BATCH_SIZE=4
SEQ_LENGTH=352
TRAIN_ITERS=100

# 解析參數
while [[ $# -gt 0 ]]; do
    case $1 in
        --tp)
            TP_SIZE="$2"
            shift 2
            ;;
        --pp)
            PP_SIZE="$2"
            shift 2
            ;;
        --micro-batch)
            MICRO_BATCH_SIZE="$2"
            shift 2
            ;;
        --global-batch)
            GLOBAL_BATCH_SIZE="$2"
            shift 2
            ;;
        --seq-len)
            SEQ_LENGTH="$2"
            shift 2
            ;;
        --train-iters)
            TRAIN_ITERS="$2"
            shift 2
            ;;
        *)
            echo "未知參數: $1"
            shift
            ;;
    esac
done

# 計算 DP
TOTAL_GPUS=8
DP_SIZE=$((TOTAL_GPUS / (TP_SIZE * PP_SIZE)))

echo "=========================================="
echo "Megatron-LM Llama2-7B 訓練"
echo "=========================================="
echo "TP=$TP_SIZE, PP=$PP_SIZE, DP=$DP_SIZE"
echo "MBS=$MICRO_BATCH_SIZE, GBS=$GLOBAL_BATCH_SIZE"
echo "Seq Length=$SEQ_LENGTH, Train Iters=$TRAIN_ITERS"
echo "=========================================="

# 建立訓練指令
TRAIN_CMD="
cd /workspace
export OMP_NUM_THREADS=1
torchrun \
    --nproc_per_node=8 \
    ./Megatron-LM/pretrain_gpt.py \
    --num-layers 32 \
    --hidden-size 4096 \
    --num-attention-heads 32 \
    --ffn-hidden-size 11008 \
    --seq-length $SEQ_LENGTH \
    --vocab-size 32000 \
    --max-position-embeddings 4096 \
    --tensor-model-parallel-size $TP_SIZE \
    --pipeline-model-parallel-size $PP_SIZE \
    --micro-batch-size $MICRO_BATCH_SIZE \
    --global-batch-size $GLOBAL_BATCH_SIZE \
    --train-iters $TRAIN_ITERS \
    --lr 0.0001 \
    --min-lr 0.00001 \
    --lr-warmup-iters 10 \
    --lr-decay-iters 90 \
    --lr-decay-style cosine \
    --adam-beta1 0.9 \
    --adam-beta2 0.95 \
    --weight-decay 0.1 \
    --clip-grad 1.0 \
    --fp16 \
    --recompute-activations \
    --log-interval 10 \
    --eval-interval 1000000 \
    --eval-iters 1 \
    --mock-data \
    --data-cache-path ./data_cache \
    --split 99,1,0 \
    --tokenizer-type Llama2Tokenizer \
    --tokenizer-model ./llama2_tokenizer/tokenizer.model
"

# 在容器中運行
echo "啟動訓練..."
echo ""

singularity exec --nv \
    -B "$MEGATRON_HOME:/workspace" \
    /work/u4876763/megatron-nv.sif \
    bash -c "$TRAIN_CMD"

echo ""
echo "訓練完成！"
