function [train_A, train_B, test_A, test_B] = preprocess_data(randomize, splitpercentage, filename)

load(filename);
sizeA = size(A, 1);
sizeB = size(B, 1);

if (randomize > 0),
  A = A(randperm(sizeA), :);
  B = B(randperm(sizeB), :);
end

splitA = floor(sizeA * splitpercentage);
splitB = floor(sizeB * splitpercentage);
% Reshuffle the samples; do not cluster type A near itself.
train_A = A(1:splitA, :)
train_B = B(1:splitB, :)
test_A = A((splitA+1):sizeA,:);
test_B = B((splitB+1):sizeB,:);
