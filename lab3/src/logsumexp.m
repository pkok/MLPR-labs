% logsum = logsumexp(data)
%
% Logaritmic sum of elements along the first dimension of data.
% For data of n rows of m-dimensional horizontal vectors, logsum will be of
% size [1, m].
% Two logaritmic values [v, w] = log([x, y]) and v > w can be summed as:
%     log(x + y) = v + log(1 + exp(w - v))
%
% Patrick de Kok
function logsum = logsumexp(data, dim)
if nargin == 1
  dim = 1;
end

if size(data, dim) == 1
  data = transpose(data);
end

high = max(data, [], dim);
low = min(data, [], dim);
logsum = high + log(1 + exp(low - high));
