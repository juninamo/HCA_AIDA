#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-200
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --time=01:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_fastq_download_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

# this is example for samples 1-200
# to download all samples, need to run array jobs 1-1712

mkdir -p /scratch/alpine/jinamo@xsede.org/HCA/fastq/
cd /scratch/alpine/jinamo@xsede.org/HCA/fastq/

# Read a specific line from config_list.txt
CONFIGFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" config_list.txt)

# curlを使用してダウンロードを実行
curl --config $CONFIGFILE

# sbatch scripts/HCA/HCA_fastq_download_parallel_1_200.sh