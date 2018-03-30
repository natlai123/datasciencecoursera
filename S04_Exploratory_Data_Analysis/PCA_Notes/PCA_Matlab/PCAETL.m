function y=pcaetl(return_data, position_data, number_of_principal_components,cl)
% PCAETL Estimates ETL by principal components analysis 
%
% Function estimates the ETL of a multi-position portfolio by principal components analysis, using 
% chosen number of principal components and a specified confidence level or range of confidence
% levels.
%
% The first input argument is a return data set entered as a matrix - each row is interpreted
% as a set of daily observations, and each column as the returns to each position in a portfolio. 
% The second input argument is a position-size vector, giving the amount invested in each position. 
% The third is the chosen number of principal components, and the fourth is the chosen confidence level,
% which may be a vector.
%
% NB: Primary data entered as returns, not P/L.
% 
% Revised by Kevin Dowd, February 11th, 2001.
% *****************************************************************************************
%
% Check that inputs have correct dimensions
%%
[m,n]=size(return_data);
    if min(m,n)==1
  error('Input data set has insufficient dimensionality');
end
if number_of_principal_components <0 
    error('Number of principal components must be positive')
end
if number_of_principal_components >n
    error('Number of principal components cannot exceed number of positions')
end
%
% Principal components estimation
%
[U,S,V]=svd(return_data,0);                                                   % SVD; provides U and V
svds(return_data,number_of_principal_components);% Returns required no of PC
index=n-number_of_principal_components; % Establishes how many zero terms on diagonal of S matrix
S_diag=[(svds(return_data,number_of_principal_components)); zeros(1,index)']; % Creates diagonal for S matrix
S=diag(S_diag) ;                                                               % Creates S matrix; S diagonal
synthetic_PandL_data=U*S*V'*position_data';         % Synthetic P/L data
%
% ETL
%
y=hsetl(synthetic_PandL_data,cl);                                    % ETL




