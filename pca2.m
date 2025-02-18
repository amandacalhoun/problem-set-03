function [U,sumry,AR,SR]=pca2(dat,nflag)
% [U sumry AR SR]=PCA2(DAT,NFLAG) is an m-function that provides eigenvectors, 
%	eigenvalues, their % total variance, their cumulative % variance, principle 
%	component loadings, and principle component scores of the data provided 
%	in the matrix DAT. This m-function is good for "fishing trips" when 
%	looking for structure in data sets AND it gives you a choice whether to
%	standardize the data or not. This m-file reorders the eigenvectors and
%	eigenvalues for you so that they are in descending order.
%
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
%	see also EOF, FACTER
%
% Started 1998:01:14 D. Glover, WHOI
% Modif'd 1998:09:24 DMG added documentation and sorted eigenvalues descending
% Modif'd 1999:06:14 DMG changed variable SUM (oops) to sumry, PC ignored case
% Modif'd 2010:09:21 DMG to switch to colstd.m for standardization

[n m]=size(dat);

% First check to see if the data should be standardized

if nflag == 0
   ndat=dat;
else
   [ndat, colmeans, colstds]=colstd(dat);
end

% Extract the eigenvectors and eigenvalues

[U lam]=eig(cov(ndat));
lam=diag(lam);

% Now sort the eigenvalues and eigen vectors

[lam ilam]=sort(lam);
for j=1:m
   Utemp(:,j)=U(:,ilam(j));
end %for

U=Utemp;

% Now reverse the order so that they are descending

lam=lam(m:-1:1);
U=U(:,m:-1:1);

% Calculate the Factor Scores and Factor Loadings

SR=ndat*U;
AR=U*(diag(lam.^0.5)');

% Calculate some additional statistics for output

var=sum(lam);
pcvar=lam/var;
cumvar=cumsum(pcvar);
sumry=[lam pcvar cumvar];

