library(rjags)
library(stringr)
library(mcmcplots)

#Master Data frame with all measures is called fgrote, for final grote dataframe.
fgrote <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Finalgrowthchamberanalysis/grote_Indexmoms_groundedLL_d16NA.csv")

#Make the necessary dataframe inputs into the model.
stoma.positions <- str_detect(names(fgrote),"stom*")
stoma <- fgrote[,names(fgrote)[stoma.positions]]
#Convert microns to centimeters.
stoma <- 0.0001 * stoma 
leaflength.positions <- str_detect(names(fgrote), "leaf3diff*")#change this to leaf3diff*
leaflength <- fgrote[,names(fgrote)[leaflength.positions]]
n.cells <- apply(!is.na(stoma), MAR=1, FUN="sum")

#Data frames needed for figure generation.
gensize.conforming <- matrix(fgrote$genomesize,nrow=nrow(fgrote),ncol=3,byrow=FALSE)
fgrote$leaf3diff10 <- fgrote$leaf3.1 - fgrote$leaf3.0
fgrote$leaf3diff21 <- fgrote$leaf3.2 - fgrote$leaf3.1
fgrote$leaf3diff32 <- fgrote$leaf3.3 - fgrote$leaf3.2
#Empirical derivatives, change per day, necessary for figures.
LEdiffs <- as.matrix(cbind(fgrote$leaf3diff10,fgrote$leaf3diff21,fgrote$leaf3diff32))

#Call JAGS to generate posterior samples. 
DAGLL.jags <- jags.model("DAG_twomediator_Final.txt", 
	list(leaflength=log(leaflength), stoma=log(stoma), 
		n.mothers=max(fgrote$momindex), n.indiv=dim(fgrote)[1],
		n.cells=n.cells, n.times=3, mother.index=fgrote$momindex,
		GS=log(fgrote$genomesize)),
	n.chains=2)
update(DAGLL.jags, n.iter=1000)
DAGLL.samples <- coda.samples(DAGLL.jags, 
	c("beta.GS","tao.GS","GS.contrast",
		"sd.motherStCS","sd.motherLL","sd.indivCS","sd.indivLL","sd.StCS","sd.LL",
		"StCS.coeffs","tao.LL","LE.coeffs"),
	n.iter=5000, thin=50)
#mcmcplot(DAGLL.samples)
chain1 <- as.matrix(DAGLL.samples[[1]])
chain2 <- as.matrix(DAGLL.samples[[2]])
samples.mat <- rbind(chain1, chain2)
write.csv(chain1,"DAGLLfinal.jags.le.6_003_4.8.chain1.csv")
write.csv(chain2,"DAGLLfinal.jags.le.6_003_4.8.chain2.csv")

#Read in saved posterior samples. 
tmp1 <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Grote_stats/Gridcomparison/OldChains/gamma.chain2.ind4.8mom0_indcellsize.csv")
tmp2 <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/Mexicana/Grote_stats/Gridcomparison/OldChains/gamma.chain1.ind4.8mom0_indcellsize.csv")
#tmp1 <- mcmc(tmp1, thin=50)
#tmp2 <- mcmc(tmp2, thin=50)
#samples <- mcmc.list(chain1=tmp1, chain2=tmp2)
samples.mat <- as.matrix(rbind(tmp1, tmp2))

#Model display graphs.
#Graph 1: leaf elongation -vs- genome size.  

#Regular grid of genome size values for interpolation. 
gs.seq <- seq(from=min(fgrote$genomesize),to=max(fgrote$genomesize), by=0.01)

#Obtain parameter samples of LE.coeffs and tao.LL for model evaluations. 
LE.positions <- str_detect(colnames(samples.mat), "LE.coeffs")
LE.params <- samples.mat[, colnames(samples.mat)[LE.positions]]
tao.positions <- str_detect(colnames(samples.mat), "tao.LL")
tao.params <- samples.mat[, colnames(samples.mat)[tao.positions]]
#Proportionality factor that multiplies genome size, for each individual and each realization.
#See June 29, 2016 notes at bottom of page 1. 
pfact <- exp(tao.params) * LE.params
colnames(pfact) <- as.character(1:sum(LE.positions))

#Matrix of factors GS^(tao.GS), where GS varies according to the regular grid gs.seq, 
#and tao.GS varies over posterior samples. 
gsfact <- outer(X=gs.seq, Y=samples.mat[,"tao.GS"], FUN="^")
#Transpose for conformability with other matrices: rows 1,...R will be posterior samples. 
gsfact <- t(gsfact)
colnames(gsfact) <- as.character(gs.seq)

