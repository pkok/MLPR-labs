function [mu, sigma, pC] = ex1()

[train_A, train_B] = preprocess_data(0, 0.7, 'banana.mat')

mu_A = sum(train_A) ./ size(train_A, 1)
mu_B = sum(train_B) ./ size(train_B, 1)
mu = [mu_A; mu_B]

sigma_A = cov(train_A)
sigma_B = cov(train_B)
sigma = [sigma_A; sigma_B]

pCA = mvnpdf(train_A, mu_A, sigma_A)
pCB = mvnpdf(train_B, mu_B, sigma_B)
pC = [pCA; pCB] % No, not correct! This is p(x_n | C_k)
