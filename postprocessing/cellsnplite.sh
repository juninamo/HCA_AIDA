#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-690
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellsnplite_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

module load anaconda

# conda config --add channels bioconda
# conda config --add channels conda-forge
# conda create -n CSP cellsnp-lite
conda activate CSP

cd /scratch/alpine/jinamo@xsede.org/HCA

GEXFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" GEX_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA"
OUT_DIR="${DIR}/cellsnplite/${GEXFILE}"

mkdir -p ${OUT_DIR}

BAM="${DIR}/GEX/${GEXFILE}/possorted_genome_bam.bam"
BARCODE="${DIR}/GEX/${GEXFILE}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz"
REGION_VCF="${DIR}/cellsnplite/genome1K.phase3.SNP_AF5e2.chr1toX.hg38.vcf.gz"
cellsnp-lite -s $BAM -b $BARCODE -O $OUT_DIR -R $REGION_VCF -p 8 --minMAF 0.1 --minCOUNT 20 --gzip