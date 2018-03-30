* Principal Component Analysis and Factor Analysis in Stata
* Copyright 2013 by Ani Katchova
* Modified by Nathaniel Lai  23/08/2017 

clear all
set more off
cd "/Users/nathaniellai/Desktop/SASUniversityEdition/myfolders/PCA_Notes"
import delimited "/Users/nathaniellai/Desktop/SASUniversityEdition/myfolders/PCA_Notes/pca_gsp.csv", case(preserve) encoding(ISO-8859-1)clear

global xlist Ag Mining Constr Manuf Manuf_nd Transp Comm Energy TradeW TradeR RE Services Govt
local id State
local ncomp 3

describe $xlist
summarize $xlist
corr $xlist
sutex2 $xlist

* Principal component analysis (Use pca command to get a quick estimate but 
* the factor command to export output)
pca $xlist

/* Scree plot of the eigenvalues */
* screeplot
screeplot, yline(1) /* The , yline(1) set a horizontal line at y = 1 for reference */
graph export screeplot.png,replace

* Principal component analysis
pca $xlist, mineigen(1)  /* Only show Principal components (eigenvectors)  greater than 1 */
pca $xlist, comp($ncomp) /* Only show 3 Principal components (eigenvectors) see the local statement at the top */
pca $xlist, comp($ncomp) blanks(.3) /*If Principal components (eigenvectors) are below 0.3, make blank*/


* Component rotations
rotate, varimax
rotate, varimax blanks(.3)
rotate, clear

rotate, promax
rotate, promax blanks(.3)
rotate, clear

* Scatter plots of the loadings and score variables
loadingplot
scoreplot
scoreplot, mlabel($id)

* Loadings/scores of the components
estat loadings
predict pc1 pc2 pc3, score

* KMO measure of sampling adequacy
estat kmo


* Factor analysis
factor $xlist
* Exporting to Latex
ereturn list
matrix list e(L)
esttab, ///
    cells("L[1](t label(Factor 1)) L[2](transpose) L[3](t) Psi") ///
     nogap noobs nonumber nomtitle
return list


* Scree plot of the eigenvalues
screeplot
screeplot, yline(1)

* Factor analysis
factor $xlist, mineigen(1)
factor $xlist, factor($ncomp) 
factor $xlist, factor($ncomp) blanks(0.3)


* Factor rotations
rotate, varimax 
rotate, varimax blanks(.3)
rotate, clear

rotate, promax
rotate, promax blanks(.3)
rotate, clear

estat common

* Scatter plots of the loadings and score variables
loadingplot
scoreplot

* Scores of the components
predict f1 f2 f3

* KMO measure of sampling adequacy
estat kmo

* Average interitem covariance
alpha $xlist
