% [train_A, train_B, test_A, test_B] = preprocess_data(randomize, splitpercentage, filename)
%
% Read file with filename, shuffles the data and splits it in a train and test set.
% Parameters are:
%   randomize       : Whether the data set should be shuffled before
%                     splitting. If randomize == 0, do not shuffle. If
%                     randomize > 0, set the seed with this value. Otherwise,
%                     use the default seed and shuffle the data.
%   splitpercentage : The amount of data that should be part of the train data
%                     set. 
%   filename        : A string representing a MAT file on disk. The file
%                     should contain variables A and B.
% Returns:
%   train_A         : splitpercentage part of the data of class A. Meant to be
%                     used for training a learning algorithm.
%   train_B         : splitpercentage part of the data of class B. Meant to be
%                     used for training a learning algorithm.
%   test_A          : (1 - splitpercentage) part of the data of class A. Meant
%                     to be used for testing/validating a learning algorithm.
%   test_B          : (1 - splitpercentage) part of the data of class B. Meant
%                     to be used for testing/validating a learning algorithm.
%
% Recycled and slightly edited from the first assignment.
%
% Patrick de Kok
function [train_A, train_B, test_A, test_B] = preprocess_data(randomize, splitpercentage, filename)

load(filename);
sizeA = size(A, 1);
sizeB = size(B, 1);

if (randomize ~= 0)
  if (randomize > 0)
    rand('seed', randomize);
  A = A(randperm(sizeA), :);
  B = B(randperm(sizeB), :);
end

splitA = floor(sizeA * splitpercentage);
splitB = floor(sizeB * splitpercentage);
% Reshuffle the samples; do not cluster type A near itself.
train_A = A(1:splitA, :);
train_B = B(1:splitB, :);
test_A = A((splitA+1):sizeA,:);
test_B = B((splitB+1):sizeB,:);