#Empty array of individual-level predictions of LE, for each posterior sample. 
all.LE.preds <- array(0, dim=c(sum(LE.positions), length(gs.seq), dim(samples.mat)[1]), 
	dimnames=list(indiv=colnames(pfact), gs=colnames(gsfact), 
		sample=as.character(1:dim(samples.mat)[1])))
#Loop over posterior samples, populate the array with individual-level predictions
#for each grid value of GS and each realization.
#CLUNKY AND INEFFICIENT. BUT IT WORKS.  
for(s in 1:dim(samples.mat)[1]) all.LE.preds[,,s] <- outer(pfact[s,], gsfact[s,], FUN="*")

#Obtain upper and lower quantiles for the collection of all curves over all realizations. 
all.curve.quants <- apply(all.LE.preds, MAR=2, FUN=quantile, probs=c(0.025, 0.975))
all.curve.upper <- all.curve.quants["97.5%",]
all.curve.lower <- all.curve.quants["2.5%",]

#Obtain sample mean curve for each Gibbs realization. 
sample.mean.curves <- apply(all.LE.preds, MAR=c(2,3), FUN="mean")

#Obtain upper and lower quantiles for the sample mean curves. 
sample.mean.quants <- apply(sample.mean.curves, MAR=1, FUN=quantile, probs=c(0.025, 0.975))
sample.mean.upper <- sample.mean.quants["97.5%",]
sample.mean.lower <- sample.mean.quants["2.5%",]

#Obtain grand mean curve. 
grand.mean.curve <- apply(sample.mean.curves, MAR=1, FUN="mean")

#Y-axis limits. 
ymin <- min(c(all.curve.upper, all.curve.lower, 
	sample.mean.upper, sample.mean.lower, LEdiffs), na.rm=TRUE)
ymax <- max(c(all.curve.upper, all.curve.lower, 
	sample.mean.upper, sample.mean.lower, LEdiffs), na.rm=TRUE)

#Empty plot with axis labeling. 
tiff("~/Desktop/fig4_lecurve.png", height=5, width=6, units="in", compression="lzw",res=250)
plot(as.vector(gensize.conforming), as.vector(LEdiffs), bty="n", type="n", 
	xlab="2C Genome Size (pg)", ylab="Leaf Elongation (cm/day)",
	ylim=c(ymin,ymax))

#Cubic spline smoother for empirically-driven reference.
#gensize.vec <- as.vector(gensize.conforming)
#LEdiffs.vec <- as.vector(LEdiffs)
#gensize.smo <- gensize.vec[!is.na(gensize.vec) & !is.na(LEdiffs.vec)] 
#LEdiffs.smo <- LEdiffs.vec[!is.na(gensize.vec) & !is.na(LEdiffs.vec)] 
#lines(smooth.spline(gensize.smo, LEdiffs.smo), lwd=2.0, col="red")

#Credibility band incorporating individual-level variation. 
for(polygon in 1:n.polygons){
  polygon(
    x=c(gs.seq[polygon], gs.seq[polygon], gs.seq[polygon+1], gs.seq[polygon+1]), 
    y=c(all.curve.lower[polygon], all.curve.upper[polygon],
		all.curve.upper[polygon+1], all.curve.lower[polygon+1]),
    col="gray90", border=NA)
}

#Credibility band for grand mean curve. 
n.polygons <- length(gs.seq) - 1
for(polygon in 1:n.polygons){
  polygon(
    x=c(gs.seq[polygon], gs.seq[polygon], gs.seq[polygon+1], gs.seq[polygon+1]), 
    y=c(sample.mean.lower[polygon], sample.mean.upper[polygon],
		sample.mean.upper[polygon+1], sample.mean.lower[polygon+1]),
    col="gray60", border=NA)
}

#Grand mean curve. 
lines(gs.seq, grand.mean.curve, lwd=1, lty=2)

#Observations. 
points(as.vector(gensize.conforming), as.vector(LEdiffs), pch=21, cex=0.8, bg="grey40")
graphics.off()

--------------------------------------------------------

#Graph 2: stomatal cell size -vs- genome size. #there
stoma.positions <- str_detect(names(fgrote),"stom*")
stoma <- fgrote[,names(fgrote)[stoma.positions]]
stoma <- 0.0001 * stoma #convert mircons to centimeters

