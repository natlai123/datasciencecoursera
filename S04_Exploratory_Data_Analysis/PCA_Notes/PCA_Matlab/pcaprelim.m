function y=pcaprelim(return_data)
% PCAPRELIM Preliminary principal components analysis
%
% Function estimates the principal components of a return data set, and generates a 
% scree plot showing the percentage variability explained by each. 
%
% This data set is entered as a matrix - each row is interpreted as a set of daily observations, 
% and each column as the returns to each position in a portfolio. 
%
% Revised by Kevin Dowd, February 11th, 2001.
% *****************************************************************************************
%
% Check that input has correct dimensions
%
[m,n]=size(return_data);
    if min(m,n)==1
  error('Input data set has insufficient dimensionality');
end
%
% Principal components estimation
%
[pcs,newdata,variances]=pca(return_data);
%
% Scree plot
%
percent_explained=100*variances/sum(variances);
pareto(percent_explained)
%text(0.5*n,50,'Curve: cumulative explanatory power')
%text(0.5*n,40,'Bars: individual explanatory power')
xlabel('Principal component','Fontweight','bold')
ylabel('Variance explained (%)','Fontweight','bold')
title('Explanatory Power of the Principal Components','Fontweight','bold')
