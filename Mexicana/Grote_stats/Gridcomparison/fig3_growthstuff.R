setwd("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Grote_stats/Gridcomparison/")


chain1<- read.csv("FINAL_4.0ll_.003cellsizechain1.csv")
chain2<- read.csv("FINAL_4.0ll_.003cellsizechain2.csv")
both<- rbind(chain1,chain2)

input4.0_.3 <- density(both$beta.GS,adjust=1.3,from=-.1,to=.1)
inputcontrast <- density(both$GS.contrast,adjust=1.3,from=-.1,to=.1)

par(mfrow=c(2,1))
plot(input4.0_.3,ylab="",yaxt="n",bty="n",lwd=2,cex.axis=1.5,main="Posterior Distribution of Cell Size Coefficient",xlab="")
polygon(input4.0_.3, col=rgb(1, 1, 0, .2, names = NULL, maxColorValue = 1), border="gray")
abline(v=0,col="red",lty=2,lwd=2)

plot(inputcontrast,ylab="",yaxt="n",bty="n",lwd=2,cex.axis=1.5,main="Posterior Distribution of Cell Production Coefficient",xlab="")
polygon(inputcontrast, col=rgb(.1, .1, .5, .2, names = NULL, maxColorValue = 1), border="white")
abline(v=0,col="red",lty=2,lwd=2)


