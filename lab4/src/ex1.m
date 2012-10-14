function ex1()
mu = [0 0];
Sigma = [1, 0; 0, 3];
x1 = -4:.2:4
[X1,X2] = meshgrid(x1,x1);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x1),length(x1));

figure();
subplot(8,1,1:6);
contour(X1, X2, F);
colorbar();
xlabel('x1');
ylabel('x2');
caxis([0, 0.1]);

subplot(8,1,8);
plot(x1, mvnpdf(x1(:), mu(1), Sigma(1)));
xlabel('x1');
ylabel('p(x1)');
axis([-4, 4, 0, 0.5]);

mu = [0 0];
Sigma = [1, .7; .7, 3];
x1 = -4:.2:4
[X1,X2] = meshgrid(x1,x1);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x1),length(x1));

figure();
surf(x1,x1,F);
colorbar();
xlabel('x1');
ylabel('x2');
zlabel('p(x1, x2)');
axis tight;
caxis([0, 0.1]);

figure();
Lambda = inv(Sigma);

for i=1:7
    subplot(7,1,i);
    plot(x1, mvnpdf(x1(:), -inv(Lambda(1)) * Lambda(2) * (repmat(i, size(x1(:))) - x1(:)), inv(Lambda(1))));
    xlabel('x1');
    ylabel(sprintf('p(x1 | x2 = %i)', -4 + i));
    axis([-4, 4, 0, 0.5]);
end
