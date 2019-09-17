#!/bin/bash
#PBS -l nodes=1:ppn=10,walltime=72:00:00
### for submission as a job to bluecrystal

export WORK_DIR=    ### Add working directory
cd $WORK_DIR

# Modules --> Specfic to bluecrystal
module load languages/R-3.5.1-ATLAS-gcc-6.1
module load apps/tabix-0.2.6

# Process
# parse working directory for script and mapping file to R
wd="" ### Add in working directory here!!! 
map_file="" ### Add in mapping file name here!!! 
Rscript Scripts/process_sub.R ${wd} ${map_file}
echo "Processing complete"

# Dataset
cd Data/
dataset_n=$(ll ../ | grep "GSE" | wc -l)

ewas_name="" ### Add ewas data name here e.g. geo_ewas1_sub
eval tail -q -n +3 dataset_{1..$dataset_n}_sub.txt > data_sub.txt
head -n 2 dataset_1_sub.txt > headers_sub.txt
cat headers_sub.txt data_sub.txt > ${ewas_name}.txt
rm headers_sub.txt data_sub.txt dataset_*_sub.txt

# Process
Rscript ../process_sub_mysql.R 

# Gzip 
gzip ${ewas_name}*
echo "Dataset complete"

# Create data for MySQL