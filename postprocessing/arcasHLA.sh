#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-690
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_arcasHLA_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

module load anaconda

conda activate arcasHLA

cd /scratch/alpine/jinamo@xsede.org/HCA

GEXFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" GEX_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/arcasHLA"
DIR="${DIR}/${GEXFILE}"
mkdir -p ${DIR}


/pl/active/fanzhanglab/jinamo/tools/arcasHLA/arcasHLA extract --single --unmapped /pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/GEX/${GEXFILE}/outs/possorted_genome_bam.bam -o ${DIR} -t 8 -v
/pl/active/fanzhanglab/jinamo/tools/arcasHLA/arcasHLA genotype --single ${DIR}/possorted_genome_bam.extracted.fq.gz -g all -o ${DIR} -t 8 -v
cat ${DIR}/possorted_genome_bam.genotype.json
/pl/active/fanzhanglab/jinamo/tools/arcasHLA/arcasHLA partial --single ${DIR}/possorted_genome_bam.extracted.fq.gz -g all -G ${DIR}/possorted_genome_bam.genotype.json -o ${DIR} -t 8 -v
cat ${DIR}/possorted_genome_bam.partial_genotype.json
