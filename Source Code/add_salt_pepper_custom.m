function J = add_salt_pepper_custom(I, density, seed)
% Adds salt-and-pepper noise. density is the total fraction of corrupted
% pixel locations; approximately half become black and half white.
% The same spatial locations are applied to every color channel.
if nargin >= 3
    rand('state', seed); %#ok<RAND>
end
J = I;
[h,w,channels] = size(I);
numPixels = h*w;
numNoisy = round(density*numPixels);
indices = randperm(numPixels);
numPepper = floor(numNoisy/2);
pepperIdx = indices(1:numPepper);
saltIdx = indices(numPepper+1:numNoisy);
for c = 1:channels
    plane = J(:,:,c);
    plane(pepperIdx) = 0;
    plane(saltIdx) = 1;
    J(:,:,c) = plane;
end
end
