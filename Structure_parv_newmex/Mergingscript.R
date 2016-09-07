setwd("Desktop/Structure_parv_newmex/")

tasloc <- read.csv("tassel_locations.txt")

chiploc <- read.csv("chipmutloc.txt")
colnames(chiploc)[2] <- "chrom_pos"

overlap <- merge(chiploc, tasloc, by="chrom_pos")
tail(overlap)

write.csv(overlap,"55kchip_GBS_overlap.csv")

####

mgbs<-read.csv("Master_mexgbs2.csv")
pchip<-read.table("Master_parv55k.txt",header=TRUE)
overlap<-read.csv("Master_55k-gbs-Overlap_5kapart.csv")

tmp1<-merge(mgbs,overlap,by="chrom_pos")
tmp2<-merge(tmp1,pchip,by.x="Originalname",by.y="id")
write.csv(tmp2,"Master_Mexparv_overlap.csv")
