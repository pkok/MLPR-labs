function x = apply_knn(k_max)
[training_data,labels,test_A, test_B] = preprocess_data;

for k = 1:1:k_max,
  net = knn(2, 2, k, training_data, labels);
  [y_A, l_A] = knnfwd(net, test_A);
  [y_B, l_B] = knnfwd(net, test_B);
  confusion = transpose([histc(l_A, [1,2]), histc(l_B, [1,2])]);
  disp(k)
  disp(confusion)
end
x = 0;
