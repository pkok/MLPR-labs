function performance = ex2(random_seed)

if nargin ~= 1
  random_seed = 0;
end

if random_seed ~= 0
  % Setting the seed for the random generator.
  rand('seed', random_seed);
end

poolSize = matlabpool('size');
if poolSize == 0
  matlabpool open;
end

load('chirps.mat');

% Shuffle the dataset
chirps = chirps(randperm(size(chirps, 1)), :);

% Because the dataset is small, use only 1 test sample.
train = chirps(1:end-1, :);
test = chirps(end, :);

N = size(train, 1);

figure()
hold on;

xlabel('Frequency of cricket chirps (Herz)');
ylabel('Ambient temperature (degrees Fahrenheit)');
plot(train(:, 1), train(:, 2), 'r+');
plot(test(:, 1), test(:, 2), 'bx');

avg_ell = (max(train(:, 1)) - min(train(:, 1))) / N;
avg_theta = (max(train(:, 2)) - min(train(:, 2))) / N;

%d_ell = avg_ell / 10;
%d_theta = avg_theta / 10;
%
%min_ell = d_ell;
%min_theta = d_theta;
%
%max_ell = avg_ell * 100;
%max_theta = avg_theta * 100;

d_ell = avg_ell / 100;
d_theta = avg_theta;

min_ell = d_ell;
min_theta = 100 * avg_theta;

max_ell = avg_ell / 10;
max_theta = avg_theta * 500;

disp(sprintf('min,avg,max L: %f   %f   %f', min_ell, avg_ell, max_ell));
disp(sprintf('min,avg,max þ: %f   %f   %f', min_theta, avg_theta, max_theta));

% We are going to apply N-fold cross validation to find the best regressor.
max_LLog = -Inf * ones(N, 1);
max_hyperparameters = zeros(N, 2);

% Last column contains the validation 'set' of 1 item.
train_fold = zeros(N, N);
label_fold = zeros(N, N);
for i=1:N
  train_fold(:, i) = circshift(train(:, 1), i);
  label_fold(:, i) = circshift(train(:, 2), i);
end

sigma2 = 1e-7;

ell_inspect_range = [min_ell:d_ell:max_ell];%[min_ell:d_ell:avg_ell, (2*avg_ell):avg_ell:max_ell];
theta_inspect_range = [min_theta:d_theta:max_theta];%[min_theta:d_theta:avg_theta, (2*avg_theta):avg_theta:max_theta];
for ell=ell_inspect_range
  for theta=theta_inspect_range
    sprintf('th: %f\nel: %f', theta, ell);
    k = squared_exponential(theta, ell);
    parfor i=1:N
      [~, ~, llog] = gaussian_process(train_fold(i, 1:end-1), label_fold(:, 1:end-1), k, sigma2, train_fold(i, end));
      if llog > max_LLog(i)
        max_LLog(i) = llog(1);
        max_ell(i) = ell;
        max_theta(i) = theta;
      end
    end
  end
end

% Select the fold with the highest log-likelihood (so it explains the data best)
best_index = find(max_LLog == max(max_LLog))
% if there are multiple indices, return only the first (arbitrary decision, I know!)
if max(size(best_index)) ~= 1
  best_index = best_index(1, 1);
end

ell = max_ell(best_index);
theta = max_theta(best_index);

disp('ell');
disp(ell);
disp('theta');
disp(theta);
disp(max_LLog);
disp([max_ell;max_theta]);

k = squared_exponential(theta, ell);
performance = 0;
for i=1:size(test, 1)
  [prediction, sigma_2, ~] = gaussian_process(train(:, 1), train(:, 2), k, sigma2, test(i, 1));
  performance = performance + (prediction - test(i, 2)) * (prediction - test(i, 2));
  plot(test(i, 1), prediction, 'mo');
  %line([test(i, 1), test(i, 1)], [prediction - sigma_2, prediction + sigma_2], 'Color', 'm');
end

hold off;
