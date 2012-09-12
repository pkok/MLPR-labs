function step = apply_crossvalidation(training, labels, test_A, test_B, k_max, folds)
trainingsize = size(training, 1);
foldsize = trainingsize / folds;
disp(foldsize)
step = floor(foldsize);
startSplit = 0;
for i = 0:(folds-1),
  splitStart = round(startSplit);
  splitEnd = round(startSplit + foldsize);
  newtraining = training(1:splitStart,:);
  newlabels = labels(1:splitStart,:);
  validation = training((splitStart+1):(splitEnd),:);
  newtraining = [newtraining; training((splitEnd+1):trainingsize,:)];
  newlabels = [newlabels; labels((splitEnd+1):trainingsize,:)];
  %apply_knn(newtraining, newlabels, test_A, test_B, k_max);
  %disp(sprintf('%2d: %4d - %4d    %4d', i, splitStart, splitEnd, (splitEnd-splitStart)));
  disp(sprintf('%2d: %4d + %4d = %4d; %1d', i, size(validation, 1), size(newtraining, 1), size(validation, 1) + size(newtraining, 1), size(newtraining, 1) == size(newlabels, 1)));
  startSplit = startSplit + foldsize;
end
