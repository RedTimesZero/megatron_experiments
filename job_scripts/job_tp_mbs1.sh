#!/bin/bash
#SBATCH -A ACD114003
#SBATCH --job-name=tp_mbs1
#SBATCH --output=/home/u6172703/megatron_experiments/results/tp_mbs1_%j.out
#SBATCH --error=/home/u6172703/megatron_experiments/results/tp_mbs1_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --gres=gpu:8
#SBATCH --partition=gtest
#SBATCH --time=00:30:00

echo "=========================================="
echo "配置 3: TP-focused (TP=4, PP=1, DP=2, MBS=1)"
echo "=========================================="
echo "開始時間: $(date)"

cd /home/u6172703/megatron_experiments
bash run_experiment.sh 4 1 1 tp_mbs1

echo "結束時間: $(date)"
