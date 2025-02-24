% PS03_DMG.M in this problem set I demonstrate how to use PCA/FA on 
%a real environmental datset
%SYNTAX
%   [U sumry AR SR]=PCA2(DAT,NFLAG) is an m-function that provides eigenvectors, 
%	eigenvalues, their % total variance, their cumulative % variance, principle 
%	component loadings, and principle component scores of the data provided 
%	in the matrix DAT.
% INPUT:
%	DAT is an n x m data matrix
%	NFLAG = 0, do not standardize data
%	      = 1, standardize data
% OUTPUT:
%	U is the m x m eigenvector matrix
%	sumry is the m x 3 matrix containing eigenvalues, percent variance, and
%	      cumulative variance by column
%	AR are the factor loadings for each variable (m x m)
%	SR is the n x m matrix of factor scores by column
%
% Submitted 2025:02:23 A. Calhoun, Harvard

%Clear previous work
clc; clear; close all
%load data
load satl.dat
depth = -satl(:,3);

%Part A
%Visualize data with four subplots
figure(1)
% First subplot
ax1 = subplot(1, 4, 1); % 4 rows, 1 column, first plot
scatter(satl(:,4), depth, 'r.');
xlabel('Temperature deg. C');
ylabel('Depth (m)');
xlim([-5 30]); 
ylim([-6100,0]);
% Second subplot
ax2 = subplot(1, 4, 2); % Second plot
scatter(satl(:,5), depth, 'g.');
xlabel('Salinity');
xlim([30 40]); 
ylim([-6100,0]);
% Third subplot
ax3 = subplot(1, 4, 3); % Third plot
scatter(satl(:,6), depth, 'b.');
xlabel('O2 umol/kg');
xlim([0 400]); 
ylim([-6100,0]);
% Fourth subplot
ax4 = subplot(1, 4, 4); % Fourth plot
scatter(satl(:,8), depth, 'k.');
xlabel('Nitrate umol/kg');
xlim([0 50]); 
ylim([-6100,0]);
% Link y-axes of all subplots
linkaxes([ax1, ax2, ax3, ax4], 'y');
% Adjust spacing
sgtitle('Depth Profiles of SAVE Parameters');


%Separate data into two matrices
Xupp = satl(satl(:,3)<=1000,4:10);
Xlwr = satl(satl(:,3)>1000,4:10);


%suspect that there are at least two underlying factors that are responsible for the distribution of these variables: biogeochemical processes 
% (photosynthesis, respiration, etc.) and physical processes (precipitation, upwelling, etc.). Let's see if you can design a principal 
% component--factor analysis to elucidate these factors.
disp('Question 1:')
fprintf("The variables longitude, latitude, and depth should not be included\n" + ...
    "in the current PCA/FA analyses. The latitude and longitude data will be\n" + ...
    "utilized later to determine where the factors are. Depth will not be utilized\n" + ...
    "during the PCA/FA analysis because the purpose of these analyses are to identify patterns\n" + ...
    "in the data set among and between variables. Depth is collected at regular intervals\n" + ...
    "and does not demonstrate any other variation. We also know that depth is a primary control on\n" + ...
    "all of the parameters that will be included in the PCA, which is why we separate the data\n" + ...
    "into groups above and below 1000 m depth. If we included depth in the PCA, we would learn\n" + ...
    "that all variables have a relationship with depth, but we are tryign to distinguish other processes\n" + ...
    "that may be affecting the distribution of nutrients, temperature, and salinity, so we exclude depth.\n" + ...
    "when attempting to identify factors (ex. biogeochemical or physical) that are responsible for the\n" + ...
    "distribution of the measured geochemical/geophysical parameters.\n\n")

% %Discuss whether or not you think the data should be standardized; this 
% % decision will effect the results of the rest of the problem, so think about it.
disp('Question 2:')
fprintf("The data should be standardized since the measured variables are on different scales and\n" + ...
    "have no defined upper limit. Therefore, it is best to standardize data to preserve the relative\n" + ...
    "differences in variables down depth profiles. Normalization (mean centering) would not be sufficient,\n" + ...
    "so we center around the column mean and scale variables by their standard deviations to put all variables\n" + ...
    "on the same unitless scale. Otherwise differences in units or scale of variables would skew the results of the PCA.\n\n")



%Part B
% %b) Calculate the eigenvectors, eigenvalues, factor matrix, and factor scores 
% % of both Xupp and Xlwr with pca2.m. Have your m-file display only the 
% % eigenvectors, the eigenvalues summary table and the factor matrix (loadings).

