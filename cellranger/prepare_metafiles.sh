#!/bin/sh
#$ -S /bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_prepare.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

cd /scratch/alpine/jinamo@xsede.org/HCA/fastq
ls | grep -v "samples.txt" > samples.txt

downloaded_meta_file="AIDA_meta.tsv"
selected_meta_file="AIDA_meta_selected.tsv"
cd /scratch/alpine/jinamo@xsede.org/HCA/
awk -F "\t" '{print $3 "\t" $7 "\t" $9 "\t" $25 "\t" $28 "\t" $32 "\t" $38 "\t" $44}' $downloaded_meta_file > $selected_meta_file

LIBRARY_COLUMN=25  # library_preparation_protocol.library_construction_approach
UUID_COLUMN=3     # bundle_uuid

# awk で該当する行を特定し、bundle_uuid 列の値を取得
awk -F'\t' -v lib_col="$LIBRARY_COLUMN" -v uuid_col="$UUID_COLUMN" 'NR>1 && ($lib_col == "10x 5'\'' v1" || $lib_col == "10x 5'\'' v2") {print $uuid_col}' $downloaded_meta_file | sort -u > GEX_list.txt
awk -F'\t' -v lib_col="$LIBRARY_COLUMN" -v uuid_col="$UUID_COLUMN" 'NR>1 && ($lib_col == "BCR 10x 5'\'' v2") {print $uuid_col}' $downloaded_meta_file | sort -u > BCR_list.txt
awk -F'\t' -v lib_col="$LIBRARY_COLUMN" -v uuid_col="$UUID_COLUMN" 'NR>1 && ($lib_col == "TCR 10x 5'\'' v2") {print $uuid_col}' $downloaded_meta_file | sort -u > TCR_list.txt

cat GEX_list.txt | wc -l
# 690
cat BCR_list.txt | wc -l
# 41
cat TCR_list.txt | wc -l
# 41

# Rename file which is compatible for cellranger
while read -r dir; do
    cd "/scratch/alpine/jinamo@xsede.org/HCA/fastq/${dir}/"
    for file in *.R1.fastq.gz; do
        new_name="${file%.R1.fastq.gz}_S1_L002_R1_001.fastq.gz"
        mv "$file" "$new_name"
    done
    for file in *.R2.fastq.gz; do
        new_name="${file%.R2.fastq.gz}_S1_L002_R2_001.fastq.gz"
        mv "$file" "$new_name"
    done
done < GEX_list.txt

while read -r dir; do
    cd "/scratch/alpine/jinamo@xsede.org/HCA/fastq/${dir}/"
	for file in *_R1_001.fastq.gz; do
	    new_name="${file%_R1_001.fastq.gz}_S1_L001_R1_001.fastq.gz"
	    mv "$file" "$new_name"
	done
	for file in *_R2_001.fastq.gz; do
	    new_name="${file%_R2_001.fastq.gz}_S1_L001_R2_001.fastq.gz"
	    mv "$file" "$new_name"
	done
done < BCR_list.txt

while read -r dir; do
    cd "/scratch/alpine/jinamo@xsede.org/HCA/fastq/${dir}/"
	for file in *_R1_001.fastq.gz; do
	    new_name="${file%_R1_001.fastq.gz}_S1_L001_R1_001.fastq.gz"
	    mv "$file" "$new_name"
	done
	for file in *_R2_001.fastq.gz; do
	    new_name="${file%_R2_001.fastq.gz}_S1_L001_R2_001.fastq.gz"
	    mv "$file" "$new_name"
	done
done < TCR_list.txt