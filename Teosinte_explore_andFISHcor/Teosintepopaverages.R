crap2 <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Teosinte_explore_andFISHcor/Teosinte_perindividual.csv")
crap <- subset(crap2, crap2$altitude!= "NA")
#install.packages("ggplot2")
library(ggplot2)
library(dplyr)
filter(crap,species=="mexicana") %>% ggplot(aes(y=genomesize,x=altitude))+geom_point()+geom_smooth(method="lm")
library(lme4)
library(lmerTest)
#install.packages("lmerTest")

head(crap)

summary(lmer(data=crap,genomesize~altitude+(1|Pop)+species))
#across all species, there is a difference in genome size, and that difference is significant across altitude.

parv=filter(crap,species=="parviglumis")
mex=filter(crap,species=="mexicana")
summary(lmer(data=mex,genomesize~altitude+(1|Pop)))
#we see that altitude is significant in this analysis, showing that it is  a factor in mex
summary(lmer(data=parv,genomesize~altitude+(1|Pop)))
#we see that altitude is not a significant factor in explaining the GS

#from this pilot, we can conclude that maybe there is something to the altitudinal aspect of genome size differences between species.

ggplot(crap, aes(altitude, genomesize, shape = factor(species),fill=species),) + ylab("2C Genome Size (pg)") + xlab("Altitude (m)") + geom_boxplot(outlier.shape = NA) + geom_jitter(size=3)

ggplot(crap, aes(species, genomesize)) + ylab("2C Genome Size (pg)") + xlab("")+geom_boxplot(outlier.shape = NA)+ geom_point(position = position_jitter(width = 0.2))+ scale_x_discrete(limits=c("parviglumis","mexicana"))

ggplot(crap, aes(altitude, genomesize, shape=factor(species))) + ylab("1C Genome Size") + geom_point(size=3)

filter(crap,abs(altitude-1500)>250) %>%
  ggplot(aes(altitude, genomesize, shape=factor(species))) + ylab("1C Genome Size") + geom_point(size=3)

