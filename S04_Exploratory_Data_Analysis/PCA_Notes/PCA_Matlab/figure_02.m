% Nathaniel
% 30/03/2018
% This script creates figure 2 in Notes on Principle Component Analysis

x=[13,9,10,6,8,-13,-9,-10,-6,-8]';
y=[13,10,9,8,6,-13,-10,-9,-8,-6]';
b1= regress(y,x);	% Correlation is 0.9889 

X=[x y]; coeff = pca(X);
[coeff,score,latent,tsquared,explained,mu] = pca(X);
% coeff = pca(X) returns the principal component coefficients, also known as loadings 
[pc] = X*coeff; pc1=pc(:,1);pc2=pc(:,2);

b2=regress(pc1, pc2)		% Correlation is effectively 0

% Setting up labels and titles
str1={'Before PCA'};
str2={'After PCA'};
str3={'$x$'};
str4={'$y$'};
str5={'$\tilde{x}$'};
str6={'$\tilde{y}$'};

% plotting data
subplot(1,2,1), scatter(x,y);
axis([-22,22,-22,22]); axis square; 
title(str1); 
xlabel(str3, 'Interpreter', 'latex'); 
ylabel(str4, 'Interpreter', 'latex');
subplot(1,2,2), scatter(score(:,1), score(:,2));
axis([-25,25,-25,25]); axis square; 
title(str2); 
xlabel(str5, 'Interpreter', 'latex'); 
ylabel(str6, 'Interpreter', 'latex');