function [training_data, training_labels, test_data, test_labels] = preprocess_data()
load('twoclass.mat');
training_data = [A(1:750,:); B(1:750,:)];
training_labels = [ones(750,1), zeros(750,1); zeros(750,1), ones(750,1)];
test_data = [A(751:1000,:); B(751:1000,:)];
test_labels = [ones(250,1), zeros(250,1); zeros(250,1), ones(250,1)];
