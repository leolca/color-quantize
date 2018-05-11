# color-quantize
color quantization


Example:
```octave
octave:70>  X = imread ('lena.png');
octave:71>  [C, id] = impalette (X, 3, 'EUCLIDEAN');
octave:72>  [idx, Xq] = imquantize (X, C, 'EUCLIDEAN', 'FLOYDSTEINBERG');
octave:73>  image (uint8(Xq));
octave:74> imwrite (uint8(Xq), 'lena-n3-euclidean-floydsteinberg.png')
```

![lenaquantized](lena-n3-euclidean-floydsteinberg.png)
