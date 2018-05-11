% The USC-SIPI Image Database
% http://sipi.usc.edu/database/
% wget http://sipi.usc.edu/database/misc.zip -O /tmp/misc.zip
% cd /tmp/
% unzip misc.zip
% cd misc 
% a=1; for file in *; do new=$(printf "%04d.jpg" "$a"); convert "$file" "$new"; let a=a+1; rm $file; done
%
%
% http://www.ponomarenko.info/tid2008.htm

system ('./database.sh');
%system ('./instabase.sh');

pkg load signal
pkg load image
pkg load communications
pkg load statistics

dbpath = '/tmp/misc/'; %'/tmp/test/';
output = input ('enter output folder name: ', 's');
system ( sprintf('mkdir %s%s/', dbpath, output) );
if yes_or_no ("remove old results?"),
  system ( sprintf('rm %s%s/*', dbpath, output) );
endif
list = dir ( dbpath );
imtype = {'.tif','.jpg','.jpeg','.png','.bmp'};
id = false (size(list));
for k = 1 : length (imtype),
  id = id | (arrayfun(@(x) any(strfind(x.name, imtype{k})), list));
endfor
list = list(id);

flgplot = yes_or_no ("plot results?");

maxNumImgs = input ('enter the maximum number of images to process (leave empty for all images): ');
if isempty (maxNumImgs) || !isinteger (maxNumImgs),
  maxNumImgs = Inf;
endif
N = 16; % size of palette
methodlist = {'EUCLIDEAN', 'CIE76', 'CIE94'};
ditherlist = {'NONE', 'FLOYDSTEINBERG'};
d = [];
for k = 1 : min (length (list), maxNumImgs),
  filename = strcat (dbpath, list(k).name);
  disp (sprintf ('processing file: %s ...', filename) );
  X = imread (filename);
  for m = 1 : length(methodlist),
    method = methodlist{m};
    [p, idx] = impalette (X, N, method);
  for n = 1 : length(ditherlist), 
    dither = ditherlist{n};
    [idx, Xq] = imquantize (X, p, method, dither);
    %Xq = reshape(p(idx,:), size(X));
    iext = strchr(list(k).name,'.',1,"last");
    outfilename = strcat (dbpath, output, '/', list(k).name(1:iext-1), sprintf('_N=%d_%s_%s', N, method, dither), list(k).name(iext:end));
    imwrite (uint8(Xq), outfilename);
    % compute dissimilarities (MSE, PSNR, SSIM, Butteraugli) : 1, 2, 3, 4
    d(k,m,n,:) = permute( imagedistances (filename, outfilename), [4 3 2 1] );
    stitle = sprintf('quantized N=%d, (%s, %s)', N, method, dither);
    if flgplot,
      figure(1,"position", get(0,"screensize").*[1 1 1/2 1/3]);
      subplot(1,2,1); image(X); title('original'); 
      subplot(1,2,2); image(uint8(Xq)); title( stitle ); 
      pause(0.2);
    endif
    disp ( cstrcat (stitle, ' - output file: ', outfilename) );
    fflush (stdout);
  endfor
  endfor
endfor

diststr = {'MSE', 'PSNR', 'SSIM', 'Butteraugli'};
dmean = permute( mean(d,1), [3 2 4 1] );
for id = 1 : length (diststr),
  [m, ind] = min(reshape(dmean(:,:,id), size(dmean,1)*size(dmean,2),1));
  [r, c] = ind2sub(size(dmean(:,:,id)), ind);
  printf('the best result using %s metric was with %s color distance and %s dithering\n', diststr{id}, methodlist{c}, ditherlist{r});
endfor

% create data for boxplot (each column must be a combination of metric, color metric and dithering
xd = []; col = 1; xticklabel = {};
for k = 1 : length (diststr),    % MSE, PSNR, SSIM, Butteraugli
for i = 1 : length (methodlist), % EUCLIDEAN, CIE76, CIE94
for j = 1 : length (ditherlist), % NONE, FLOYDSTEINBERG
   xticklabel{col} = cstrcat ( ...
			substr ( diststr{k}, 1, min(5, length (diststr{k}))), '-', ...
			substr ( methodlist{i}, 1, min(5, length (methodlist{i}))) ,'-', ...
			substr ( ditherlist{j}, 1, min(5, length (ditherlist{j})))  );
   xd(:,col) = d(:,i,j,k);
   xd(:,col) -= min (xd(:,col));
   xd(:,col) /= max (xd(:,col));
   col++;
endfor;
endfor;
endfor;

%% normalize for each distintive metric
%idxdist = floor ( [0 : size(xd, 2)-1] / ( length (methodlist) * length (ditherlist) ) ) + 1;
%for k = 1 : length (diststr),
%  ids = find (idxdist == k);
%  thedata = xd(:,ids);
%  [pval,chisq] = chisqouttest(thedata(:));
%  if pval < 1E-4, % has outliers
%    
%  endif
%  minv = min ( min (xd(:,ids)) );
%  xd(:,ids) -= minv;
%  maxv = max ( max (xd(:,ids)) );
%  xd(:,ids) /= maxv;
%endfor

if flgplot,
  figure(2,"position", get(0,"screensize").*[1 1 1/2 1/3]);
  boxplot (xd, 1);
  xtick = [1:size(xd,2)];
  set (gca, 'xtick', xtick);
  xticklabel_rotate;
  title('Normalized Comparison Similarity Metric, Color Distance and Dithering');
endif

savefilename = cstrcat (date(), '_distances_N', num2str(N));
save ("-ascii" , savefilename, "d");

