function ex2(random_seed)

if nargin < 1
  random_seed = 0;
end

if random_seed ~= 0
  % Setting the seed for the random generator.
  rand('seed', random_seed);
end

load('chirps.mat');

chirps = chirps(randperm(size(chirps, 1)), :);
train = chirps(1:12, :);
test = chirps(13:15, :);

figure()
hold on;

xlabel('Frequency of cricket chirps (Herz)');
ylabel('Ambient temperature (degrees Fahrenheit)');
plot(train(:, 1), train(:, 2), 'r+');
plot(test(:, 1), test(:, 2), 'bx');

k = squared_exponential(0.5, 0.5);
for i=1:size(test, 1)
  label = gaussian_process(train(:, 1), train(:, 2), k, 1e-7, test(i, 1));
  plot(test(i, 1), label, 'mo');
end

hold off;
