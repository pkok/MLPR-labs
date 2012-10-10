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
N_i = sum(Q);

% Number of data elements.
%   Equals sum(N_i).
N = size(X, 1);

for i = 1:size(MOG, 1)
  % Update the mean of the Gaussian mixture.
  %   Given by eq. 9.17 of Bishop.
  MOG{i}.MU = sum(repmat(Q(:,i), [1, 2]) .* X) / N_i(i);

  % Recompute the covariance...
  %   Given by eq. 9.19 of Bishop.
  sigma = repmat(Q(:,i)', [2, 1]) .* (X - repmat(MOG{i}.MU, [N, 1]))' * (X - repmat(MOG{i}.MU, [N, 1])) / N_i(i);

  % ... But only if it is a significant, not-almost-zero number.
  %   Given in the exercise.
  if cond(sigma) < 10^10
    MOG{i}.SIGMA = sigma;
  end

  % And a new value for the mixing coefficient.
  %   Given by eq. 9.22 of Bishop.
  MOG{i}.PI = N_i(i) / N;
end
