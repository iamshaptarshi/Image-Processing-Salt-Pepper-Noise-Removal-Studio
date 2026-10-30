function J = gaussian_filter_custom(I, windowSize, sigma)
% Gaussian smoothing using a normalized Gaussian kernel and symmetric padding.
if mod(windowSize,2) == 0
    error('windowSize must be odd.');
end
radius = floor(windowSize/2);
[x,y] = meshgrid(-radius:radius,-radius:radius);
kernel = exp(-(x.^2+y.^2)/(2*sigma^2));
kernel = kernel/sum(kernel(:));
J = zeros(size(I));
for c = 1:size(I,3)
    A = I(:,:,c);
    P = padarray(A,[radius radius],'symmetric');
    J(:,:,c) = conv2(P,kernel,'valid');
end
J = min(max(J,0),1);
end
