% Nathaniel 
% 30/03/2018
% This script runs PCA on data from Michael Miller interest rate data 
% See https://www.mathworks.com/products/statistics/features.html#dimensionality-reduction

% Import Data
[~, ~, raw] = xlsread('/Users/nathaniellai/Desktop/SAS/PCA_Notes/PCA_Interest_Data.xlsx');
raw = raw(2:end,:);
stringVectors = string(raw(:,1));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[2,3,4,5,6,7]);
data = reshape([raw{:}],size(raw));
T1 = data(:,1);
T2 = data(:,2);
T3 = data(:,3);
T5 = data(:,4);
T10 = data(:,5);
T30 = data(:,6);
Date = stringVectors(:,1);
clear data raw stringVectors;

% Create a Datetime objects
Date = datetime(Date,'Format','dd MMM yy');

% Create a Matrix for PCA
P=[T1 T2 T3 T5 T10 T30]; 

% Calculate Means for T1 to T30
M1=mean(P(:,1)); M2=mean(P(:,2)); M3=mean(P(:,3));
M5=mean(P(:,4)); M10=mean(P(:,5)); M30=mean(P(:,6));

% Calculate Stds for T1 to T30
sd1=std(P(:,1)); sd2=std(P(:,2)); sd3=std(P(:,3));
sd5=std(P(:,4));sd10=std(P(:,5)); sd30=std(P(:,6));

% Standardization
N1=(P(:,1)-M1)/sd1; N2=(P(:,2)-M2)/sd2; N3=(P(:,3)-M3)/sd3;
N5=(P(:,4)-M5)/sd5; N10=(P(:,5)-M10)/sd10; N30=(P(:,6)-M30)/sd30;

% A Spared Matrix - Normalized Data (Miller: Chapter_09_PCA_Interest_Rates)
P_N = [N1 N2 N3 N5 N10 N30];

%pcaprelim(P_N);
[coeff,score,latent,tsquared,explained,mu] = pca(P_N);
latex(cumsum(latent)./sum(latent)); % cum eigvalues

% Recover the orginal data
P_recover=(score*coeff'.*[sd1 sd2 sd3 sd5 sd10 sd30])+ [M1 M2 M3 M5 M10 M30];

% Using the first 3 PC to approxiate the original data
% Method 1: Eigven Decomposition
score_3 = score;
score_3(:,4:6)=0;
P_3pc=([score_3]*coeff'.*[sd1 sd2 sd3 sd5 sd10 sd30])+ [M1 M2 M3 M5 M10 M30];

% Method 2: SVD 
[U,S,V] =svd(P_N,0);
S_diag = [(svds(P_N,3)); zeros(1,3)']
S = diag(S_diag) ;
P_svd = ((U*S*V').*[sd1 sd2 sd3 sd5 sd10 sd30]) + [M1 M2 M3 M5 M10 M30];

% Verify the differences between using eign depcomposition and SVD are insignificant
sum(sum(P_3pc - P_svd))
% Verify first 3 PCs using eign depcomp. approx. the orginal data well
sum(sum(P - P_3pc))
% Verify first 3 PCs using SDV approx. the orginal data well
sum(sum(P - P_svd))


% Plotting
term=[1 2 3 5 10 30];

% Generate figure_02 (Miller(2013) Exhib 9.16)
plot(term, coeff(:,1), '-b+'); hold on
plot(term, coeff(:,2), '-r*'); hold on
plot(term, -coeff(:,3),'-ko'); hold on
legend({'eigvector1','eigvector2','eigvector3'},'location','southeast');
axis([-3, 33, -1, 1]); hold off
pause(1);

% Generate figure_01 (Miller(2013) Exhib 9.17) 
figure()
plot(Date, P_3pc(:,1),'-b'); hold on 
plot(Date, P(:,1),'-k'); hold off
legend({'PC_1','Actual_1'},'location','best');
pause(1);
% plot(Date, P_3pc(:,1), 'DatetimeTickFormat', 'MMM dd yyyy')
% plot(Date, P_3pc(:,1), 'DatetimeTickFormat', 'QQQ yyyy')

% Generate figure_05 (Plotting component scores)
% Create a plot of the first two columns of score.
figure()
plot(score(:,1),score(:,2),'+')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
%gname
pause(1);

%Create scree plot.
figure()
pareto(explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')


%g=1:373;
% gscatter3(x,y,z,g,{'b','g','m'},{'.','.','.'}); 
% Nevermind this function can only handle up to 128 groups.