gensize.conforming <- matrix(fgrote$genomesize,nrow=nrow(fgrote),ncol=61,byrow=FALSE) #61 columns for the total number of measures of stoma


gs.seq <- seq(from=min(fgrote$genomesize),to=max(fgrote$genomesize), by=0.01)

Stcs.positions <- str_detect(colnames(samples.mat), "StCS.coeffs")
Stcs.params <- samples.mat[, colnames(samples.mat)[Stcs.positions]]
pfact <- exp(Stcs.params)
colnames(pfact) <- as.character(1:sum(Stcs.positions))

gsfact <- outer(X=gs.seq, Y=samples.mat[,"beta.GS"], FUN="^")
gsfact <- t(gsfact)
colnames(gsfact) <- as.character(gs.seq)

all.stcs.preds <- array(0, dim=c(sum(Stcs.positions), length(gs.seq), dim(samples.mat)[1]), 
                      dimnames=list(indiv=colnames(pfact), gs=colnames(gsfact), 
                                    sample=as.character(1:dim(samples.mat)[1])))

for(s in 1:dim(samples.mat)[1]) all.stcs.preds[,,s] <- outer(pfact[s,], gsfact[s,], FUN="*")

all.curve.quants <- apply(all.stcs.preds, MAR=2, FUN=quantile, probs=c(0.025, 0.975))
all.curve.upper <- all.curve.quants["97.5%",]
all.curve.lower <- all.curve.quants["2.5%",]

sample.mean.curves <- apply(all.stcs.preds, MAR=c(2,3), FUN="mean")
sample.mean.quants <- apply(sample.mean.curves, MAR=1, FUN=quantile, probs=c(0.025, 0.975))
sample.mean.upper <- sample.mean.quants["97.5%",]
sample.mean.lower <- sample.mean.quants["2.5%",]

grand.mean.curve <- apply(sample.mean.curves, MAR=1, FUN="mean")

ymin <- min(stoma,na.rm=TRUE)
#min(c(all.curve.upper, all.curve.lower, sample.mean.upper, sample.mean.lower , na.rm=TRUE)
ymax <- max(stoma,na.rm=TRUE)
#max(c(all.curve.upper, all.curve.lower, sample.mean.upper, sample.mean.lower), na.rm=TRUE)

tiff("~/Desktop/Final_cells.png", height=5, width=6, units="in", compression="lzw",res=250)
plot(as.vector(gensize.conforming), as.vector(as.matrix(stoma)), bty="n", type="n", 
     xlab="2C Genome Size (pg)", ylab="Stomatal Cell Size (cm)",
     ylim=c(ymin,ymax))

#Cubic spline smoother for empirically-driven reference.
#gensize.vec <- as.vector(gensize.conforming)
#LEdiffs.vec <- as.vector(LEdiffs)
#gensize.smo <- gensize.vec[!is.na(gensize.vec) & !is.na(LEdiffs.vec)] 
#LEdiffs.smo <- LEdiffs.vec[!is.na(gensize.vec) & !is.na(LEdiffs.vec)] 
#lines(smooth.spline(gensize.smo, LEdiffs.smo), lwd=2.0, col="red")

#Credibility band incorporating individual-level variation.
n.polygons <- length(gs.seq) - 1
for(polygon in 1:n.polygons){
  polygon(
    x=c(gs.seq[polygon], gs.seq[polygon], gs.seq[polygon+1], gs.seq[polygon+1]), 
    y=c(all.curve.lower[polygon], all.curve.upper[polygon],
        all.curve.upper[polygon+1], all.curve.lower[polygon+1]),
    col="gray90", border=NA)
}

#Credibility band for grand mean curve. 
for(polygon in 1:n.polygons){
  polygon(
    x=c(gs.seq[polygon], gs.seq[polygon], gs.seq[polygon+1], gs.seq[polygon+1]), 
    y=c(sample.mean.lower[polygon], sample.mean.upper[polygon],
        sample.mean.upper[polygon+1], sample.mean.lower[polygon+1]),
    col="gray60", border=NA)
}

#Grand mean curve. 
lines(gs.seq, grand.mean.curve, lwd=1, lty=2)

#Observations. 
points(as.vector(gensize.conforming), as.vector(as.matrix(stoma)), pch=21, cex=0.2, bg="grey40")
graphics.off()

--------------
hist(table(fgrote$momindex),xlab="Number of individuals with same mother",breaks=20,col="peru",ylab="Number of groups",main="Frequency Spectrum for Number of Mothers")
hist(as.factor(fgrote$momindex))
