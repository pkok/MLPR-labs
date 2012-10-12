% k = squared_exponential(theta, ell)
%
% Generate a kernal function, as specified in eq. 9 of the assignment:
%     k(x, x_) = theta exp(-1/(2*ell)) * (x - x_)' * (x - x_)
% Parameters are:
%   theta : scaling parameter
%   ell   : the lengthscale, which reflects how close together inputs must be
%           to result in a given covariance of the outputs.
% Returns:
%   k     : The kernel function
%
% Patrick de Kok
function k = squared_exponential(theta, ell)
k = @(x, x_) (theta * exp(-1 / (2 * ell)) * (x - x_)' * (x - x_);
