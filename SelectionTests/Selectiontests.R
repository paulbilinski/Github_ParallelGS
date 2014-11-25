setwd("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/SelectionTests/")

library("rrBLUP")

geno <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/SNP_data/Landrace_noSWUS_matrix.csv",header=TRUE,row.names=1)
dt <-t(geno)
A <- A.mat(dt)
#dim(A)

pheno <-read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/PhenotypeData/Landraces_noSWUS_pheno.csv",header=TRUE)

tmp1 <- as.data.frame(colnames(geno))
names(tmp1)[1] <- "names"
tmp2 <- as.data.frame(pheno$FullID)
tmp <- setdiff(tmp1,tmp2)

phenoorder <- merge(tmp1,pheno, by.x="names", by.y="FullID",sort=FALSE)
#write.csv(phenoorder,"crap.csv")

library ( mvtnorm )
EnvVarTest <- function ( phenos , kinship.mat , test.vector ) {
  
  # 'phenos' is a vector containing the phenotype (i.e. number of repeats) for each individual; dimensions are N x 1
  # 'kinship.mat' is the kinship matrix; dimensions are N x N; rows and columns need to be in the same order as the phenotypes in the vector
  # test.vector is the environmental factor of interest (in this case altitude)
  
  eigs <- eigen ( kinship.mat ) ## get eigendecomposition of kinship matrix
  rt.inv <- eigs$vec %*% diag ( sqrt(eigs$val) ) # calculate inverse of the square root matrix
  rotated.phenos <- t ( rt.inv ) %*% phenos # rotate phenotypes from population space into principal component space
  test.vector <- test.vector / (sqrt ( 2 * sum ( test.vector^2 ) ) ) # scale to be unit length after rotation
  #recover()
  rotated.vector <- rt.inv %*% test.vector # rotate environmental variable from population space into principal component space
  model <- lm ( rotated.phenos ~ 1+rotated.vector) # fit regression model
  r.sq <- cor.test ( rotated.phenos , rotated.vector )$estimate^2 # get r^2
  ANOVA <- anova ( model ) # get p value
  
  return ( c ( model$coef[2] , r.sq , ANOVA[5][[1]][1] )) # return 
}

EnvVarTest(phenoorder$X180knobMB,A,phenoorder$Altitude) #0.01525783
EnvVarTest(phenoorder$X180knob.,A,phenoorder$Altitude) #0.01525783
EnvVarTest(phenoorder$TR1MB,A,phenoorder$Altitude) #0.03250336
EnvVarTest(phenoorder$TR1.,A,phenoorder$Altitude) #0.03250336
EnvVarTest(phenoorder$CentCMB,A,phenoorder$Altitude) #0.007469612
EnvVarTest(phenoorder$CentC.,A,phenoorder$Altitude) #0.007469612

EnvVarTest(phenoorder$X1C_GS,A,phenoorder$Altitude) #0.02994667
EnvVarTest(phenoorder$CPMB,A,phenoorder$Altitude) #9.206042e-01
EnvVarTest(phenoorder$cDNAMB,A,phenoorder$Altitude) #0.08241996
EnvVarTest(phenoorder$TotallTeMB,A,phenoorder$Altitude) #0.02487928
EnvVarTest(phenoorder$TotFTeMB,A,phenoorder$Altitude)







