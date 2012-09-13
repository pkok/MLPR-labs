function accuracies = runme()
option = menu('Choose what you want to do', 'p% split, with data in order', 'p% split, with data shuffled', 'n-fold cross-validation, with p% test set and data in order', 'n-fold cross-validation, with p% test set and data shuffled');

k = input('Which value of k do you want to use? ');
p = input('Which percentage of your data do you want to train on? [0-1> ');
[training_data, training_labels, test_A, test_B] = preprocess_data(mod(option - 1, 2), p);

if (option <= 2),
  accuracies = apply_knn(training_data, training_labels, test_A, test_B, 1:2:k);
elseif (option > 2),
  n = input('How many folds? {1, 2, ...} ');
  accuracies = apply_crossvalidation(training_data, training_labels, test_A, test_B, 1:2:k, n);
end
