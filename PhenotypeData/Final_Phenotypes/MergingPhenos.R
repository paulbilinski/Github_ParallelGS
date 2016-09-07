data <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/PhenotypeData/Final_Phenotypes/Master_data_landraces.csv")
fte <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/PhenotypeData/Final_Phenotypes/289_percFTE_landraces.csv")
tmp <- merge(fte,data,by="uniqid")
#colnames(tmp)
crap <- tmp[,1:1189]
row.names(crap) <- crap$uniqid
crap$uniqid <- NULL
gsz <- tmp$GS_bp
crap2 <- crap * gsz
lrgsz <- merge(crap2,data, by.x="row.names",by.y="uniqid")
#write.csv(lrgsz,"~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/PhenotypeData/Final_Phenotypes/Landrace_data.csv")

