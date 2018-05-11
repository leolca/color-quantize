function d = butteraugli(filename1, filename2)
% wrapper to Butteraugli
% https://github.com/google/butteraugli

  cmd = cstrcat('butteraugli ', filename1, ' ', filename2);
  [status, output] = system(cmd);
  d = str2num(output);

endfunction
