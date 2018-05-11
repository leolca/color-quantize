function [p, idx] = impalette (X, plength, method)
% [p, idx] = impalette (X, plength, method)
%
% Find the best color palette (codebook) for a given image,
% using a chosen color distance metric. You must provide
% the input image @{X}, the color palette length @{plength} and
% the desired color distance metric @{methor}, in accordance with
% the function @{colordistance}.
%
% example:
% X = imread ('lena.png');
% [p, idx] = impalette (X, 3, 'EUCLIDEAN');
 
% X image
% plength length of the desired palette
% method color distance metric

  if nargin < 3, method = 'CIE76'; endif
  method = upper (method);

  if any (strcmp ({'CIE76','CIE94','CIE2K'}, method)),
    X = rgb2lab (X);
  endif

  if isinteger (X), X = double (X); endif;
  P = reshape(X, [size(X,1)*size(X,2) 3]);
  colordistanceMethod = @(v1, v2) colordistance (v1, v2, method);
  [idx, p, sumD, dist] = kmeans (P, plength, colordistanceMethod);
  idx = reshape(idx, size(X,1), size(X,2));
  if any (strcmp ({'CIE76','CIE94','CIE2K'}, method)),
    p = 255*lab2rgb (p);
  endif

endfunction
