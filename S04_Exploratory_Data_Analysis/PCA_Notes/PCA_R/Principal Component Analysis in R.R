# Principal Component Analysis and Factor Analysis in R
# Copyright 2013 by Ani Katchova

library(readr)
pacr <- read_csv("/Users/nathaniellai/Desktop/SAS/PCA_Notes/pca_gsp.csv")
View(pacr)
#attach(mydata)

# Define variables
X <- cbind(pacr$Ag, pacr$Mining, pacr$Constr, pacr$Manuf, pacr$Manuf_nd, pacr$Transp, pacr$Comm, pacr$Energy, pacr$TradeW, pacr$TradeR, pacr$RE, pacr$Services, pacr$Govt)
colnames(X) <- c("Ag", "Mining", "Constr", "Manuf", "Manuf_nd", "Transp", "Comm", "Energy", "TradeW", "TradeR", "RE", "Services", "Govt")

# Descriptive statistics
summary(X)

# Principal component analysis
pca1 <- princomp(X, scores=TRUE, cor=TRUE)
summary(pca1)

# Loadings of principal components
loadings(pca1)
#pca1$loadings

# Scree plot of eigenvalues
# Variability of each principal component: pr.var
pr.var <- (pca1$sdev)^2

# Variance explained by each principal component: pve
pve <- pr.var / sum(pr.var)

# Plot variance explained for each principal component
plot(pve, xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Plot cumulative proportion of variance explained
plot(cumsum(pve), xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Biplot of score variables
biplot(pca1)
# variables Comm & TradeR and RE & TradeW have approximately the same loadings in the first two principal components
# points 21 and (2 or 50)  are the least similar in terms of the first principal component
# points 11 and 8 are the least similar in terms of the second principal component

# Scores of the components
pca1$scores[1:10,]

# Rotation
#varimax(pca1$rotation)
#promax(pca1$rotation)


# Factor analysis - different results from other softwares and no rotation
fa1 <- factanal(X, factor=3)
fa1

fa2 <- factanal(X, factor=3, rotation="varimax")
fa2

fa3 <- factanal(X, factors=3, rotation="varimax", scores="regression")
fa3
