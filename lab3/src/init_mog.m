% MOG = init_mog(X, C)
%
% Initialize the mixtures of Gaussian.
% Parameters are:
%   X (N x D)     : Data matrix, with N data points of dimensionality D.
%   C             : Number of mixtures.
% Returns:
%   MOG (C cells) : Current mixture of Gaussian data, containing the average
%                   MU, covariance SIGMA and mixing coefficient PI for each
%                   mixture.
%
% Compute the weight, mean and covariance of C slices of X, and store them in
% cells of structs in MOG respectively as 'PI', 'MU' and 'SIGMA'.
%
% Patrick de Kok
function MOG = init_mog(X, C)

MOG = cell(C, 1);
step = size(X, 1) / C;

for i=1:C
  slice = X((1 + floor((i - 1) * step)):floor(i * step), :);
  MOG{i} = struct('MU', mean(slice), 'SIGMA', cov(slice), 'PI', 1 / C);
end
