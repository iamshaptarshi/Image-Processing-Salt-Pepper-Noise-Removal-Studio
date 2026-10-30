function value = calculate_ssim_global(X,Y)
% Local-window SSIM estimate implemented with filter2 for MATLAB R2014.
% The function name is retained for compatibility with the main script.
% Inputs must be same size and normalized to [0,1].
X = double(X); Y = double(Y);
if ~isequal(size(X),size(Y))
    error('Images must have identical dimensions.');
end
if ndims(X) == 3
    vals = zeros(1,size(X,3));
    for c = 1:size(X,3)
        vals(c) = ssim_one_channel(X(:,:,c),Y(:,:,c));
    end
    value = mean(vals);
else
    value = ssim_one_channel(X,Y);
end
end

function value = ssim_one_channel(X,Y)
% 11-by-11 Gaussian window, sigma=1.5, as commonly used for SSIM.
windowSize = 11;
sigma = 1.5;
radius = floor(windowSize/2);
[x,y] = meshgrid(-radius:radius,-radius:radius);
window = exp(-(x.^2+y.^2)/(2*sigma^2));
window = window/sum(window(:));
muX = filter2(window,X,'same');
muY = filter2(window,Y,'same');
muX2 = muX.*muX;
muY2 = muY.*muY;
muXY = muX.*muY;
sigmaX2 = filter2(window,X.*X,'same')-muX2;
sigmaY2 = filter2(window,Y.*Y,'same')-muY2;
sigmaXY = filter2(window,X.*Y,'same')-muXY;
C1 = (0.01)^2;
C2 = (0.03)^2;
map = ((2*muXY+C1).*(2*sigmaXY+C2))./ ...
      ((muX2+muY2+C1).*(sigmaX2+sigmaY2+C2));
value = mean(map(:));
end
