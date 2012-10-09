% Computes the required results for the first exercise of lab assignment 3 for
% the 2012 MSc AI course Machine Learning: Pattern Recognition.
% When passed the optional parameter random_seed, the random generator for
% shuffling the dataset is set. If not, Octave/Matlab will determine the seed.
function [confusion_matrix, error_rate] = ex1(random_seed)

if nargin < 1
  random_seed = -1;
end

if random_seed > 0
  % Setting the seed for the random generator.
  rand("seed", random_seed);
end

[train_A, train_B, test_A, test_B] = preprocess_data(1, 0.7, 'banana.mat');
test = [test_A; test_B];
test_labels = [ones(size(test_A, 1), 1), zeros(size(test_A, 1), 1); zeros(size(test_B, 1), 1), ones(size(test_B, 1), 1)];

figure();
hold on;
plot(train_A(:, 1), train_A(:, 2), '@+1');
plot(train_B(:, 1), train_B(:, 2), '@x3');
hold off;

mu_A = sum(train_A) ./ size(train_A, 1);
mu_B = sum(train_B) ./ size(train_B, 1);
mu = [mu_A; mu_B];

sigma_A = cov(train_A);
sigma_B = cov(train_B);
sigma = [sigma_A; sigma_B];

pCA = mvnpdf(test, mu_A, sigma_A) .* (size(train_A, 1) / (size(train_A, 1) + size(train_B, 1)));
pCB = mvnpdf(test, mu_B, sigma_B) .* (size(train_B, 1) / (size(train_A, 1) + size(train_B, 1)));
pCx = [pCA; pCB];

true_A = sum(((pCA > pCB) == test_labels(:, 1)) .* test_labels(:, 1));
true_B = sum(((pCA <= pCB) == test_labels(:, 2)) .* test_labels(:, 2));
false_A = size(test_B, 1) - true_B;
false_B = size(test_A, 1) - true_A;

confusion_matrix = [true_A, false_A; false_B, true_B];
error_rate = 1 - ((true_A + true_B) / size(test, 1));
