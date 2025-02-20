% PS99_DMG.M in this problem set I demonstrate how the universe can be simulated
% with just three lines of MatLab code.
% SYNTAX:   [U,W,I]=ps99_dmg(X,Y,alpha)
%
% INPUT:    X = a matrix containing the distribution of religions on earth
%           Y = a vector containing the names of known star systems
%           alpha = an insanity parameter that varies from zero to one
% OUTPUT:   U = the universe matrix, distribution of carfloats
%           W = the world matrix, distribution of ring bearers
%           I = index vector containing the indices of ICBM's
%
% Started 2028:09:11 D. Glover, WHOI
% Modif'd 2028:09:12 DMG added insanity parameter to increase stability
% Modif'd 2028:09:13 DMG fixed disp command in my final run before I
% submitted my answer to the instructors.



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
%%%%ANSWER THIS PLEASE
fprintf("The variables longitude, latitude, and depth should not be included\n" + ...
    "in the current PCA/FA analyses. The latitude and longitude data will be\n" + ...
    "utilized later to determine where the factors are. Depth will not be utilized\n" + ...
    "during the PCA/FA analysis because the purpose of these analyses are to identify patterns\n" + ...
    "in the data set among and between variables. Depth is collected at regular intervals\n" + ...
    "and does not demonstrate any other variation. We also know that depth is a primary control on\n" + ...
    "all of the parameters that will be included in the PCA, which is why we separate the data\n" + ...
    " into groups above and below 1000 m depth. If we included depth in the PCA, we would learn\n" + ...
    "that all variables have a relationship with depth, but we are tryign to distinguish other processes\n" + ...
    "that may be affecting the distribution of nutrients, temperature, and salinity, so we exclude depth.\n" + ...
    "when attempting to identify factors (ex. biogeochemical or physical) that are responsible for the\n" + ...
    "distribution of the measured geochemical/geophysical parameters.\n\n")

% %Discuss whether or not you think the data should be standardized; this 
% % decision will effect the results of the rest of the problem, so think about it.
fprintf("The data should be standardized since the measured variables are on different scales and\n" + ...
    "have no defined upper limit. Therefore, it is best to standardize data to preserve the relative\n" + ...
    "differences in variables down depth profiles. Normalization (mean centering) would not be sufficient,\n" + ...
    "so we center around the column mean and scale variables by their standard deviations to put all variables\n" + ...
    "on the same unitless scale.\n\n")



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
Arupp = ARupp(:,1:3);
Arlwr = ARlwr(:,1:3);
for i = 1:size(Arlwr,1)   % Iterate over rows
    commlwr(i,1) = sum(Arlwr(i,:).^2);  % Sum of squares for each row
end

for i = 1:size(Arupp,1)   % Iterate over rows
    commupp(i,1) = sum(Arupp(i,:).^2);  % Sum of squares for each row
end

Rhat = Arupp*Arupp';
comm3 = sqrt(diag(Rhat));


% %What do these values represent?
fprintf("The communlatities represent how well the retained factors represent the\n" + ...
    "total variance when compared to the original variance. In other words...")



% %d) Here is where we "cross over the line" between PCA and factor analysis. 
% % Based on the loadings, magnitudes of the eigenvalues and the communalities, 
% % how many factors should be kept for Xupp and Xlwr? How much variance do 
% % they account for? What are their communalities?
% 
figure(2)
h1 = plot(sumryupp (:,1), 'b-'); % Data points
hold on 
h2 = plot(sumrylwr (:,1), 'r-'); % Data points
xlabel('# Of Eigenvalue')
ylabel('Eigenvalue')
set(gca, 'FontSize', 18, 'LineWidth', 2) 
grid on
title('Scree Plot PCA')
legend([h1, h2], {'Above 1000 m', 'Below 100 m'}, 'Location', 'best');


fprintf("Depending on the analysis, 3 or 4 factors should be kept for Xupp and Xlwr\n" + ...
    "Thre factors account for ___ of the variance of the Xupp and ___ of the variance\n" + ...
    "of Xlwr data. This shows that these three factors explain a large proportion of\n" + ...
    "the variance in the original data. ")

% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % >>load demo1.dat (return)
% % >>load demo2.dat (return)
% % >>load demo2.dat (return)
% % >>demo1 (return)
% % >>demo(1,1) (return)
% % >>plot(demo1,demo2) (return)
% % >> title('Demoplot')
% % >> xlabel('demo1')
% % >> ylabel('demo2')
% % >> text(10,100,'here is some text')
% % a=('The information in the plot clearly shows the blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah...')
% % a
% % 
% % % This m-file is part of the problem set demo created by T. Kenna on 8/16/98
% % % note that lines that begin with % are ignored as program lines by matlab
% % %
% % % Here comes the real program
% % %
% % load demo1.dat % loads the first demo file
% % load demo2.dat % loads the second demo file
% % demo1(1,1) % prints the first member of demo1
% % figure(1)
% % plot(demo1,demo2)
% % title('Demoplot')
% % xlabel('demo1')
% % ylabel('demo2')
% % text(10,100,'here is some text')
% % a=('The information in the plot clearly shows the blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah...')
% % 
% % disp('hit any key to resume program' )
% %         pause % This will suspend the program until you are ready to move on
% %         figure(2)
% %         plot(sin(demo1),tan(demo2),'*g')
% %         title('The second plot')
% %         xlabel('Sine of demo1')
% %         ylabel('Tangent of demo2')
% %         b=('Plot number 2 shows the extent to which plot number 2 was yada yada yada')
