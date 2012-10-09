% Maximization step of the EM algorithm
% For every cell in MOG, it updates PI, MU and SIGMA.
function MOG = mog_M_step(X, Q, MOG)
% Given by eq. 9.18 of Bishop
N = sum(Q);

for i = 1:size(MOG, 1)
  % Given by eq. 9.17 of Bishop.
  MOG{i}.MU = 1 / N(i) * sum(repmat(Q(:, i), [1, 2]) .* X);
  % Given by eq. 9.19 of Bishop.
  centered = X - repmat(MOG{i}.MU, [size(X, 1), 1]);
  addition = 0;
  for j = 1:size(X,1)
    addition += Q(j, i) * transpose(centered(i, :)) * centered(i, :);
  end
  if cond(1 / N(i) * addition) < 10^10
    MOG{i}.SIGMA = 1 / N(i) * addition;
  end
  % Given by eq. 9.22 of Bishop.
  MOG{i}.PI = N(i) / sum(N);
end
