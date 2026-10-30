function J = mean_filter_custom(I, windowSize)
% Mean filter using convolution and symmetric boundary padding.
if mod(windowSize,2) == 0
    error('windowSize must be odd.');
end
pad = floor(windowSize/2);
kernel = ones(windowSize,windowSize)/(windowSize^2);
J = zeros(size(I));
for c = 1:size(I,3)
    A = I(:,:,c);
    P = padarray(A,[pad pad],'symmetric');
    J(:,:,c) = conv2(P,kernel,'valid');
end
J = min(max(J,0),1);
end
