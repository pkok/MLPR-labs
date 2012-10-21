function performance = ex2s7t2(random_seed)

if nargin ~= 1
  random_seed = 0;
end

if random_seed ~= 0
  % Setting the seed for the random generator.
  rand('seed', random_seed);
end

load('chirps.mat');

% Shuffle the dataset
chirps = chirps(randperm(size(chirps, 1)), :);

% Because the dataset is small, use only 1 test sample.
train = chirps(1:end-3, :);
test = chirps(end-2:end, :);

N = size(train, 1);

figure()
hold on;

xlabel('Frequency of cricket chirps (Hertz)');
ylabel('Ambient temperature (degrees Fahrenheit)');
plot(train(:, 1), train(:, 2), 'r+', test(:, 1), test(:, 2), 'bx');
%legend('Train instance', 'Test instance'); 

avg_ell = (max(train(:, 1)) - min(train(:, 1))) / N;
avg_theta = (max(train(:, 2)) - min(train(:, 2))) / N;

d_ell = avg_ell / 10;
d_theta = avg_theta / 10;

min_ell = d_ell;
min_theta = d_theta;

max_ell = avg_ell * 100;
max_theta = avg_theta * 100;

disp(sprintf('min,avg,max L: %f   %f   %f', min_ell, avg_ell, max_ell));
disp(sprintf('min,avg,max Theta: %f   %f   %f', min_theta, avg_theta, max_theta));

% We are going to apply N-fold cross validation to find the best regressor.
% Last column contains the validation 'set' of 1 item.
train_fold = zeros(N, N);
label_fold = zeros(N, N);
for i=1:N
  train_fold(:, i) = circshift(train(:, 1), i);
  label_fold(:, i) = circshift(train(:, 2), i);
end

cross_validate_fold = train_fold(:, end);
cross_label_fold = label_fold(:, end);
train_fold = train_fold(1:end-1, :);
label_fold = label_fold(1:end-1, :);

sigma2 = 1e-7;

ell_inspect_range = [min_ell:d_ell:avg_ell, (2*avg_ell):avg_ell:max_ell];%[min_ell:d_ell:max_ell];
theta_inspect_range = [min_theta:d_theta:avg_theta, (2*avg_theta):avg_theta:max_theta];%[min_theta:d_theta:max_theta];
%ell_inspect_range = [min_ell:d_ell:max_ell];
%theta_inspect_range = [min_theta:d_theta:max_theta];

llog_overview = zeros(size(ell_inspect_range, 2), size(theta_inspect_range, 2), N);
err_overview = zeros(size(ell_inspect_range, 2), size(theta_inspect_range, 2), N);
var_overview = zeros(size(ell_inspect_range, 2), size(theta_inspect_range, 2), N);

poolSize = matlabpool('size');
if poolSize == 0
  matlabpool open;
end

disp('Starting to loop!');
for iter_ell=1:size(ell_inspect_range,2)
  tic;
  if iter_ell <= 10
    this_ell = iter_ell*d_theta;
  else
    this_ell = (iter_ell-10)*avg_theta;
  end
  for iter_theta=1:size(theta_inspect_range,2)
    if iter_theta <= 10
      k = squared_exponential(iter_theta*d_theta, this_ell);
    else
      k = squared_exponential((iter_theta-10)*avg_theta, iter_ell*d_ell);
    end
    parfor i=1:N
      [f_, sigma_2, llog] = gaussian_process(train_fold(:, i), label_fold(:, i), k, sigma2, cross_validate_fold(i));
      llog_overview(iter_ell, iter_theta, i) = llog;
      err_overview(iter_ell, iter_theta, i) = (f_ - cross_label_fold(i)) * (f_ - cross_label_fold(i));
      var_overview(iter_ell, iter_theta, i) = sigma_2;
    end
  end
end

save('overview2.mat', 'ell_inspect_range', 'theta_inspect_range', 'llog_overview', 'err_overview', 'var_overview');
%load('overview.mat');

