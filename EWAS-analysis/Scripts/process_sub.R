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

##### Arguments #####
args  <-  commandArgs(trailingOnly = TRUE)
wd <- args[1] # Working directory 
map_file <- args[2] # map file

##### Set working directory #####
setwd(wd)

##### Libraries ####
suppressMessages(library(data.table))
suppressMessages(library(Hmisc))
suppressMessages(library(dplyr))
suppressWarnings(suppressMessages(library(meffil)))

###################################################################
##### Methylation annotation #####
###################################################################

annotation <- meffil.get.features("450k")
names(annotation)[names(annotation)=="name"] <- "CpG"
names(annotation)[names(annotation)=="chromosome"] <- "Chr"
annotation$Chr <- sub("chr", "", annotation$Chr)
names(annotation)[names(annotation)=="position"] <- "Pos"
annotation$Location <- paste0("chr", annotation$Chr, ":", annotation$Pos)
annotation$Gene <- unlist(lapply(annotation$gene.symbol, function(x){paste(unique(unlist(strsplit(x, ";"))), collapse=";")}))
annotation$Gene[annotation$Gene==""] <- "-"
annotation$Type <- annotation$relation.to.island
annotation$Type <- gsub("_", " ", annotation$Type); annotation$Type <- capitalize(tolower(annotation$Type))
annotation$Type <- sub("N", "North", annotation$Type); annotation$Type <- sub("S", "South", annotation$Type); annotation$Type <- sub("sea", " sea", annotation$Type)
annotation <- annotation[,c("CpG", "Location", "Chr", "Pos", "Gene", "Type")]

###################################################################
##### Methylation data #####
###################################################################

map <- read.delim(map_file, header=T, sep="\t")
files <- list.files()
print(length(files))
for(i in 1:length(files)){
  data <- fread(files[i], header=T, sep="\t", data.table=F)
  data <- subset(data, p.value<1e-4)
  data$CpG <- data$probeID
  data$Beta <- round(data$estimate, 6)
  data$SE <- round(data$se, 6)  
  data$P <- signif(data$p.value, 3) 
  data <- data[,c("CpG", "Beta", "SE", "P")]
  data <- inner_join(data, annotation, by="CpG")
  data$Dataset <- sub(".txt", "", files[i])
  data$Further_Details <- "-"
  data <- inner_join(data, map, by="Dataset")
  data$StudyID <- paste0("Battram-T_", gsub(" ", "_", tolower(data$Trait)))
  data <- data[,c("StudyID", "Author", "Consortium", "PMID", "Date", "Trait", "EFO", "Analysis", "Source", "Outcome", "Exposure", "Covariates", "Outcome_Units", "Exposure_Units", "Methylation_Array", "Tissue", "Further_Details", "N", "N_Cohorts", "Categories", "Age", "N_Males", "N_Females", "N_EUR", "N_EAS", "N_SAS", "N_AFR", "N_AMR", "N_OTH", "CpG", "Location", "Chr", "Pos", "Gene", "Type", "Beta", "SE", "P", "Details")]
  data <- data[-grep("rs", data[, "CpG"]), ]
  na_dat <- is.na(data[,1])
  write.table(data, paste0("Data/dataset_",i,"_sub.txt"), row.names=F, quote=F, sep="\t")
  print(paste(i,"--DONE"))
}

q("no")
