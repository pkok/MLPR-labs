% [Q, LL] = mog_E_step(X, MOG)
%
% Expectation-step of the EM algorithm
% Parameters are:
%   X (N x D)     : Data matrix, with N data points of dimensionality D.
%   MOG (K cells) : Current mixture of Gaussian data, containing the average
%                   MU, covariance SIGMA and mixing coefficient PI for each
%                   mixture.
% Returns:
%   Q (N x K)     : For each data point x_n, contains the responsibility 
%                       gamma(z_k) == p(z_k = 1 | x_n)     (Bishop eq. 9.13)
%   LL            : The log-likelihood of the data set under the mixture
%                   model ln p(X | MOG), according to eq. 9.14 of Bishop.
%
% Patrick de Kok
function [Q, LL] = mog_E_step(X, MOG)

Q = zeros(size(X,1), size(MOG, 1));
denominator = zeros(size(Q, 1), 1);

% Responsibilities of each component are computed for each data point at once.
%  Single computation given by eq. 9.13 of Bishop.
for i=1:size(MOG)
  Q(:, i) = MOG{i}.PI * mvnpdf(X, MOG{i}.MU, MOG{i}.SIGMA);
  denominator = denominator + Q(:, i);
end
Q = Q ./ repmat(denominator, [1, size(MOG, 1)]);

% The log-likelihood is the sum of all (mixing coefficients * gaussian
% distributions).  Most is already computed for Q.
%   Given by eq. 9.14 of Bishop.
LL = sum(log(denominator));