llog_data = zeros(size(ell_inspect_range, 2), size(theta_inspect_range, 2));
error_data = zeros(size(ell_inspect_range, 2), size(theta_inspect_range, 2));
var_data = zeros(size(ell_inspect_range, 2), size(theta_inspect_range, 2));

for i=1:size(ell_inspect_range, 2)
  for j=1:size(theta_inspect_range, 2)
    llog_data(i, j) = mean(llog_overview(i, j, :));
    error_data(i, j) = mean(err_overview(i, j, :));
    var_data(i, j) = mean(var_overview(i, j, :));
  end
end

% Find the highest log-likelihood among the different values of theta and l.
best_pair = find(llog_data == max(max(llog_data)));
% if there are multiple indices, return only the first (arbitrary decision, I know!)
ell_index = floor(best_pair / size(ell_inspect_range, 2));
theta_index = mod(best_pair, size(ell_inspect_range, 2));
disp(sprintf('Max. log-likelihood: %f', max(max(llog_data))));
disp(sprintf('best <theta,l> pair based on loglikelihood:'));
disp([ell_index , theta_index]);
if max(size(best_pair)) ~= 1
  best_pair = best_pair(1, 1);
end

ell = ell_inspect_range(ell_index);
theta = theta_inspect_range(theta_index);
%data = [train(1:(best_index-1), :); train((best_index+1):end, :)]

% Do the same with least error
best_pair = find(error_data == min(min(error_data)));
ell_index = floor(best_pair / size(ell_inspect_range, 2));
theta_index = mod(best_pair, size(ell_inspect_range, 2));
disp(sprintf('Min. mean squared error: %f', min(min(error_data))));
disp(sprintf('best <theta,l> pair based on error:'));
disp([ell_index , theta_index]);
if max(size(best_pair)) ~= 1
  best_pair = best_pair(1, 1);
end
ell_err = ell_inspect_range(ell_index);
theta_err = theta_inspect_range(theta_index);

% Do the same with max. variance
best_pair = find(var_data == max(max(var_data)));
ell_index = floor(best_pair / size(ell_inspect_range, 2));
theta_index = mod(best_pair, size(ell_inspect_range, 2));
disp(sprintf('Max. variance: %f', max(max(var_data))));
disp(sprintf('best <theta,l> pair based on variance:'));
disp([ell_index , theta_index]);
if max(size(best_pair)) ~= 1
  best_pair = best_pair(1, 1);
end
ell_var = ell_inspect_range(ell_index);
theta_var = theta_inspect_range(theta_index);



means = zeros(100,1);
vars = zeros(100,1);

%k = squared_exponential(avg_theta, avg_ell);
%for i=1:100
%  f_ = 0;
%  sigma_2 = 0;
%  for j=1:N
%    [f__, s, ~] = gaussian_process(train_fold(:, j), label_fold(:, j), k, sigma2, (i*0.1) + 12);
%    f_ = f_ + f__;
%    sigma_2 = sigma_2 + s;
%  end
%  means(i) = f_ / N;
%  vars(i) = sqrt(sigma_2 / N);
%end
%plot(12+(0.1*(1:100)), means);
%plot(12+(0.1*(1:100)), means+(vars));
%plot(12+(0.1*(1:100)), means-(vars));


k = squared_exponential(theta, ell);
for i=1:100
  f_ = 0;
  sigma_2 = 0;
  for j=1:N
    [f__, s, ~] = gaussian_process(train_fold(:, j), label_fold(:, j), k, sigma2, (i*0.1) + 12);
    f_ = f_ + f__;
    sigma_2 = sigma_2 + s;
  end
  means(i) = f_ / N;
  vars(i) = sqrt(sigma_2 / N);
end
plot(12+(0.1*(1:100)), means, 'r');
plot(12+(0.1*(1:100)), means+(vars), 'r');
plot(12+(0.1*(1:100)), means-(vars), 'r');

