%       	function [Z, rowmeans, rowstds] = rowstd(X)
% 
%           returns the row-standardized version of the data matrix
%           along with vectors containing the column means and
%           standard deviations
%           NB: this routine fails if any element of rowstds is zero
%
	function [Z, rowmeans, rowstds] = rowstd(X)
    [Z,rowmeans,rowstds]=colstd(X');        % use colstd on transpose
    Z=Z';                                   % and transpose
    rowmeans=rowmeans';                     % make column vectors
    rowstds=rowstds';                       % make column vectors
    