#!/bin/bash
#SBATCH -A ACD114003
#SBATCH --job-name=dp_mbs1
#SBATCH --output=/home/u6172703/megatron_experiments/results/dp_mbs1_%j.out
#SBATCH --error=/home/u6172703/megatron_experiments/results/dp_mbs1_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --gres=gpu:8
#SBATCH --partition=gtest
#SBATCH --time=00:30:00

echo "=========================================="
echo "配置 1: DP-focused (TP=1, PP=1, DP=8, MBS=1)"
echo "=========================================="
echo "開始時間: $(date)"

cd /home/u6172703/megatron_experiments
bash run_experiment.sh 1 1 1 dp_mbs1

echo "結束時間: $(date)"
