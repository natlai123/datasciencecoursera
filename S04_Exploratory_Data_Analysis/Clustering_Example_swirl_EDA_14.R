## This script contains the code from the R package swirl course EDA, sessions 14, clustering examples. 

## We're interested in questions such as, "Is the correlation between the measurements and 
## activities good enough to train a machine?" so that "Given a set of 561 measurements, would 
## a trained machine be able to determine which of the 6 activities the person was doing?"

dim(ssd)
names(ssd[,562:563])
sum(table(ssd$subject)) 
table(ssd$activity)
sub1 <- subset(ssd, subject == 1)
dim(sub1)
# myedit("showXY.R")

par(mfrow=c(1, 2), mar = c(5, 4, 1, 1))
plot(sub1[, 1], col = sub1$activity, ylab = names(sub1)[1])
plot(sub1[, 2], col = sub1$activity, ylab = names(sub1)[2])
legend("bottomright",legend=unique(sub1$activity),col=unique(sub1$activity), pch = 1)
par(mfrow=c(1,1))

# Clustering on the 3 dimensions of mean acceleration
mdist <- dist(sub1[,1:3])
hclustering <- hclust(mdist)
myplclust(hclustering, lab.col = unclass(sub1$activity))

par(mfrow=c(1, 2), mar = c(5, 4, 1, 1))
plot(sub1[, 10], col = sub1$activity, ylab = names(sub1)[1], pch = 19)
plot(sub1[, 11], col = sub1$activity, ylab = names(sub1)[2], pch = 19)
legend("bottomright",legend=unique(sub1$activity),col=unique(sub1$activity), pch = 19)
par(mfrow=c(1,1))

# Clustering on the 3 dimensions of maximum acceleration
mdist <- dist(sub1[,1:3])
names(sub1[,10:12])
mdist <- dist(sub1[,10:12])
hclustering <- hclust(mdist)
myplclust(hclustering, lab.col = unclass(sub1$activity))

svd1 <- svd(scale(sub1[,-c(562,563)]))
dim(svd1$u)

par(mfrow=c(1, 2), mar = c(5, 4, 1, 1))
plot(svd1$u[, 1], col = sub1$activity, ylab = names(sub1)[1], pch = 19)
plot(svd1$u[, 2], col = sub1$activity, ylab = names(sub1)[2], pch = 19)
par(mfrow=c(1,1))

plot(svd1$v, col=rgb(0, 0, 1, 0.5), pch=19)

# Clustering to find the feature (out of the 500+) which contributes the most to
# the variation of this second column of svd1$v.
maxCon <- which.max(svd1$v[,2])
mdist <- dist(sub1[,c(10:12,maxCon)])
myplclust(hclustering, lab.col = unclass(sub1$activity))
names(sub1[maxCon])
# The mean body acceleration in the frequency domain in the Z direction is the main 
# contributor to this clustering phenomenon we're seeing.

# k-means clustering to see if this technique can distinguish between the activities
kClust <- kmeans(sub1[, -c(562, 563)], centers = 6)
table(kClust$cluster, sub1$activity)
kClust <- kmeans(sub1[, -c(562, 563)], centers = 6, nstart = 100)
str(kClust)
table(kClust$cluster, sub1$activity)
dim(kClust$centers) # the centers are a 6 by 561 array

laying <- which(kClust$size == 29)
plot(kClust$centers[laying,1:12], pch = 19, ylab = "Laying Cluster")
# the 3 directions of mean body acceleration seem to have the biggest effect on laying.

walkdown <- which(kClust$size==49)
plot(kClust$centers[walkdown,1:12], pch = 19, ylab = "Walkdown Cluster")
# From left to right, looking at the 12 acceleration measurements in groups of 3, 
# the points decrease in value. The X direction dominates, followed by Y then Z. 
# This might tell us something more about the walking down activity.

# We saw here that the sensor measurements were pretty good at discriminating between 
# the 3 walking activities, but the passive activities were harder to distinguish from 
# one another. These might require more analysis or an entirely different set of sensory measurements. 


