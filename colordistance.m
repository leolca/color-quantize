function d = colordistance (v1, v2, method)
% d = colordistance (v1, v2, method)
%
% Compute the difference or distance between two colors @{v1} and @{v2} 
% according to a given metric provided in argument @{method}.
% Each column must be provided as a row vector with 3 components.
% If @{v1} and/or @{v2} are arrays of colors (matrices), this function will
% compute the distance matrix among the entries. 
% The color metrics available are: 'EUCLIDEAN' (RGB), 'CIE76', 'CIE94' 
% and 'CIE2000' (CIELAB space).
%
% example:
% pkg load image
% X = imread ('lena.png');
% LenaPixel1  = permute (X(1,1,:), [1 3 2]);
% LenaPixel20 = permute (X(1,20,:), [1 3 2]);
% d = colordistance ( LenaPixel1, LenaPixel20, 'EUCLIDEAN')
% d = colordistance (rgb2lab (LenaPixel1), rgb2lab (LenaPixel20) , 'CIE94') 
%
% Reference:
% https://en.wikipedia.org/wiki/Color_difference


  if nargin < 3, method = 'CIE76'; endif
  method = upper (method);

  if size (v1, 2) != 3 || size (v2, 2) != 3,
     error ("Entries v1 and v2 must have 3 columns!");
  endif

  switch method
    case {'EUCLIDEAN'}
       d = dEuclidean (v1, v2); 
    case {'CIE76'}
       d = dCIE76 (v1, v2);
    case {'CIE94'}
       d = dCIE94 (v1, v2);
    case {'CIE2K', 'CIE2000'}
       d = dCIE2k (v1, v2);
    otherwise
       error ("invalid value");
  endswitch

endfunction

function d = dEuclidean (v1, v2)
  v2 = v2';
  d = sqrt ( (v2(1,:)-v1(:,1)).^2 + (v2(2,:)-v1(:,2)).^2 + (v2(3,:)-v1(:,3)).^2 );
endfunction

function d = dCIE76 (v1, v2)
  v2 = v2';
  d = sqrt ( (v2(1,:)-v1(:,1)).^2 + (v2(2,:)-v1(:,2)).^2 + (v2(3,:)-v1(:,3)).^2 );
endfunction

function d = dCIE94 (v1, v2)
  v2 = v2';
  dL = v1(:,1) - v2(1,:);
  C1 = sqrt ( v1(:,2).^2 + v1(:,3).^2 );
  C2 = sqrt ( v2(2,:).^2 + v2(3,:).^2 );
  dCab = C1 - C2;
  dHab = sqrt ( (v1(:,2)-v2(2,:)).^2 + (v1(:,3)-v2(3,:)).^2 - dCab.^2 );
  KC = KH = 1;
  KL = 1; %2
  K1 = 0.045; % 0.048
  K2 = 0.015; % 0.014
  SL = 1;
  SC = 1 + K1.*C1;
  SH = 1 + K2.*C1;
  d = sqrt ( (dL./(KL.*SL)).^2 + (dCab./(KC.*SC)).^2 + (dHab./KH.*SH).^2 );
endfunction


function d = dCIE2k (v1, v2)
endfunction

