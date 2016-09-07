### 
library(RAFM)
library(driftsel)

data(specimen)
data(sticklebacks)
data(shrews) #copy this for data structure for AFM
head(specimen)
write.table(specimen, row.names=TRUE, file="specimen.txt") #this doesnt work

#notes on AFM: typically you will not need to use AFM, WHAT?
#instead want to use do.all, BUT IT DOESNT WORK.

#?s to coop
#talk big question: selection or drift governing genome size
#First and foremost - heritability problem in driftsel - it needs a pedigree to estimate heritability, i think my heritability is 1.  problem?
#how about number of traits that I have?  Should I run seperately, what kind of analysis makes sense?  I think all my repeats are independent.
#how should i structure my matrix for RAFM?
#what does my phenotype data need to look like for driftsel?

data(specimen)
samp <- do(specimen, 100, 50, 2)


A <- specimen
samp <- MH(A$poster, A$ped, A$covars, A$traits, 12, 4, 1)
neut.test(samp$pop.ef, samp$G, samp$theta, silent=TRUE)
?S.test

##Anna code

#SparseM
#corpcor
#coda
#RAFM
#MCMCpack
#driftsel

install.packages("mvtnorm")
install.packages("doMC")
install.packages("foreach")
library(driftsel)
library(mvtnorm)

require(doMC)
require(foreach)

usecores <- 8
registerDoMC(cores=usecores)

noplot.test <- function (popefpost, Gpost, THpost, silent = T, G.off = F, th.off = F,  main = NA) #this is neut.test code from driftsel, minus plotting
{
  if (th.off) {
    npop = dim(THpost)[1]
    if (npop > 1) {
      for (i in 2:npop) {
        for (j in 1:(i - 1)) {
          THpost[i, j, ] = THpost[j, i, ] = 0
        }
      }
    }
  }
  if (G.off) {
    ntrait = dim(Gpost)[1]
    if (ntrait > 1) {
      for (i in 2:ntrait) {
        for (j in 1:(i - 1)) {
          Gpost[i, j, ] = Gpost[j, i, ] = 0
        }
      }
    }
  }
  apost = popefpost
  nmc = dim(apost)[3]
  D = rep(NA, nmc)
  for (i in 1:nmc) {
    a = c(apost[, , i])
    G = Gpost[, , i]
    THP = THpost[, , i]
    Sig = 2 * G %x% THP
    Sig_ = solve(Sig)
    mu = rep(0, length(a))
    D2 = t(mu - a) %*% Sig_ %*% (mu - a)
    D[i] = D2
  }
  dfr = (dim(Gpost)[1]) * (dim(apost)[1])
  cdf = pchisq(D, dfr)
  out = mean(cdf)
  return(out)
}


####i need some theta "posterior estimates" matrices for 10 pops,
#a list of 10 by 10 genetic covariances... I stole jeremy's code here, did some silly shortcuts.
MakeIBDMatrix <- function ( decay.constant , pops, equal.drift ) {
  # specify ibd matrix
  #recover()
  decay.constant <- log ( decay.constant )
  ibd.matrix <- matrix ( 0 , nrow = pops , ncol = pops )
  for ( i in 1 : pops) {
    for ( j in 1 : pops ) {
      distance <- abs ( i - j )
      ibd.matrix [ i , j ] <- exp ( (distance ) * decay.constant )	
    }
  }
  if ( decay.constant == -Inf ) ibd.matrix <- diag ( pops )
  if ( equal.drift == FALSE) {
    diag(ibd.matrix) <- rnorm(ncol(ibd.matrix), ibd.matrix[1,1], ibd.matrix[1,1]/2) #add jitter, makes unequal total drift
  }
  return ( ibd.matrix )
}	
#diagonal? can I jitter it or not? NOPE
#the rest is ibd then using pop to pop measures, same for all individuals? - decay between pops.
#theta affects power. more distantly related = harder to find excess differentiation
#jeremy thinks real data matters here for pop relatedness in absolute power, but not relative power



