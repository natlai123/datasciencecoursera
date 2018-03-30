function y=pcavarplot(return_data, position_data)
% Estimates VaR plot using principal components analysis 

% NB: Primary data entered as returns, not P/L.
% 
% Revised by Kevin Dowd, February 11th, 2001.
% *****************************************************************************************
%
for i=1:10
    pcavar_95(i)=pcavar(return_data,position_data,i,.95); 
    pcavar_99(i)=pcavar(return_data,position_data,i,.99); 
end
t=1:10;
subplot(2,1,1)
plot(t,pcavar_99)
subplot(2,1,2)
plot(t,pcavar_95)