%INPUT:
%	DAT is an n x m data matrix
%	NFLAG = 0, do not standardize data
%	      = 1, standardize data
% OUTPUT:
%	U is the m x m eigenvector matrix
%	sumry is the m x 3 matrix containing eigenvalues, percent variance, and
%	      cumulative variance by column
%	AR are the factor loadings for each variable (m x m)
%	SR is the n x m matrix of factor scores by column

[Uupp,sumryupp,ARupp,SRupp]=pca2(Xupp,1);
[Ulwr,sumrylwr,ARlwr,SRlwr]=pca2(Xlwr,1);
%[U lam] = eig(cov(X)) - Other option to get eigenvalues and eigenvectors
%See assignment for math for the manual way

disp('Above 1000 m Depth')
disp('Eigenvectors')
disp(Uupp)
disp('Eigenvalues, % Variance, and Cumulative Var by Column')
disp(sumryupp)
disp('Factor Loadings')
disp(ARupp)


disp('Below 1000 m Depth')
disp('Eigenvectors')
disp(Ulwr)
disp('Eigenvalues, % Variance, and Cumulative Var by Column')
disp(sumrylwr)
disp('Factor Loadings')
disp(ARlwr)


%Part C
%Calculate communalities of the factors by summing 
Arupp = ARupp(:,1:4);
Arlwr = ARlwr(:,1:4);
for i = 1:size(Arlwr,1)   % Iterate over rows
    commlwr(i,1) = sum(Arlwr(i,:).^2);  % Sum of squares for each row
end

for i = 1:size(Arupp,1)   % Iterate over rows
    commupp(i,1) = sum(Arupp(i,:).^2);  % Sum of squares for each row
end

Rhat = Arupp*Arupp';
comm3 = diag(Rhat);
disp('Communalities Above 1000 m')
disp(commlwr)
disp('Communalities Below 1000 m')
disp(commupp)

% %What do these values represent?
disp('Question 3:')
fprintf("The communlatities represent how well the retained factors represent the\n" + ...
    "total variance of the original data vectors. In other words they indicate how well\n" + ...
    "the factors that the model user chooses to keep can explain the variance of each data column\n" + ...
    "in this example, aiding in the selection of the appropriate number of factors in factor analysis.\n\n")



% %d) Here is where we "cross over the line" between PCA and factor analysis. 
% % Based on the loadings, magnitudes of the eigenvalues and the communalities, 
% % how many factors should be kept for Xupp and Xlwr? How much variance do 
% % they account for? What are their communalities?
% 
figure(2)
h1 = plot(sumryupp (:,2), 'b-'); % Data points
hold on 
h2 = plot(sumrylwr (:,2), 'r-'); % Data points
xlabel('PC')
ylabel('Percent Variance Explained')
set(gca, 'FontSize', 18, 'LineWidth', 2) 
grid on
title('Scree Plot PCA')
legend([h1, h2], {'Above 1000 m', 'Below 100 m'}, 'Location', 'best');

%Loadings, magnitudes of eigenvalues
disp('Question 4:')
fprintf("From the PCA/FA analysis, I believe that 3 or 4 factors should be kept for the data\n" + ...
    "above and below 1000 m depth, depending on the real-world implications of the data analysis.\n" + ...
    "If using this PCA/FA for a paper, I would include four factors and describe how some variables seem\n" + ...
    "to have independent behaviors that make inclusion of a fourth factor beneficial for explained variance.\n" + ...
    "The loadings of the different factors, as visualized in the output images, suggest that three\n" + ...
    "factors are likely sufficient to describe the variability in the data for both the shallow and deep\n" + ...
    "ocean data. Similarly, the eigenvalues of the factors suggest that three factors are sufficient, since\n" + ...
    "the third factors have eigenvalues of 0.89 and 1.00 for the shallow and deep data, respectively. The\n" + ...
    "eigenvalues of the fourth factors are 0.43 and 0.24, respectively, which are significantly below a common\n" + ...
    "benchmark of 1.0 as a cutoff for retaining factors. \n\nHowever, the communalities indicate that a fourth factor\n" + ...
    "may be included if we hope to maximize explanation of variance of all variables. Three factors explain 92%% and\n" + ...
    "96%% of the variance of the Xupp and Xlwr data, while four factors account for 98.3%% and 99.6%% of the variance of\n" + ...
    "the Xupp and Xlwr data. Four factors explain almost all of the variance in the original datasets, while three explain\n" + ...
    "over 90%% of the total variance, which may be sufficient for some analyses. The comparison of the communalities from\n" + ...
    "FA using 3 vs. 4 factors suggest that four factors may be better for more comprehensive interpretation.\n" + ...
    "The salinity in the Xupp dataset has a communality of 85%% with 3 factors,\n" + ...
    "which increases to 99.8%% after addition of the fourth factor. Therefore, if we care about interpreting the\n" + ...
    "behavior of this variable, we should retain four factors to be thorough, though three factors would likely\n" + ...
    "suffice for some purposes. Similarly, in the Xlwr data, the communaltities of the salinity and silica\n" + ...
    "are 88%% and 68%%, respectively. Upon addition of a fourth factor, these communalities increase to 95.8%% and 99.2%%, respectively.\n" + ...
    "Therefore, there is a stronger argument for adding the fourth factor to the analysis of the deeper data to capture the\n" + ...
    "behavior of silica in the deep ocean.")

