function [id, Pq, distor] = colorquantize(P, C, method)
% [id, Pq, distor] = colorquantize(P, C, method)
%
% Quantize the colors in a array @{P} using a given color 
% palette (codebook) @{C}. Each row of @{P} and @{C} is a color,
% defined by 3 columns. The color distance metric used is
% given in the parameter @{method} and must be in accordance
% with those provided by @{colordistance} method.
%
% Example
% pkg load image
% X = imread ('lena.png');
% P = reshape (double (X), [size(X,1)*size(X,2) 3]);
% C = [109 34 72; 224 165 146; 195 97 100];
% id = colorquantize(P, C, 'EUCLIDEAN');
% Xq = reshape (C(id, :), size(X));
% image(uint8(Xq));

% P matrix of points
% C centroids
% method distance method CIE76, CIE94, etc
% id indexes
% Pq quantized P
% distor distortion

id = []; Pq = [];
d = colordistance (P, C, method);
[Pq, id] = min(d, [], 2);

if nargout > 2,
  distor = sum ( sumsq (P - Pq, 2) ) / size (P,1); 
endif

endfunction
