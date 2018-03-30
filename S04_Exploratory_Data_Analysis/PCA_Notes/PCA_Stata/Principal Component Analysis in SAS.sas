* Principal Component Analysis and Factor Analysis in SAS;
* Copyright 2013 by Ani Katchova;

libname pcan "/folders/myfolders/PCA_Notes";

proc import out= work.data
datafile= "/folders/myfolders/PCA_Notes/pca_gsp.csv" 
dbms=csv replace; getnames=yes; datarow=2; 
run;

%let xlist =Ag Mining Constr Manuf Manuf_nd Transp Comm Energy TradeW TradeR RE Services Govt;

proc means data=data;
var &xlist;
run;

proc corr data=data;
var &xlist;
run;

* Principal component analysis (PCA);
proc princomp data=data;
var &xlist;
run;

* PCA with 3 components;
proc princomp data=data 
n=3 
out=data;
var &xlist;
run;

* Plotting principal components;
proc plot data=data;
plot prin2*prin1;
run;

* Factor analysis;
proc factor data=data 
method=principal
priors=one
rotate=none 
scree;
var &xlist;
* method=prinit priors=smc;
run;

* Factor analysis with 3 factors;
proc factor data=data 
method=principal 
priors=one 
nfactors=3 
rotate=none
fuzz=0.3 
outstat=stats
plot nplot=2
out=data;
var &xlist;
run;

* Factor analysis with 3 factors and varimax rotation;
proc factor data=data 
method=principal 
priors=one 
nfactors=3 
rotate=varimax
fuzz=0.3;
var &xlist;
run;

proc plot data=data; 
plot factor2*factor1;
run;