%Above 1000 m depth
figure(3); clf 
subplot(1,2,1)
plot(1:7, 100*sumryupp(:,2), '-k')
set(gca, 'XLim', [1 7], 'XTick', 1:1:7, 'YLim', [0 100])
xlabel('PC'); ylabel('%')
title('% of Variance by Each PC')

subplot(1,2,2)
plot(1:7, cumsum(100*sumryupp(:,2)), '-k')
set(gca, 'XLim', [1 7], 'XTick', 1:1:7, 'YLim', [0 100])
xlabel('PC'); ylabel('%')
title('Cumulative % of Variance')
sgtitle('Scree Plot Above 1000 m', 'FontWeight', 'bold', 'FontSize', 18)

figure(4); clf 
plot(ARupp(:,1), '-ko', 'MarkerSize', 12); hold on 
plot(ARupp(:,2), '-k^', 'MarkerSize', 12); hold on 
plot(ARupp(:,3), '-kd', 'MarkerSize', 12); hold on
plot(ARupp(:,4), '-ks', 'MarkerSize', 12); hold on
plot(ARupp(:,5), '-k.', 'MarkerSize', 12); hold on
plot(ARupp(:,6), '-kx', 'MarkerSize', 12); hold on
plot(ARupp(:,7), '-kh', 'MarkerSize', 12);
ylabel('Factor loadings of each PC')
xlabeltext = {'Temp.'; 'Salinity'; 'Oxygen'; 'Phosphate'; 'Nitrate'; 'Nitrite'; 'Silica'};
set(gca, 'xtick', 1:7, 'xticklabel', xlabeltext)
legend('PC1', 'PC2', 'PC3', 'PC4', 'PC5', 'PC6', 'PC7')
title('Factor Loadings for each PC Above 1000 m')


%Below 1000 m depth
figure(5); clf 
subplot(1,2,1)
plot(1:7, 100*sumrylwr(:,2), '-k')
set(gca, 'XLim', [1 7], 'XTick', 1:1:7, 'YLim', [0 100])
xlabel('PC'); ylabel('%')
title('% of Variance by Each PC')

subplot(1,2,2)
plot(1:7, cumsum(100*sumrylwr(:,2)), '-k')
set(gca, 'XLim', [1 7], 'XTick', 1:1:7, 'YLim', [0 100])
xlabel('PC'); ylabel('%')
title('Cumulative % of Variance')
sgtitle('Scree Plot Below 1000 m', 'FontWeight', 'bold', 'FontSize', 18)

figure(6); clf 
plot(ARlwr(:,1), '-ko', 'MarkerSize', 12); hold on 
plot(ARlwr(:,2), '-k^', 'MarkerSize', 12); hold on 
plot(ARlwr(:,3), '-kd', 'MarkerSize', 12); hold on
plot(ARlwr(:,4), '-ks', 'MarkerSize', 12); hold on
plot(ARlwr(:,5), '-k.', 'MarkerSize', 12); hold on
plot(ARlwr(:,6), '-kx', 'MarkerSize', 12); hold on
plot(ARlwr(:,7), '-kh', 'MarkerSize', 12);
ylabel('Factor loadings of each PC')
xlabeltext = {'Temp.'; 'Salinity'; 'Oxygen'; 'Phosphate'; 'Nitrate'; 'Nitrite'; 'Silica'};
set(gca, 'xtick', 1:7, 'xticklabel', xlabeltext)
legend('PC1', 'PC2', 'PC3', 'PC4', 'PC5', 'PC6', 'PC7')
title('Factor Loadings for each PC Below 1000 m')