setwd("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Grote_stats/Gridcomparison/")

chain1<- read.csv("FINAL_4.8ll_.003cellsizechain1.csv")
chain2<- read.csv("FINAL_4.8ll_.003cellsizechain2.csv")
both<- rbind(chain1,chain2)

input4.8_.3 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

chain1<- read.csv("FINAL_4.8ll_.0028cellsizechain1.csv")
chain2<- read.csv("FINAL_4.8ll_.0028cellsizechain2.csv")
both<- rbind(chain1,chain2)

input4.8_.28 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

chain1<- read.csv("FINAL_4.8ll_.0032cellsizechain1.csv")
chain2<- read.csv("FINAL_4.8ll_.0032cellsizechain2.csv")
both<- rbind(chain1,chain2)

input4.8_.32 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

chain1<- read.csv("FINAL_3.8ll_.0032cellsizechain1.csv")
chain2<- read.csv("FINAL_3.8ll_.0032cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.8_.32 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

chain1<- read.csv("FINAL_3.8ll_.003cellsizechain1.csv")
chain2<- read.csv("FINAL_3.8ll_.003cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.8_.3 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

chain1<- read.csv("FINAL_3.8ll_.0032cellsizechain1.csv")
chain2<- read.csv("FINAL_3.8ll_.0032cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.8_.32 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

chain1<- read.csv("FINAL_3.8ll_.0028cellsizechain1.csv")
chain2<- read.csv("FINAL_3.8ll_.0028cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.8_.28 <- density(both$GS.contrast,adjust=1.3,from=-.3,to=.1)

#png("Supplfig_gc.contrast.png",width=6,height=6,units="in",res=750)

par(mar=c(2,.8,2,.8)+0.1,oma=c(.5,3.5,3.5,.5))
my.layout <- layout(matrix(1:16, ncol=4,byrow=TRUE),widths=c(1.5,3,3,3),heights=c(2,2.9,2.9,2.9))
#layout.show(my.layout)

#toprow
plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"0.0028",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"0.0030",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"0.0032",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"3.8",cex=2,font=2)

plot(input3.8_.28,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)
?plot.density
plot(input3.8_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)
plot(input3.8_.32,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"4.8",cex=2,font=2)

plot(input4.8_.28,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)
plot(input4.8_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)
plot(input4.8_.32,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

par(xpd=NA)
text.x<- grconvertX(.6,from="ndc",to="user")
text.y<- grconvertY(.95,from="ndc",to="user")
  
text(text.x,text.y,"Stomatal Cell Size Prior Mean (cm)",cex=2.5,font=2)

text.x<- grconvertX(.05,from="ndc",to="user")
text.y<- grconvertY(.35,from="ndc",to="user")

text(text.x,text.y,"LER Prior Mean (cm)",cex=2.5,srt=90,font=2)
