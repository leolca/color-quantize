function d = ssimimages(filename1, filename2)
% wrapper to pyssim (SSIM implementation in python)
% https://github.com/jterrace/pyssim

  cmd = cstrcat('pyssim ', filename1, ' ', filename2);
  [status, output] = system(cmd);
  d = str2num(output);

endfunction