#options(error = recover)
## function, make various # into arguments, generate relatedness, generate traits neutral and not, store output of test with & without env contr of traits,
ds.sim = function(n.sibs,n.moms, n.pops, h, Vp, m, n.reps, env.prop){
  
  #	neutral.tests=c()
  #	env.tests=c()
  
  testslistsN <-foreach(k=1:n.reps, .combine='rbind', .errorhandling="remove")%dopar%{
    theta <- array(data=rep(NA,n.pops*n.pops),dim=c(n.pops,n.pops,2))
    decayconst <- rnorm(2,.8,sd=.1) ##PICKED RANDOM DECAY OF Identity by Pop Number (pop 1 and 2 related, pop 1 and 10 not)
    for(i in 1:2){theta[,,i] <- MakeIBDMatrix (decayconst[i] , n.pops ,equal.drift=TRUE) / 5 }
    #can't jitter yet bc need rewrite to make cov matrix acceptable to rmvnorm()
    theta <- abs(theta)
    
    tot.plants=n.moms*n.sibs*n.pops
    
    #ALTERNATELY: make from matt's data from mexicana data avail for DL instead of this cheesy one of equal total drift. 
    #figshare look for jeff, matts 2013 get only RIMMEs; take 1000 random snps. 
    
    ####then I need to get a pedigree
    #we assume all different fathers maybe? YES;
    # dam and sire # are not reused between pops
    dams <- c(); pops <- c()
    for(i in 1:(n.moms*n.pops)){dams <- c(dams,rep(i,times=n.sibs))}
    for(i in 1:n.pops){pops <- c(pops,rep(i,times=n.sibs*n.moms))}
    ped <- data.frame(id=c(1:(tot.plants)),sire=c(1:(tot.plants)),dam=dams,sire.pop=pops,dam.pop=pops)
    
    #the grand relatedness
    all.theta <- matrix(NA,ncol=n.pops*n.sibs*n.moms, nrow=n.pops*n.sibs*n.moms)
    pop.theta <- apply(theta, c(1,2), mean)	#use just one avg pop level theta
    for(i in 1:tot.plants){
      for(j in 1:tot.plants){
        if(ped$dam.pop[i] != ped$dam.pop[j]){all.theta[i,j] <- pop.theta[ped$dam.pop[i],ped$dam.pop[j]]}
        if(ped$dam.pop[i] == ped$dam.pop[j]){all.theta[i,j] <- pop.theta[ped$dam.pop[i],ped$dam.pop[i]]}#note this fills in halfsibs and self cells, that are written over below
        if(ped$dam[i] == ped$dam[j]){all.theta[i,j] <-  all.theta[i,j] + .25*( 0.5*( 1-pop.theta[ped$dam.pop[i],ped$dam.pop[i]] ) - pop.theta[ped$dam.pop[i],ped$dam.pop[i]]) }#note this fills in self cells that are written over below
        if(i == j){all.theta[i,j] <- 1}
      }
    }
    
    #traits
    Va <- h*Vp
    Ve <- Vp-Va #Ve placeholder for the rest of the variance
    genetic.values <- as.vector(t(rmvnorm(1,rep(m,tot.plants),2*Va*all.theta)))	
    Ve.error = rnorm(length(genetic.values),0,sqrt(Ve))
    traits <- data.frame(id=ped$id,trait.1=(genetic.values+Ve.error)) # NOTE, some trait entries are NEGATIVE. hope this is ok.
    
    
    ###run driftsel for distributions
    samp.n <- MH(theta, ped,covars=traits[,1], traits, 100, 40, 2, alt=T)   # check from manual, what alt=T means
    neutral.tests <- as.numeric(noplot.test(samp.n$pop.ef, samp.n$G, samp.n$theta, silent=F)  )
    neutral.tests
  }
  
  print("neutral")
  
  #do the same thin for E
  testslistsE <-foreach(k=1:n.reps, .combine='rbind', .errorhandling="remove")%dopar%{
    theta <- array(data=rep(NA,n.pops*n.pops),dim=c(n.pops,n.pops,2))
    decayconst <- rnorm(2,.8,sd=.1) ##PICKED RANDOM DECAY OF Identity by Pop Number (pop 1 and 2 related, pop 1 and 10 not)
    for(i in 1:2){theta[,,i] <- MakeIBDMatrix (decayconst[i] , n.pops ,equal.drift=TRUE) / 5 }
    #can't jitter yet bc need rewrite to make cov matrix acceptable to rmvnorm()
    theta <- abs(theta)
    
    tot.plants=n.moms*n.sibs*n.pops
    
    #ALTERNATELY: make from matt's data from mexicana data avail for DL instead of this cheesy one of equal total drift. 
    #figshare look for jeff, matts 2013 get only RIMMEs; take 1000 random snps. 
    
    ####then I need to get a pedigree
    #we assume all different fathers maybe? YES;
    # dam and sire # are not reused between pops
    dams <- c(); pops <- c()
    for(i in 1:(n.moms*n.pops)){dams <- c(dams,rep(i,times=n.sibs))}
    for(i in 1:n.pops){pops <- c(pops,rep(i,times=n.sibs*n.moms))}
    ped <- data.frame(id=c(1:(tot.plants)),sire=c(1:(tot.plants)),dam=dams,sire.pop=pops,dam.pop=pops)
    
    #the grand relatedness
    all.theta <- matrix(NA,ncol=n.pops*n.sibs*n.moms, nrow=n.pops*n.sibs*n.moms)
    pop.theta <- apply(theta, c(1,2), mean)	#use just one avg pop level theta
    for(i in 1:tot.plants){
      for(j in 1:tot.plants){
        if(ped$dam.pop[i] != ped$dam.pop[j]){all.theta[i,j] <- pop.theta[ped$dam.pop[i],ped$dam.pop[j]]}
        if(ped$dam.pop[i] == ped$dam.pop[j]){all.theta[i,j] <- pop.theta[ped$dam.pop[i],ped$dam.pop[i]]}#note this fills in halfsibs and self cells, that are written over below
        if(ped$dam[i] == ped$dam[j]){all.theta[i,j] <-  all.theta[i,j] + .25*( 0.5*( 1-pop.theta[ped$dam.pop[i],ped$dam.pop[i]] ) - pop.theta[ped$dam.pop[i],ped$dam.pop[i]]) }#note this fills in self cells that are written over below
        if(i == j){all.theta[i,j] <- 1}
      }
    }
    
    #traits
    Va <- h*Vp
    Ve <- Vp-Va #Ve placeholder for the rest of the variance
    genetic.values <- as.vector(t(rmvnorm(1,rep(m,tot.plants),2*Va*all.theta)))	
    Ve.error = rnorm(length(genetic.values),0,sqrt(Ve))
    traits <- data.frame(id=ped$id,trait.1=(genetic.values+Ve.error)) # NOTE, some trait entries are NEGATIVE. hope this is ok.
    #make a second vector, where traits are largely determined by environment, extent of which determined by env.prop
    a=-1*(env.prop/2)*m
    b=(env.prop/2)*m
    env <- rep(c(rep(a,n.moms*n.sibs),rep(b,n.moms*n.sibs)),length.out=n.pops*n.moms*n.sibs) #vector of environmental values
    envtraits <- traits
    envtraits$trait.1 <- traits$trait.1+env ##take traits, compare to 
    #environment unrealistic?
    
    ###run driftsel for distributions
    samp.e <- MH(theta, ped,covars=traits[,1], envtraits, 100, 40, 2, alt=T)
    env.tests <- as.numeric(noplot.test(samp.e$pop.ef, samp.e$G, samp.e$theta, silent=F))
    env.tests
  }
  
  print("environmental")
  
  return(list(NeutTest = testslistsN,EnvTest = testslistsE))
}



