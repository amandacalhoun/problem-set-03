%STANDARDIZ(X)  An m-file function to standardize a data matrix column-wise. 
%	Each row is assumed to be a data sample and each column a variable.
%	Standardiz will standardize each column by subtracting off the mean of
%	that column and then divide by its standard deviation to yield 
%	standard or Z-scores for each data point.
%
%	The input must be a matrix, the output is its standardized form.
%
function Y=standardiz(X)
[n,p]=size(X);
if n<2 | p<2
  disp('X must be a matrix, not a vector')
else
  e=ones(n,1);
  X=X-e*mean(X);
  Y=X ./(e*std(X));
end

