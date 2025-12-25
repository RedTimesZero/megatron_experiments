# Megatron-LM Llama2-7B 預訓練實驗

完整的 Megatron-LM 實驗環境，用於測試 5 種不同的並行配置。

## 📁 目錄結構

```
megatron_experiments/
├── run_experiment.sh       # 單次實驗運行腳本
├── submit_all.sh           # 批次提交所有實驗
├── analyze_results.py      # 結果分析腳本
├── README.md              # 本文件
├── job_scripts/           # SLURM 作業腳本
│   ├── job_dp_mbs1.sh
│   ├── job_dp_mbs16.sh
│   ├── job_balanced_mbs1.sh
│   ├── job_balanced_mbs16.sh
│   ├── job_tp_mbs1.sh
│   ├── job_tp_mbs16.sh
│   ├── job_pp_mbs1.sh
│   ├── job_pp_mbs16.sh
│   ├── job_maxtp_mbs1.sh
│   └── job_maxtp_mbs16.sh
└── results/               # 實驗結果輸出
```

## 🚀 快速開始

### 步驟 1: 批次提交所有實驗

```bash
cd ~/megatron_experiments
chmod +x submit_all.sh run_experiment.sh
./submit_all.sh
```

這會提交全部 10 個實驗作業（5 種配置 × 2 種 MBS）。

### 步驟 2: 監控作業狀態

```bash
# 查看作業隊列
squeue -u $USER

# 實時查看特定作業的輸出
tail -f results/dp_mbs1_*.out
```

### 步驟 3: 分析結果

```bash
# 等待作業完成後，運行分析腳本
python3 analyze_results.py
```

## 📊 實驗配置

總共 5 種並行配置，每種測試 MBS=1 和 MBS=16：

| 配置 | TP | PP | DP | 描述 | MBS | GBS |
|------|----|----|----|----|-----|-----|
| DP-focused | 1 | 1 | 8 | 純數據並行 | 1 | 8 |
| DP-focused | 1 | 1 | 8 | 純數據並行 | 16 | 128 |
| Balanced | 2 | 2 | 2 | 平衡策略 | 1 | 2 |
| Balanced | 2 | 2 | 2 | 平衡策略 | 16 | 32 |
| TP-focused | 4 | 1 | 2 | 張量並行優先 | 1 | 2 |
| TP-focused | 4 | 1 | 2 | 張量並行優先 | 16 | 32 |
| Maximum PP | 1 | 8 | 1 | 完全流水線並行 | 1 | 1 |
| Maximum PP | 1 | 8 | 1 | 完全流水線並行 | 16 | 16 |
| Maximum TP | 8 | 1 | 1 | 完全張量並行 | 1 | 1 |
| Maximum TP | 8 | 1 | 1 | 完全張量並行 | 16 | 16 |

## 🔧 手動運行單個實驗

如果需要單獨提交某個配置：

```bash
# 例如：運行 Balanced MBS=1
sbatch job_scripts/job_balanced_mbs1.sh

# 或直接使用運行腳本
cd ~/megatron_experiments
./run_experiment.sh 2 2 1 balanced_mbs1
```

## 📈 結果指標

每個實驗會測量：
- **Throughput (tokens/s)**: 訓練吞吐量
- **Peak Memory per GPU (GB)**: 每個 GPU 的峰值內存使用

如果出現 OOM 錯誤，結果會標記為 "OOM"。

## 🔍 故障排除

### 查看錯誤日誌
```bash
ls -lh results/*.err
cat results/dp_mbs1_*.err
```

### 重新提交失敗的作業
```bash
sbatch job_scripts/job_<config>.sh
```

### 檢查 Megatron-LM 設置
```bash
ls -la /work/u4876763/pretrain_megatron/
singularity exec /work/u4876763/megatron-nv.sif ls /workspace/
```

## 📝 注意事項

1. **資源需求**: 每個作業需要 8× V100 GPU
2. **運行時間**: 每個實驗約 15-30 分鐘
3. **存儲空間**: 確保有足夠的空間存放日誌
4. **佇列系統**: 使用 `gp4d` 分區

## 🎯 實驗目標

測量並分析：
1. 不同並行策略對吞吐量的影響
2. 不同配置的內存使用情況
3. Micro Batch Size 對性能的影響
4. 識別最優配置
