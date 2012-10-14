% [f_, sigma2_, LLog] = gaussian_process(X, t, k, sigma2, x_)
%
% Compute the most likely prediction and variance on our prediction, together
% with the probability of the training data under the model.
% Parameters are:
%   X (N x D) : Training data, with N data points of dimensionality D.
%   t (N x 1) : Training targets for each training data point.
%   k         : Covariance function
%   sigma2    : Noise level
%   x_        : A test input. Its target will be predicted.
% Returns:
%   f_        : The most likely prediction for the test input x_.
%   sigma2_   : The variance on the prediction.
%   LLog      : How probable is our training data under the model?
%
% Patrick de Kok
%function [f_, sigma2_, LLog] = gaussian_process(X, t, k, sigma2, x_)
function [f_, sigma2_, LLog] = gaussian_process(X, t, k, sigma2, x_)
N = size(X, 1);

K = zeros(N, N);
for i=1:N
  for j=1:N
    K(i,j) = k(X(i,:), X(j,:));
  end
end

k_ = zeros(N, 1);
for i=1:N
  k_(i, 1) = k(X(i,:), x_);
end

L = chol(K + (sigma2 * eye(N)), 'lower');
alpha = L' \ (L \ t);
f_ = k_' * alpha;
v = L \ k_;
sigma2_ = k(x_, x_) - v' * v;
LLog = -0.5 * t' * alpha - sum(diag(L)) - (N / 2) * log(2*pi);
