###################################################################
## Process EWAS                                                  ##
##                                                               ##
## James Staley                                                  ##
## University of Bristol                                         ##
## Email: james.staley@bristol.ac.uk                             ##
###################################################################

###################################################################
##### Set-up #####
###################################################################

##### Clear #####
rm(list=ls())

##### Options #####
options(stringsAsFactors = F)

##### Libraries ####
suppressMessages(library(data.table))

###################################################################
##### Methylation data #####
###################################################################
# just change the file names
nam <- "geo_ewas1_sub"

data <- fread(paste0(nam, ".txt"), header=T, sep="\t", data.table=F, colClasses="character")
studies <- data[,c("Author", "Consortium", "PMID", "Date", "Trait", "EFO", "Analysis", "Source", "Outcome", "Exposure", "Covariates", "Outcome_Units", "Exposure_Units", "Methylation_Array", "Tissue", "Further_Details", "N", "N_Cohorts", "Categories", "Age", "N_Males", "N_Females", "N_EUR", "N_EAS", "N_SAS", "N_AFR", "N_AMR", "N_OTH", "StudyID")]
studies <- studies[!duplicated(studies),]
write.table(studies, paste0(nam, "_studies.txt"), row.names=F, quote=F, sep="\t")
results <- data[,c("CpG", "Location", "Chr", "Pos", "Gene", "Type", "Beta", "SE", "P", "Details", "StudyID")]
write.table(results, paste0(nam, "_results.txt"), row.names=F, quote=F, sep="\t")

q("no")