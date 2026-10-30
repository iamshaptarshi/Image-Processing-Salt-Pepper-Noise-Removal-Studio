function J = add_salt_pepper_fast(I,density)
% Fast vectorized salt-and-pepper noise for MATLAB R2014.
% density is the total fraction of corrupted pixel locations.
J = I;
[h,w,channels] = size(I);
mask = rand(h,w);
pepper = mask < density/2;
salt = mask >= density/2 & mask < density;
for c = 1:channels
    plane = J(:,:,c);
    plane(pepper) = 0;
    plane(salt) = 1;
    J(:,:,c) = plane;
end
end
