function [training, labels, test_A, test_B] = preprocess_data()
load("twoclass.mat");
training = [A(1:750,:); B(1:750,:)];
labels = [ones(750,1), zeros(750,1); zeros(750,1), ones(750,1)];
test_A = A(751:1000,:);
test_B = B(751:1000,:);

clf;
hold on;
plot(training(1:750,1), training(1:750,2), "@+1");
plot(training(751:1500,1), training(751:1500,2), "@x3");
plot(test_A(:,1), test_A(:,2), "@o4");
plot(test_B(:,1), test_B(:,2), "@*0");
hold off;
