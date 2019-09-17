#!/bin/bash
#PBS -l nodes=1:ppn=10,walltime=72:00:00
### for submission as a job to bluecrystal

export WORK_DIR=  ### Add working directory
cd $WORK_DIR

# Modules --> Specfic to bluecrystal
module load languages/R-3.5.1-ATLAS-gcc-6.1
module load apps/tabix-0.2.6

# Process
# parse working directory for script and mapping file to R
wd="" ### Add in working directory here!!! 
map_file="" ### Add in mapping file name here!!! 
Rscript Scripts/process.R ${wd} ${map_file}
echo "Processing complete"

# Combine
cd Data/
for i in {1..22}
do
  # extract all the data from each chromosomal section
  tail -q -n +2 chr${i}_*.txt > data.txt
  # extract the headers
  head -n 1 chr${i}_dataset_1.txt > headers.txt
  # combine headers and rest of data
  cat headers.txt data.txt > chromosome${i}.txt
  # remove unneeded files
  rm headers.txt data.txt chr${i}_*
done
echo "Combine complete"

# VCF
Rscript ../Scripts/vcf.R

ewas_name="" ### Add ewas data name here e.g. geo_ewas1
tail -q -n +3 chromosome{1..22}.vcf > data.vcf
head -n 2 chromosome1.vcf > headers.vcf
cat headers.vcf data.vcf > ${ewas_name}.vcf
rm headers.vcf data.vcf chromosome*

echo "VCF complete"

# Tabix
bgzip ${ewas_name}.vcf
tabix -p vcf ${ewas_name}.vcf.gz
echo "Tabix complete"