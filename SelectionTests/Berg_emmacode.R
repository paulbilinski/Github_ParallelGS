library ( emma )
library(mvtnorm)
A <- read.csv("~/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/PhenotypeData/Final_Phenotypes/Landrace_kinshipmatrix.csv",row.names="X")

#setwd("~/Documents/Academics/Arabidopsis/")
#cov.mat <- as.matrix ( read.table("cov_matrix_rrBLUP.txt") )
cov.mat <- as.matrix ( A [ 1:82 , 1:82 ] ) #when it reads in mine, it reads it as a dataframe not a matrix, paul you screwed that up by remaking it and telling it to read it as a dataframe.
#diag ( cov.mat)<- diag(cov.mat) + 0.001

#make up some altitudes
altitude <- rnorm ( 82 )

# make up some genome sizes
genome <- rmvnorm ( n = 1 , mean = rep ( 10 , 82 ) + altitude , sigma = cov.mat )

# simulate some genetic values
gen.vals <- rmvnorm ( n = 1000 , mean = rep ( 10 , 82 ) + altitude , sigma = 0.7*cov.mat ) 

# simulate some error terms
errors <- t ( replicate ( 1000 , rnorm (  82 , 0 , 0.3 ) ) )

# add genetic values and error terms together to simulate out data
phenos <- gen.vals + errors

b.vects <- rnorm ( 82 )

genome
alts <- t ( as.matrix ( b.vects , ncol = 1 ))


# test for genome size alone (similar for knobs)
temp <- emma.REML.t ( genome , t ( as.matrix ( altitude , ncol = 1 ) ) , K = cov.mat )
hist ( temp$ps )
?emma.REML.t
# test for other components with genome size as covariate
temp <- emma.REML.t ( phenos , t ( as.matrix ( b.vects , ncol = 1 ) ) , X0 =  cbind ( rep ( 1 , 82 ) , c ( genome ) ) , K = cov.mat )