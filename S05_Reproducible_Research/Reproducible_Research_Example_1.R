## Reproducible Research Example 1 
## Code from lecture slides

library(kernlab)
data(spam)

str(spam[, 1:5])

## Perform the subsampling
set.seed(3435)
trainIndicator = rbinom(4601, size = 1, prob = 0.5)
table(trainIndicator)
trainIndicator
trainSpam = spam[trainIndicator == 1, ]
testSpam = spam[trainIndicator == 0, ]
head(names(trainSpam), 20)
table(trainSpam$type)
boxplot(capitalAve ~ type, data = trainSpam)
boxplot(log10(capitalAve + 1) ~ type, data = trainSpam)
pairs(log10(trainSpam[, 1:4] + 1))
hCluster = hclust(dist(t(trainSpam[, 1:57])))
plot(hCluster)
hClusterUpdated = hclust(dist(t(log10(trainSpam[, 1:55] + 1))))
plot(hClusterUpdated)

# Create dummary variale for spam
trainSpam$numType = as.numeric(trainSpam$type) - 1
costFunction = function(x, y) sum(x != (y > 0.5))
cvError = rep(NA, 55)
library(boot)
for (i in 1:55) {
  lmFormula = reformulate(names(trainSpam)[i], response = "numType")
  glmFit = glm(lmFormula, family = "binomial", data = trainSpam)
  cvError[i] = cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2]
}
## Which predictor has minimum cross-validated error?
names(trainSpam)[which.min(cvError)]

## Use the best model from the group
predictionModel = glm(numType ~ charDollar, family = "binomial", data = trainSpam)
## Get predictions on the test set
predictionTest = predict(predictionModel, testSpam)
predictedSpam = rep("nonspam", dim(testSpam)[1])
## Classify as `spam' for those with prob > 0.5
predictedSpam[predictionModel$fitted > 0.5] = "spam"


# It turns out that the predictor that has the minimum cross
# validated error rate is this variable called charDollar. This is
# an indicator of the number of dollar signs in the email.

## Use the best model from the group
predictionModel = glm(numType ~ charDollar, family = "binomial", data = trainSpam)
## Get predictions on the test set
predictionTest = predict(predictionModel, testSpam)
predictedSpam = rep("nonspam", dim(testSpam)[1])
## Classify as `spam' for those with prob > 0.5
predictedSpam[predictionModel$fitted > 0.5] = "spam"

table(predictedSpam, testSpam$type)

## Error rate
(61 + 458)/(1346 + 458 + 61 + 449)

