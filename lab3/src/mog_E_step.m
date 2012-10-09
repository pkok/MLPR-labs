% Expectation-step of the EM algorithm
% Returns:
%   - matrix Q, where the nth row contains the probability of the nth data
%   point of X belonging to each mixture of gaussians (gamma(z_k));
%   - scalar LL, the log-likelihood of the data set under the mixture model.
function [Q, LL] = mog_E_step(X, MOG)

Q = zeros(size(X,1), size(MOG, 1));
denominator = zeros(size(Q, 1), 1);

for i=1:size(MOG)
  Q(:, i) = MOG{i}.PI * mvnpdf(X, MOG{i}.MU, MOG{i}.SIGMA);
  denominator += Q(:, i);
end
Q ./= repmat(denominator, [1, size(MOG, 1)]);
LL = sum(log(denominator));
