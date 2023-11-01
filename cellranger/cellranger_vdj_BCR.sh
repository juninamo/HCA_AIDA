#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-41
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellranger_BCR_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

export PATH=/pl/active/fanzhanglab/jinamo/tools/cellranger-7.2.0/bin/:$PATH

cd /scratch/alpine/jinamo@xsede.org/HCA

## BCR

BCRFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" BCR_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/BCR"
mkdir -p ${DIR}

cellranger vdj \
--id=${BCRFILE}_BCR \
--fastqs=/scratch/alpine/jinamo@xsede.org/HCA/fastq/${BCRFILE} \
--reference=/pl/active/fanzhanglab/jinamo/tools/refdata-cellranger-vdj-GRCh38-alts-ensembl-7.1.0 \
--output-dir=${DIR}/${BCRFILE} \
--localcores=8 --localmem=30
