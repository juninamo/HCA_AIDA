#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-690
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellranger_count_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

export PATH=/pl/active/fanzhanglab/jinamo/tools/cellranger-7.2.0/bin/:$PATH


cd /scratch/alpine/jinamo@xsede.org/HCA

GEXFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" GEX_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/GEX"
mkdir -p ${DIR}

if [ ! -e "${DIR}/${GEXFILE}/outs/possorted_genome_bam.bam" ]; then
cellranger count \
--id=${GEXFILE}_GEX \
--fastqs=/scratch/alpine/jinamo@xsede.org/HCA/fastq/${GEXFILE}/ \
--transcriptome=/pl/active/fanzhanglab/jinamo/tools/refdata-gex-GRCh38-2020-A \
--output-dir=${DIR}/${GEXFILE} \
--localcores=8 --localmem=30
fi
