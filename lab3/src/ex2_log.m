% Computes the required results for the second exercise of lab assignment 3 for
% the 2012 MSc AI course Machine Learning: Pattern Recognition.
% When passed the optional parameter random_seed, the random generator for
% shuffling the dataset is set. If not, Octave/Matlab will determine the seed.
function [confusion_matrices, error_rates] = ex2(dataset, max_C, random_seed)

if nargin < 3
  random_seed = 0;
end

if random_seed ~= 0
  % Setting the seed for the random generator.
  rand('seed', random_seed);
end

[train_A, train_B, test_A, test_B] = preprocess_data(1, 0.7, dataset);
test = [test_A; test_B];
test_labels = [ones(size(test_A, 1), 1), zeros(size(test_A, 1), 1); zeros(size(test_B, 1), 1), ones(size(test_B, 1), 1)];

confusion_matrices = cell(max_C, 1);
error_rates = zeros(max_C, 1);

for j=1:max_C
  [LLA, MOG_A] = em_mog_log(train_A, j, 0);
  [LLB, MOG_B] = em_mog_log(train_B, j, 0);

  pAC = 0;
  pBC = 0;
  for i=1:size(MOG_A)
    pAC = pAC + MOG_A{i}.PI * exp(lmvnpdf(test, MOG_A{i}.MU, MOG_A{i}.SIGMA));
    pBC = pBC + MOG_B{i}.PI * exp(lmvnpdf(test, MOG_B{i}.MU, MOG_B{i}.SIGMA));
  end

  pCA = pAC .* (size(train_A, 1) / (size(train_A, 1) + size(train_B, 1)));
  pCB = pBC .* (size(train_B, 1) / (size(train_A, 1) + size(train_B, 1)));

  true_A = sum(((pCA > pCB) == test_labels(:, 1)) .* test_labels(:, 1));
  true_B = sum(((pCA <= pCB) == test_labels(:, 2)) .* test_labels(:, 2));
  false_A = size(test_B, 1) - true_B;
  false_B = size(test_A, 1) - true_A;

  confusion_matrices{j} = [true_A, false_A; false_B, true_B];
  error_rates(j) = 1 - ((true_A + true_B) / size(test, 1));
end

figure();
plot(error_rates);
