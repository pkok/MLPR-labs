function accuracies = apply_crossvalidation(training, labels, test_A, test_B, k_max, folds)
trainingsize = size(training, 1);
foldsize = trainingsize / folds;
step = floor(foldsize);
startSplit = 0;
accuracies = [];
for i = 0:(folds-1),
  splitStart = round(startSplit);
  splitEnd = round(startSplit + foldsize);
  newtraining = training(1:splitStart,:);
  newlabels = labels(1:splitStart,:);
  validation = training((splitStart+1):(splitEnd),:);
  newtraining = [newtraining; training((splitEnd+1):trainingsize,:)];
  newlabels = [newlabels; labels((splitEnd+1):trainingsize,:)];
  accuracies = [accuracies; apply_knn(newtraining, newlabels, test_A, test_B, k_max)];
  startSplit = startSplit + foldsize;
end