#the attempted neutral traits are not neutral...S = .7 yikes!
#at least the non-neutral traits are even less neutral...

#SIMULATIONS AND SETTING VALUES

#things fixed
m <- 38.3 #grand mean height in GH
Vp <- 177.5 # var in height in GH
n.reps <- 500

#things to vary
env.prop <- .3 # if = .5, environment will have a 25% decrease or 25% increase effect on trait relative to mean. try .25, .5, 1
n.sibs <- 3 #try 4 and 5
n.moms <- 8 #up to 12
n.pops <- 10 #only down
h <- .3 # try .1, .5

env.prop.v <- c(.1,.2)
n.sibs.v <- c(4,5)
n.moms.v <- c(6:12)
n.pops.v <- c(5:9)
h.v <- c(.1,.2,.4,.5)



sib.power.n <- matrix(NA,nrow=n.reps,ncol=length(n.sibs.v))
sib.power.e <- matrix(NA,nrow=n.reps,ncol=length(n.sibs.v))
for(i in 1:length(n.sibs.v)){
  test.output <- ds.sim(n.sibs.v[i],n.moms,n.pops,h,Vp,m,n.reps,env.prop)
  neutL <- length(test.output$NeutTest)
  envL <- length(test.output$EnvTest)
  if(neutL==n.reps) {
    neuts <- as.vector(test.output$NeutTest)
  } else {
    neuts <- c(as.vector(test.output$NeutTest),rep(NA,length.out=(n.reps-neutL)))
  }
  if (envL==n.reps) {
    envs<- as.vector(test.output$EnvTest)
  } else {
    envs <- c(as.vector(test.output$EnvTest),rep(NA,length.out=(n.reps-envL)))
  }
  sib.power.n[,i] <- neuts
  sib.power.e[,i]<- envs
  print(paste("fullrep",i))
}
write.csv(sib.power.n,"~/driftselsims/sib.power.n.csv",row.names=F)
write.csv(sib.power.e,"~/driftselsims/sib.power.e.csv",row.names=F)



