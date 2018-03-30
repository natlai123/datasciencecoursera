function y=pcaesplot(return_data, position_data)
% Estimates ES plot using principal components analysis 

% NB: Primary data entered as returns, not P/L.
% 
% Revised by Kevin Dowd, February 11th, 2001.
% *****************************************************************************************
%
for i=1:10
    pcaes_95(i)=pcaes(return_data,position_data,i,.95); 
    pcaes_99(i)=pcaes(return_data,position_data,i,.99); 
end
t=1:10;
subplot(2,1,1)
plot(t,pcaes_99)
subplot(2,1,2)
plot(t,pcaes_95)





