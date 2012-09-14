function [training_data, training_labels, test_A, test_B] = preprocess_data(randomize, splitpercentage)
load('twoclass.mat');
sizeA = size(A, 1);
sizeB = size(B, 1);

if (randomize > 0),
  A = A(randperm(sizeA), :);
  B = B(randperm(sizeB), :);
end

splitA = floor(sizeA * splitpercentage);
splitB = floor(sizeB * splitpercentage);
dataperm = randperm(splitA + splitB);
training_data = [A(1:splitA,:); B(1:splitB,:)];
training_labels = [ones(splitA,1), zeros(splitA,1); zeros(splitB,1), ones(splitB,1)];
% Reshuffle the samples; do not cluster type A near itself.
training_data = training_data(dataperm, :);
training_labels = training_labels(dataperm, :);
test_A = A((splitA+1):sizeA,:);
test_B = B((splitB+1):sizeB,:);
