function confusion_matrices = apply_knn(training, labels, test_A, test_B, k_max)
min_k = min(k_max)
confusion_matrices = cell(size(k_max)(2))

for k = k_max,
  net = knn(2, 2, k, training, labels);
  [y_A, l_A] = knnfwd(net, test_A);
  [y_B, l_B] = knnfwd(net, test_B);
  confusion_matrices(k - min_k + 1) = transpose([histc(l_A, [1,2]), histc(l_B, [1,2])]);
end
