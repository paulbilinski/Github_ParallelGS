
lrdta <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/PhenotypeData/Final_Phenotypes/Landrace_data.csv")
lrdta$X <- NULL
data <- subset(lrdta, lrdta$Region!="SWUS")
data$X1C_GS
pheno <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Master_mexnucleo_pruned.csv") #phenotype data in matching order
data$TR1bp
pheno$TR1bp
tmpmz <- data[,c("Altitude","Species","X180knobbp","TR1bp","TotallTebp")]
tmpmz$X180knobbp <- tmpmz$X180knobbp *2
tmpmz$TR1bp <- tmpmz$TR1bp *2
tmpmz$TotallTebp <- tmpmz$TotallTebp *2
tmpteo <- pheno[,c("Altitude","Species","X180knobbp","TR1bp","TotalTebp")]
crap<-setNames(tmpmz, c("Altitude","Species","X180knobbp","TR1bp","TotalTebp"))
tmpall <- rbind(crap,tmpteo)
#write.csv(tmpall,"~/Desktop/folding.csv")
altg<-read.csv("~/Desktop/folding.csv")
altg$X<-NULL

library(ggplot2)
library(gridExtra)
library(dplyr)

p2<-ggplot(altg,aes(x=factor(Groups), X180knobbp,fill=factor(Species)))+ ylab("180bp Knob (bp)")+geom_boxplot()+scale_x_discrete(breaks = 1:6, labels=c("<500","<1000","<1500","<2000","<2500",">2500")) + xlab("Altitude")+guides(fill = guide_legend(title = "Species"))
p2

p3<-ggplot(altg,aes(x=factor(Groups), TR1bp,fill=factor(Species)))+ ylab("TR1 (bp)")+geom_boxplot()+scale_x_discrete(breaks = 1:6, labels=c("<500","<1000","<1500","<2000","<2500",">2500")) + xlab("Altitude")+guides(fill = guide_legend(title = "Species"))
p3

p4<-ggplot(altg,aes(x=factor(Groups), TotalTebp,fill=factor(Species)))+ ylab("Total TE (bp)")+geom_boxplot()+scale_x_discrete(breaks = 1:6, labels=c("<500","<1000","<1500","<2000","<2500",">2500")) + xlab("Altitude")+guides(fill = guide_legend(title = "Species"))
p4

grid.arrange(p2,p3,p4,ncol=1)


cuts <- apply(crap, 2, cut, c(-Inf,seq(0.5, 1, 0.1), Inf), labels=0:6)
?apply
?cut

try <- cut(crap$Altitude, c(0,500,1000,1500,2000,2500,3500),include.lowest=TRUE)
mean.mzknob<-tapply(crap$X180knobbp,try,mean)
mean.mztr<-tapply(crap$TR1bp,try,mean)
mean.mzTE<-tapply(crap$TotalTebp,try,mean)

try <- cut(tmpteo$Altitude, c(0,500,1000,1500,2000,2500,3500),include.lowest=TRUE)
mean.teoknob<-tapply(tmpteo$X180knobbp,try,mean)
mean.teotr<-tapply(tmpteo$TR1bp,try,mean)
mean.teoTE<-tapply(tmpteo$TotalTebp,try,mean)

plot(mean.mzknob-mean.teoknob)

p2<-ggplot(tmpall, aes(Altitude, X180knobbp,color=Species),) + geom_point()+ ylab("180bp Knob (bp)")+geom_histogram()
+ stat_bin(binwidth = 1, drop = FALSE, right = TRUE, col = "black")

p2<-ggplot(tmpall, aes(x=X180knobbp,color=Species),) + ylab("180bp Knob (bp)")+geom_histogram()
p2
+ geom_jitter(width = 0.2)
p2<-ggplot(tmpall,aes(Altitude, X180knobbp,fill=factor(Species)))+ ylab("180bp Knob (bp)")+geom_boxplot(aes(group= cut_width(Altitude, 500)))

p2
p2<-ggplot(tmpteo)+ ylab("180bp Knob (bp)")+geom_boxplot(aes(Altitude, X180knobbp,fill=Species,group= cut_width(Altitude, 500)))
p2
p4<-ggplot(tmpall, aes(Altitude, TR1bp,color=Species),) + geom_point()+ ylab("TR1 Knob (bp)") 
p4
p3<-ggplot(tmpall, aes(Altitude, TotalTebp,color=Species),) + geom_point()+ ylab("Total TE Content (bp)") 
p3

grid.arrange(p2,p4,p3,ncol=1)



+ geom_smooth(aes(group=Species),method="lm",color="black",linetype="dashed")+guides(color=FALSE)+xlab("Altitude (m)")#+ ggtitle("Genome Size")