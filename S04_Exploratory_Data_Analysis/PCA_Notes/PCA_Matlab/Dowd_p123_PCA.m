% Reproducing Dowd (2005) P123 
% Use functions: PCAVAR PCAETL pcavar pcaprelim 

% Generating simulated return data
sigma=[1	0.8	0.64	0.512	0.4096	0.32768	0.262144	0.2097152	0.16777216	0.134217728;
0.8	1	0.8	0.64	0.512	0.4096	0.32768	0.262144	0.2097152	0.16777216;
0.64	0.8	1	0.8	0.64	0.512	0.4096	0.32768	0.262144	0.2097152;
0.512	0.64	0.8	1	0.8	0.64	0.512	0.4096	0.32768	0.262144;
0.4096	0.512	0.64	0.8	1	0.8	0.64	0.512	0.4096	0.32768;
0.32768	0.4096	0.512	0.64	0.8	1	0.8	0.64	0.512	0.4096;
0.262144	0.32768	0.4096	0.512	0.64	0.8	1	0.8	0.64	0.512;
0.2097152	0.262144	0.32768	0.4096	0.512	0.64	0.8	1	0.8	0.64;
0.16777216	0.2097152	0.262144	0.32768	0.4096	0.512	0.64	0.8	1	0.8;
0.134217728	0.16777216	0.2097152	0.262144	0.32768	0.4096	0.512	0.64	0.8	1];
mu=zeros(1,10);

rng default  % For reproducibility
return_data = mvnrnd(mu,sigma,1000); % Genereating the returns

[coeff,score,latent,tsquared,explained,mu] = pca(return_data);
cumexp=(cumsum(latent)./sum(latent));

position_data = ones(1,10);
pcaprelim(return_data) 
figure;
PCAVAR(return_data, position_data, 2, 0.95)
PCAETL(return_data, position_data, 2, 0.95)
pcaes(return_data, position_data, 2, 0.9)
pcaesplot(return_data, position_data)

