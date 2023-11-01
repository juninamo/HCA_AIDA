#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-690
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellbender_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

conda init --all
source ~/.bashrc

#conda create -n cellbender
conda activate cellbender
## use x86_64 architecture channel(s)
#conda config --env --set subdir osx-64
#conda install python=3.7
#pip install cellbender

cd /scratch/alpine/jinamo@xsede.org/HCA

GEXFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" GEX_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA"
OUT_DIR="${DIR}/cellbender/${GEXFILE}"
mkdir -p ${OUT_DIR}

inputh5="${DIR}/GEX/${GEXFILE}/outs/raw_feature_bc_matrix.h5"
outputh5="${OUT_DIR}/cellbender_feature_bc_matrix.h5"

cellbender remove-background \
--input ${inputh5} \
--output ${outputh5} \
--fpr 0.01 \
--epochs 150 \
--cpu-threads 8

# sbatch scripts/HCA/HCA_cellbender.sh