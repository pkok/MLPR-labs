% Logaritmic sum of elements along the first dimension of data.
% For data of n rows of m-dimensional horizontal vectors, result will be of
% size [1, m].
5
% Two logaritmic values [v, w] = log([x, y]) and v > w can be summed as:
%     log(x + y) = v + log(1 + exp(w - v))
function result = logsumexp(data)
if size(data, 1) == 1
  data = transpose(data);
end

result = data(1,:);

many_ones = ones(1, size(data, 2));

for i=2:size(data, 1)
  high = max(result, data(i, :));
  low = min(result, data(i, :));
  result = high + log(many_ones + exp(low - high));
end
