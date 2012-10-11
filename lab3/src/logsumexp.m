% logsum = logsumexp(data)
%
% Logaritmic sum of elements along the first dimension of data.
% For data of n rows of m-dimensional horizontal vectors, logsum will be of
% size [1, m].
% Two logaritmic values [v, w] = log([x, y]) and v > w can be summed as:
%     log(x + y) = v + log(1 + exp(w - v))
%
% Patrick de Kok
function logsum = logsumexp(data)
logsum = data(:, 1);
for i=2:size(data, 2)
  lnpa = logsum;
  lnpb = data(:, i);

  high = max(lnpa, lnpb);
  low = min(lnpa, lnpb);

  logsum = high + log(ones(size(lnpa)) + exp(low - high)); 
end
