function [idx, Xq] = imquantize (X, C, method, dither)
% [idx, Xq] = imquantize (X, C, method, dither)
%
% Apply vectorial quantization to an input image @{X} using a
% color palette @{C}, a color disnce metric @{method} and 
% a dithering method, provided in parameter @{dither}.
% The color metrics used must be one those supported by
% the @{colordistance} function. The dithering methods
% available are: 'FLOYDSTEINBERG' and 'NONE'.
%
% Example
% X = imread ('lena.png');
% [C, id] = impalette (X, 3, 'EUCLIDEAN');
% [idx, Xq] = imquantize (X, C, 'EUCLIDEAN', 'FLOYDSTEINBERG');
% image (uint8(Xq));

% X: image
% C: codebook / color palette
% dither: dithering method (default = none) 'FLOYDSTEINBERG', 'NONE'
% method: color distance method 'CIE76','CIE94','CIE2K'
%
% idx: quantized image codebook indexes 
% Xq: quantized image
%
  if nargin < 4, dither = []; endif
  if nargin < 3, method = []; endif

  if !isempty (dither),
    dither = upper (dither);
    if strcmp (dither, 'NONE'), dither = []; endif
  endif;
  if isempty (method),
    method = 'CIE76';
  endif

  if isinteger (X), X = double (X); endif
  if isinteger (C), C = double (C); endif


  Xq = []; idx = [];
  switch dither
    case {'FLOYDSTEINBERG'}
      for i=1:size(X,1),
      for j=1:size(X,2),
        [idx(i,j), Xq(i,j,:)] = imquantize (X(i,j,:), C, method);
        e = X(i,j,:) - Xq(i,j,:);
        if j < size(X,2),
           X(i,j+1,:)+=(7/16)*e;
        end;
        if i < size(X,1),
          if j > 1,
            X(i+1,j-1,:)+=(3/16)*e;
          elseif j < size(X,2),
            X(i+1,j+1,:)+=(1/16)*e;
          end;
          X(i+1,j,:)+=(5/16)*e;
        end;
      endfor
      endfor
    case {'BLABLA'}
      error ("dithering method not yet implemented");
  otherwise % no dithering
    d = colordistance (reshape (X, [size(X,1)*size(X,2) 3]), C, method);
    [mind, idx] = min(d, [], 2);
    Xq = C(idx,:); 
    Xq = reshape (Xq, size(X));
    idx = reshape (idx, [size(X,1) size(X,2)]);
  endswitch

endfunction
