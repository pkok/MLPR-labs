function lab2()
  load(twoclass.mat)
  training = [A(1:750,:), ones(750,1)],[B(1:750,:), 2.*ones(750,1)];
  test = [A(1:250,:), ones(250,1)],[B(1:250,:), 2.*ones(250,1)];

  clearplot;
  hold on;
  plot(training(1:750,1), training(1:750,2), "@+1");
  plot(training(751:1500,1), training(751:1500,2), "@x2");
  hold off;
endfunction
