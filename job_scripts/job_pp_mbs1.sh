#!/bin/bash
#SBATCH -A ACD114003
#SBATCH --job-name=pp_mbs1
#SBATCH --output=/home/u6172703/megatron_experiments/results/pp_mbs1_%j.out
#SBATCH --error=/home/u6172703/megatron_experiments/results/pp_mbs1_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --gres=gpu:8
#SBATCH --partition=gtest
#SBATCH --time=00:30:00

echo "=========================================="
echo "配置 4: Maximum PP (TP=1, PP=8, DP=1, MBS=1)"
echo "=========================================="
echo "開始時間: $(date)"

cd /home/u6172703/megatron_experiments
bash run_experiment.sh 1 8 1 pp_mbs1

echo "結束時間: $(date)"
