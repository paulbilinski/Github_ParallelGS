setwd("~/Documents/Projects/Genome_Size_Analysis/Github_GS_analyses/BWAmapping/RepeatRefs")


data <- read.csv("grass_syntenic_orthologs_w4list2.csv", header=FALSE)
data2 <- read.csv("Syntelcndaformerge.txt", header=FALSE)
tmp <- read.csv("")

data3 <- merge(data, data2, by="V1")
data4 <- unique(data3)
write.csv(data4,"SyntelcDNA_final.csv")
?write.csv
