data <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Teosinte_explore_andFISHcor/fishcorcirclesize.csv")


library(ggplot2)

#install.packages("cowplot")
library(cowplot)

ggplot(data, aes(knob180, X180knobmb)) + ylab("Measured Knob Content (mb)") + xlab("Observed Knob Count") + geom_point() + geom_smooth(method="lm", se = TRUE, lty=2)+theme(axis.text=element_text(size=20),axis.title=element_text(size=20,face="bold"))
#install.packages("cowplot")
library(cowplot)

ggplot(data, aes(knob180, X180knobmb,color=factor(circle))) + ylab("Measured Knob Content (mb)") + xlab("Observed Knob Count") + geom_point() + geom_smooth(aes(group=group),method="lm", se = TRUE, lty=2,color="black",size=.5)+scale_color_manual(values=c("#00CDCD", "#000000"))+theme(legend.position="none")


