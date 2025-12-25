#!/bin/bash
#SBATCH -A ACD114003
#SBATCH --job-name=balanced_mbs16
#SBATCH --output=/home/u6172703/megatron_experiments/results/balanced_mbs16_%j.out
#SBATCH --error=/home/u6172703/megatron_experiments/results/balanced_mbs16_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --gres=gpu:8
#SBATCH --partition=gtest
#SBATCH --time=00:30:00

echo "=========================================="
echo "配置 2: Balanced (TP=2, PP=2, DP=2, MBS=16)"
echo "=========================================="
echo "開始時間: $(date)"

cd /home/u6172703/megatron_experiments
bash run_experiment.sh 2 2 16 balanced_mbs16

echo "結束時間: $(date)"
