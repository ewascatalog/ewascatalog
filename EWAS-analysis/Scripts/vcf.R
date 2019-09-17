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

for(i in 1:22){
  data <- fread(paste0("chromosome",i,".txt"), header=T, sep="\t", data.table=F)
  data <- data[with(data, order(as.integer(CHROM), as.integer(POS))),]
  names(data)[names(data)=="CHROM"] <- "#CHROM"
  vcf <- "##fileformat=VCFv4.2"
  write.table(vcf, paste0("chromosome",i,".vcf"), row.names=F, col.names=F, quote=F)
  suppressWarnings(write.table(data, paste0("chromosome",i,".vcf"), row.names=F, col.names=T, quote=F, sep="\t", append=T))
  print(paste(i,"--DONE"))
}

q("no")