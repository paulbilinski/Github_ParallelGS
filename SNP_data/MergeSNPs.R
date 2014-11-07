setwd("~/Documents/Projects/Genome_Size_Analysis/Github_GS_analyses/SNP_data/")

qual <- read.csv("Qualsnps.csv", header=TRUE)
parv <- read.table("Parviglumis_TopStrand_FinalReport.txt", sep="\t",header=TRUE)
mex <- read.table("Mexicana_TopStrand_FinalReport.txt", sep="\t",header=TRUE)
lr <- read.table("HighLowSNPs_Final.txt",sep="\t",header=TRUE)
sw <- read.table("SW_Landraces_55K.txt",sep="\t",header=TRUE)

all <- merge(lr, qual, by="id")
all2 <- merge(all,parv,by="id")
all3 <- merge(all2,mex,by="id")
all4 <- merge(all3,sw,by="id")

write.csv(all4, file="MergedSNPs2.csv")

data <- read.csv("MergedSNPs2.csv",header=TRUE)

crap <- colnames(data)
write.csv(crap,file="SNPsampleIDs.csv")

drop <- c("RIMMA0656.1","RIMMA0664.1","RIMMA0665.1","RIMMA0670.1","RIMMA0672.1","RIMMA0677.1","RIMMA0682.1","RIMMA0687.1","RIMMA0707.1","RIMMA0722.1","RIMMA0668.1","RIMPA0110.4_dup1","RIMPA0110.10","RIMPA0110.11","RIMPA0110.2_dup1","RIMPA0110.5","RIMPA0110.6","RIMPA0110.7","RIMPA0110.3_dup2","RIMPA0110.8","RIMPA0110.9","RIMPA0155.C12.1","RIMPA0155.C13.1","RIMPA0155.C14.1","RIMPA0155.C19.1","RIMPA0155.C23.1","RIMPA0155.C28.1","RIMPA0155.C32.1","RIMPA0155.C33.1","RIMPA0155.C36.1","RIMPA0155.C39.1","RIMPA0155.C42.1","RIMPA0155.C45.1","RIMPA0156C15","RIMPA0156C18","RIMPA0156C19","RIMPA0156C21","RIMPA0156C28","RIMPA0156C29","RIMPA0156C38","RIMPA0156C42","RIMPA0156C43","RIMPA0156C45","RIMPA0156C48","RIMPA0156C49","RIMPA0157.C10.1","RIMPA0157.C15.1","RIMPA0157.C16.1","RIMPA0157.C19.1","RIMPA0157.C20.1","RIMPA0157.C22.1","RIMPA0157.C3.1","RIMPA0157.C32.1","RIMPA0157.C39.1","RIMPA0157.C45.1","RIMPA0157.C48.1","RIMPA0157.C9.1","RIMPA0158C13","RIMPA0158C15","RIMPA0158C21","RIMPA0158C27","RIMPA0158C29","RIMPA0158C3","RIMPA0158C33","RIMPA0158C44","RIMPA0158C46","RIMPA0158C49","RIMPA0158C6","RIMPA158.C50..1","RIMMA0384.1","RIMMA0386.1")

data2 <- data[,!(names(data) %in% drop)]
data3 <- data2[,-1]
rownames(data3) <- data2[,1]

#Checking for 3 Genotypes and NA
all.T <- t(as.matrix(data3))
test
test <- table(summary(all.T))

options(max.print = 1000000)
out <- capture.output(summary(all.T))
cat(out,file="Check4GenosPer.txt",sep="\n",append=TRUE)

write.csv(data3,file="GenosForConvert.csv")

#Merged snps convered via ConvertSNP.pl

finaldata <- read.csv("Converted_JustGenos_addednames.csv",header=TRUE,row.names=1)
columnorder <- colnames(finaldata)
write.csv(columnorder, file="ColumnOrder_ForGenos.csv")