mom.power.n <-  matrix(NA,nrow=n.reps,ncol=length(n.moms.v))
mom.power.e <-  matrix(NA,nrow=n.reps,ncol=length(n.moms.v))
for(i in 1:length(n.moms.v)){
  test.output <- ds.sim(n.sibs,n.moms.v[i],n.pops,h,Vp,m,n.reps,env.prop)
  neutL <- length(test.output$NeutTest)
  envL <- length(test.output$EnvTest)
  if(neutL==n.reps) {
    neuts <- as.vector(test.output$NeutTest)
  } else {
    neuts <- c(as.vector(test.output$NeutTest),rep(NA,length.out=(n.reps-neutL)))
  }
  if (envL==n.reps) {
    envs<- as.vector(test.output$EnvTest)
  } else {
    envs <- c(as.vector(test.output$EnvTest),rep(NA,length.out=(n.reps-envL)))
  }
  mom.power.n[,i] <- neuts
  mom.power.e[,i] <- envs
  print(paste("fullrep",i))
}
write.csv(mom.power.n,"~/driftselsims/mom.power.n.csv",row.names=F)
write.csv(mom.power.e,"~/driftselsims/mom.power.e.csv",row.names=F)


pop.power.n <-  matrix(NA,nrow=n.reps,ncol=length(n.pops.v))
pop.power.e <-  matrix(NA,nrow=n.reps,ncol=length(n.pops.v))
for(i in 1:length(n.pops.v)){
  test.output <- ds.sim(n.sibs,n.moms,n.pops.v[i],h,Vp,m,n.reps,env.prop)
  neutL <- length(test.output$NeutTest)
  envL <- length(test.output$EnvTest)
  if(neutL==n.reps) {
    neuts <- as.vector(test.output$NeutTest)
  } else {
    neuts <- c(as.vector(test.output$NeutTest),rep(NA,length.out=(n.reps-neutL)))
  }
  if (envL==n.reps) {
    envs<- as.vector(test.output$EnvTest)
  } else {
    envs <- c(as.vector(test.output$EnvTest),rep(NA,length.out=(n.reps-envL)))
  }
  pop.power.n[,i] <- neuts
  pop.power.e[,i] <- envs
  print(paste("fullrep",i))
}
write.csv(pop.power.n,"~/driftselsims/pop.power.n.csv",row.names=F)
write.csv(pop.power.e,"~/driftselsims/pop.power.e.csv",row.names=F)