performance = 0;
for i=1:size(test, 1)
  f_ = 0;
  sigma_2 = 0;
  for j=1:N
    [f__, s, ~] = gaussian_process(train_fold(:, i), label_fold(:, i), k, sigma2, test(i, 1));
    f_ = f_ + f__;
    sigma_2 = sigma_2 + s;
  end
  f_ = f_ / N;
  sigma_2 = sigma_2 / N;
  %plot(test(i, 1), f_, 'mo');
  performance = performance + f_;
end
performance = performance / size(test, 1)
disp(sprintf('Performance based on llog: %f', performance));

k = squared_exponential(theta_err, ell_err);
for i=1:100
  f_ = 0;
  sigma_2 = 0;
  for j=1:N
    [f__, s, ~] = gaussian_process(train_fold(:, j), label_fold(:, j), k, sigma2, (i*0.1) + 12);
    f_ = f_ + f__;
    sigma_2 = sigma_2 + s;
  end
  means(i) = f_ / N;
  vars(i) = sqrt(sigma_2 / N);
end
plot(12+(0.1*(1:100)), means, 'b');
plot(12+(0.1*(1:100)), means+(vars), 'b');
plot(12+(0.1*(1:100)), means-(vars), 'b');

pperformance = 0;
for i=1:size(test, 1)
  f_ = 0;
  sigma_2 = 0;
  for j=1:N
    [f__, s, ~] = gaussian_process(train_fold(:, i), label_fold(:, i), k, sigma2, test(i, 1));
    f_ = f_ + f__;
    sigma_2 = sigma_2 + s;
  end
  f_ = f_ / N;
  sigma_2 = sigma_2 / N;
  %plot(test(i, 1), f_, 'mo');
  pperformance = pperformance + f_;
end
pperformance = pperformance / size(test, 1)
disp(sprintf('Performance based on error: %f', pperformance));

k = squared_exponential(theta_var, ell_var);
for i=1:100
  f_ = 0;
  sigma_2 = 0;
  for j=1:N
    [f__, s, ~] = gaussian_process(train_fold(:, j), label_fold(:, j), k, sigma2, (i*0.1) + 12);
    f_ = f_ + f__;
    sigma_2 = sigma_2 + s;
  end
  means(i) = f_ / N;
  vars(i) = sqrt(sigma_2 / N);
end
plot(12+(0.1*(1:100)), means, 'g');
plot(12+(0.1*(1:100)), means+(vars), 'g');
plot(12+(0.1*(1:100)), means-(vars), 'g');

pperformance = 0;
for i=1:size(test, 1)
  f_ = 0;
  sigma_2 = 0;
  for j=1:N
    [f__, s, ~] = gaussian_process(train_fold(:, i), label_fold(:, i), k, sigma2, test(i, 1));
    f_ = f_ + f__;
    sigma_2 = sigma_2 + s;
  end
  f_ = f_ / N;
  sigma_2 = sigma_2 / N;
  %plot(test(i, 1), f_, 'mo');
  pperformance = pperformance + f_;
end
pperformance = pperformance / size(test, 1)
disp(sprintf('Performance based on variance: %f', pperformance));


hold off;
%
%figure();
%surf(ell_inspect_range(1:10), theta_inspect_range(1:10), llog_data(1:10,1:10));
%xlabel('l');
%ylabel('theta');
%zlabel('Log-likelihood of the data (log p(X | theta, l))');
%figure();
%surf(ell_inspect_range(1:10), theta_inspect_range(1:10), error_data(1:10,1:10));
%xlabel('l');
%ylabel('theta');
%zlabel('Mean squared error');
%figure();
%surf(ell_inspect_range(1:10), theta_inspect_range(1:10), var_data(1:10,1:10));
%xlabel('l');
%ylabel('theta');
%zlabel('Squared variance (sigma^2)');

