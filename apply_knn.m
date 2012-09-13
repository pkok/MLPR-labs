function accuracies = apply_knn(training, labels, test_A, test_B, k_max)
min_k = min(k_max);
accuracies = [];
for k = k_max,
  net = knn(2, 2, k, training, labels);
  [y_A, l_A] = knnfwd(net, test_A);
  [y_B, l_B] = knnfwd(net, test_B);
  class_A = histc(l_A, [1,2]);
  class_B = histc(l_B, [1,2]);
  accuracies = [accuracies, (class_A(1,1) + class_B(2,1)) / (size(test_A, 1) + size(test_B, 1))];
end
