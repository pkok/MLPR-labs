function ex1()
mu = [0 0];
Sigma = [1, 0; 0, 3];
x1 = -4:.2:4
[X1,X2] = meshgrid(x1,x1);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x1),length(x1));

figure();
subplot(4,1,1:3);
contour(X1, X2, F);
colorbar();

subplot(4,1,4);
plot(x1, mvnpdf(x1(:), mu(1), Sigma(1)));

mu = [0 0];
Sigma = [1, .7; .7, 3];
x1 = -4:.2:4
[X1,X2] = meshgrid(x1,x1);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x1),length(x1));

figure();
surf(x1,x1,F);
colorbar();

figure();
Lambda = inv(Sigma);

for i=1:7
    subplot(7,1,i);
    plot(x1, mvnpdf(x1(:), -inv(Lambda(1)) * Lambda(2) * (repmat(i, size(x1(:))) - x1(:)), inv(Lambda(1))));
end
