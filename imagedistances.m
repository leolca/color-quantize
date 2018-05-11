function d = imagedistances (fileA, fileB) 
% d = imagedistances (fileA, fileB)
%
% Compute a vector of different image distances:
% 1) MSE, 2)PSNR, 3) SSIM, 4) Butteraugli
%

 % fileA : orignal/reference image
 % MSE, PSNR, SSIM, Butteraugli

 X = double ( imread (fileA) );
 Y = double ( imread (fileB) );

 d(1) = immse (Y, X);
 d(2) = psnr (Y, X);
 d(3) = ssimimages (fileA, fileB);
 d(4) = butteraugli (fileA, fileB);

endfunction
