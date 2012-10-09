function [confusion_matrix, error_rate] = ex1()

[train_A, train_B, test_A, test_B] = preprocess_data(0, 0.7, 'banana.mat');
test = [test_A; test_B]
test_labels = [ones(size(test_A, 1)), zeros(size(test_A, 1)); zeros(size(test_B, 1)), ones(size(test_B, 1))]

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

true_A = 0;
false_A = 0;
true_B = 0;
false_B = 0;

for i=1:size(test,1),
  if pCA(i) > pCB(i)
    if test_labels(i, 1) == 1
      true_A += 1;
    else
      false_A += 1;
  else
    if test_labels(i, 2) == 1
      true_B += 1;
    else
      false_B += 1;
    end
  end
end

confusion_matrix = [true_A, false_A; false_B, true_B]
error_rate = 1 - ((true_A + true_B) / size(test, 1))
