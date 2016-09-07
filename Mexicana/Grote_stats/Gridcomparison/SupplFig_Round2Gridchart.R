setwd("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Grote_stats/Gridcomparison/")

chain1<- read.csv("FINAL_4.0ll_.003cellsizechain1.csv")
chain2<- read.csv("FINAL_4.0ll_.003cellsizechain2.csv")
both<- rbind(chain1,chain2)

input4.0_.3 <- density(both$GS.contrast,adjust=1.3,from=-.1,to=.1)

chain1<- read.csv("FINAL_4.0ll_.0032cellsizechain1.csv")
chain2<- read.csv("FINAL_4.0ll_.0032cellsizechain2.csv")
both<- rbind(chain1,chain2)

input4.0_.32 <- density(both$GS.contrast,adjust=1.3,from=-.1,to=.1)

chain1<- read.csv("FINAL_3.6ll_.003cellsizechain1.csv")
chain2<- read.csv("FINAL_3.6ll_.003cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.6_.3 <- density(both$GS.contrast,adjust=1.3,from=-.1,to=.1)

chain1<- read.csv("FINAL_3.6ll_.0028cellsizechain1.csv")
chain2<- read.csv("FINAL_3.6ll_.0028cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.6_.28 <- density(both$GS.contrast,adjust=1.3,from=-.1,to=.1)

chain1<- read.csv("FINAL_3.6ll_.0032cellsizechain1.csv")
chain2<- read.csv("FINAL_3.6ll_.0032cellsizechain2.csv")
both<- rbind(chain1,chain2)

input3.6_.32 <- density(both$GS.contrast,adjust=1.3,from=-.1,to=.1)

par(mar=c(2,.8,2,.8)+0.1,oma=c(.5,3.5,3.5,.5))
my.layout <- layout(matrix(1:12, ncol=4,byrow=TRUE),widths=c(1.5,3,3,3),heights=c(1,1,1))
#layout.show(my.layout)

#toprow
plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,".0028",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,".0030",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,".0032",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"3.6",cex=2,font=2)

plot(input3.6_.28,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input3.6_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input3.6_.32,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"4.0",cex=2,font=2)

plot(input4.0_.28,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input4.0_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input4.0_.32,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

par(xpd=NA)
text.x<- grconvertX(.6,from="ndc",to="user")
text.y<- grconvertY(.95,from="ndc",to="user")

text(text.x,text.y,"Stomatal Cell Size Prior Mean (cm)",cex=1.5,font=2)

text.x<- grconvertX(.05,from="ndc",to="user")
text.y<- grconvertY(.35,from="ndc",to="user")

text(text.x,text.y,"LER Prior Mean (cm)",cex=1.5,srt=90,font=2)




plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"3.4",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"3.2",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,"3.0",cex=2,font=2)

plot(c(0,1),c(0,1),type="n",bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
text(0.5,0.5,".003",cex=2,font=2,srt=90)

plot(input4.0_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)
plot(input3.8_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input3.6_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input3.4_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input3.2_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

plot(input3.0_.3,ylab="",yaxt="n",main="",bty="n",lwd=2,cex.axis=1.5)
abline(v=0,col="red",lty=2,lwd=2)

