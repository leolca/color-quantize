function [labels, center, sumd, d] = kmeans (P, k, distance)
% [labels, center, sumd, d] = kmeans (P, k, distance)
%
% This function implements the Lloyds algorithm to solve the
% k means problem. The initial centroids are k randomly selected
% points from matrix P. This function takes 3 input arguments:
% a matrix P with samples as rows, the number of desired centroids k
% and the distance function handle to be used. 
% The outputs are the labels (classification of each point in P),
% the k centroids, the MSE distortion and the final distance matrix 
% between each row of P and each centroid.
%

% k-mean algorithm
% P : data matrix
%  each row is a sample
% distance : distance function handle

n = size(P,1); % number of samples
m = size(P,2); % dimensions
ind = randperm(n);

% sort k centers from P
center = [];
for i = 1 : k,
  center(i,:) = P(ind(i),:);
end;


dist_c = 1E3;
while dist_c > 1E-3,
  % calculate distances
  d = feval (distance, P, center);
  [md, labels] = min(d, [], 2);

  %calculate new centers
  dist_c = 0;
  center_new = []; sumd = [];
  for i = 1 : k,
    idk = find (labels == i);
    center_new(i,:) = mean (P(idk,:), 1);
    sumd = sum (md(idk));
  endfor;
  % distancia dos centroides novos para os velhos
  Dc = feval (distance, center, center_new);
  % distancia apenas entre os centroides equivalentes
  dc = []; for i = 1 : size(Dc,1),  dc(i) = Dc(i,i);  end;
  % achar a maior distancia
  dist_c = max(dc);
  % atualiza os centroides
  center = center_new;
endwhile;
