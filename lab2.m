function [training,test]=lab2()
  load("twoclass.mat");
  training = [[A(1:750,:), ones(750,1)]; [B(1:750,:), 2.*ones(750,1)]];
  test = [[A(751:1000,:), ones(250,1)]; [B(751:1000,:), 2.*ones(250,1)]];

  clf;
  hold on;
  plot(training(1:750,1), training(1:750,2), "@+1");
  plot(training(751:1500,1), training(751:1500,2), "@x3");
  plot(test(1:250,1), test(1:250,2), "@o4");
  plot(test(251:500,1), test(251:500,2), "@*0");
  hold off;
end
