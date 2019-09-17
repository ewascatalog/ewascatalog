
# Process full EWAS datasets

Scripts to process full EWAS datasets. So far, EWAS have been performed in ARIES and using some cleaned GEO datasets that were extracted using the geograbbi package (https://github.com/yousefi138/geograbi)

## Scripts
### Data processing of overall file
process.sh - processes the output of the ARIES EWAS into an indexed VCF file. This script first uses process.R to processs the data into chromosome-specific files. These files are then combined using bash code and processed into ordered VCF files using vcf.R. Further bash code combines these chromosome-specific VCF files into a single VCF file, which is then zipped and indexed.    
process.R - processes the results from the ARIES EWAS pipeline using meffil (for cpg annotation) and the mapping file (for EWAS meta-data). This script is called by process.sh and creates chromosome-specific datasets, which process.sh then combines and processes into an ordered indexed VCF file.
vcf.R - orders and processes the chrocmosome-specific data files output by process.R and process.sh into ordered VCF files.

### Data processing of all associations with p<E-4
process_sub.sh - processes the output of the ARIES EWAS into a subsetted file with results with p<1E-4. This script first uses process.R to subset and process all of the original datasets, and then uses bash code to combine them. The resulting file is then processed by process_sub_mysql.R into the aries_*_studies.txt and aries_*_results.txt files, which can then be processed into the SQL database.
process_sub.R - processes the results from the ARIES EWAS pipeline using meffil (for cpg annotation) and the mapping file (for EWAS meta-data). This script also subsets the data so that only results with p<1E-4 are kept. 
process_sub_mysql.R - creates the datasets required to generate the SQL database, i.e. the aries_*_studies.txt and aries_*_results.txt files.

## Map
Both files contain characteristics of the data for each phenotype, e.g. trait name, number of individuals in the analysis, the EFO, covariates etc.