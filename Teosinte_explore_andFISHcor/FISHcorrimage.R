data <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Teosinte_explore_andFISHcor/FISHcorrelation")


library(ggplot2)
#install.packages("cowplot")
library(cowplot)

ggplot(data, aes(knob180, X180knobmb)) + ylab("Measured Knob Content (mb)") + xlab("Observed Knob Count") + geom_point() + geom_smooth(method="lm", se = TRUE, lty=2)