h.power.n <-  matrix(NA,nrow=n.reps,ncol=length(h.v))
h.power.e <-  matrix(NA,nrow=n.reps,ncol=length(h.v))
for(i in 1:length(h.v)){
  test.output <- ds.sim(n.sibs,n.moms,n.pops,h.v[i],Vp,m,n.reps,env.prop)
  neutL <- length(test.output$NeutTest)
  envL <- length(test.output$EnvTest)
  if(neutL==n.reps) {
    neuts <- as.vector(test.output$NeutTest)
  } else {
    neuts <- c(as.vector(test.output$NeutTest),rep(NA,length.out=(n.reps-neutL)))
  }
  if (envL==n.reps) {
    envs<- as.vector(test.output$EnvTest)
  } else {
    envs <- c(as.vector(test.output$EnvTest),rep(NA,length.out=(n.reps-envL)))
  }
  h.power.n[,i] <- neuts
  h.power.e[,i] <- envs
  print(paste("fullrep",i))
}
write.csv(h.power.n,"~/driftselsims/h.power.n.csv",row.names=F)
write.csv(h.power.e,"~/driftselsims/h.power.e.csv",row.names=F)


env.power.n <-  matrix(NA,nrow=n.reps,ncol=length(env.prop.v))
env.power.e <-  matrix(NA,nrow=n.reps,ncol=length(env.prop.v))
for(i in 1:length(env.prop.v)){
  test.output <- ds.sim(n.sibs,n.moms,n.pops,h,Vp,m,n.reps,env.prop.v[i])
  neutL <- length(test.output$NeutTest)
  envL <- length(test.output$EnvTest)
  if(neutL==n.reps) {
    neuts <- as.vector(test.output$NeutTest)
  } else {
    neuts <- c(as.vector(test.output$NeutTest),rep(NA,length.out=(n.reps-neutL)))
  }
  if (envL==n.reps) {
    envs<- as.vector(test.output$EnvTest)
  } else {
    envs <- c(as.vector(test.output$EnvTest),rep(NA,length.out=(n.reps-envL)))
  }
  env.power.n[,i] <- neuts
  env.power.e[,i] <- envs
  print(paste("fullrep",i))
}
write.csv(env.power.n,"~/driftselsims/env.power.n.csv",row.names=F)
write.csv(env.power.e,"~/driftselsims/env.power.e.csv",row.names=F)





#power
sum.sim <- function(sim.neut,sim.env){
  storeit <- c()
  for(i in 1:ncol(sim.neut)){
    int98 <- sort(sim.neut[,i])[c(3,97)]#96% interval?
    storeit[i] <- length(which(sim.env[,i] > int98[2] | sim.env[,i] < int98[1]))
  }
  return(storeit)
}

mom.power <- sum.sim(mom.power.n,mom.power.e)
sib.power <- sum.sim(sib.power.n,sib.power.e)
env.power <- sum.sim(env.power.n,env.power.e)
pop.power <- sum.sim(pop.power.n,pop.power.e)
h.power <- sum.sim(h.power.n,h.power.e)

par(mfrow=c(1,6))
hist(pop.power.n.2[,1],ylim=c(0,100),main=paste("Number of pops:",n.pops.v[1]),xlab=paste("Percent true correct:",pop.power.2[1]))
hist(pop.power.e.2[,1],col=rgb(0,0,1,alpha=.5),add=T)
hist(pop.power.n.2[,2],ylim=c(0,100),main=paste("Number of pops:",n.pops.v[2]),xlab=paste("Percent true correct:",pop.power.2[2]))
hist(pop.power.e.2[,2],col=rgb(0,0,1,alpha=.5),add=T)
hist(pop.power.n.2[,3],ylim=c(0,100),main=paste("Number of pops:",n.pops.v[3]),xlab=paste("Percent true correct:",pop.power.2[3]))
hist(pop.power.e.2[,3],col=rgb(0,0,1,alpha=.5),add=T)
hist(pop.power.n.2[,4],ylim=c(0,100),main=paste("Number of pops:",n.pops.v[4]),xlab=paste("Percent true correct:",pop.power.2[4]))
hist(pop.power.e.2[,4],col=rgb(0,0,1,alpha=.5),add=T)