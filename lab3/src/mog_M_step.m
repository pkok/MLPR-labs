% MOG = mog_M_step(X, Q, MOG)
%
% Maximization step of the EM algorithm
% Parameters are:
%   X (N x D)     : Data matrix, with N data points of dimensionality D.
%   Q (N x K)     : For each data point x_n, contains the responsibility 
%                       gamma(z_k) == p(z_k = 1 | x_n)     (Bishop eq. 9.13)
%   MOG (K cells) : Current mixture of Gaussian data, containing the average
%                   MU, covariance SIGMA and mixing coefficient PI for each
%                   mixture.
% Returns:
%   MOG (K cells) : The updated averages, covariances and mixing coefficients
%                   for each mixture of gradients.
%
% For every cell in MOG, it updates PI, MU and SIGMA.
%
% Patrick de Kok
function MOG = mog_M_step(X, Q, MOG)
% Number of elements per Gaussian mixture.
%   Given by eq. 9.18 of Bishop.
N_k = sum(Q);

% Number of data elements.
%   Equals sum(N_k).
N = size(X, 1);

for k = 1:size(MOG, 1)
  % Update the mean of the Gaussian mixture.
  %   Given by eq. 9.17 of Bishop.
  MOG{k}.MU = sum(repmat(Q(:,k), [1, 2]) .* X) / N_k(k);

  % Recompute the covariance...
  %   Given by eq. 9.19 of Bishop.
  sigma = repmat(Q(:,k)', [2, 1]) .* (X - repmat(MOG{k}.MU, [N, 1]))' * (X - repmat(MOG{k}.MU, [N, 1])) / N_k(k);

  % ... But only if it is a significant, not-almost-zero number.
  %   Given in the exercise.
  if cond(sigma) < 10^10
    MOG{k}.SIGMA = sigma;
  end

  % And a new value for the mixing coefficient.
  %   Given by eq. 9.22 of Bishop.
  MOG{k}.PI = N_k(k) / N;
end
