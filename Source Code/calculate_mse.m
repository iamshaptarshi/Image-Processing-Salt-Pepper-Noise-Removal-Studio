function value = calculate_mse(reference, testImage)
% Mean squared error between reference and restored images.
if ~isequal(size(reference),size(testImage))
    error('Images must have identical dimensions.');
end
D = double(reference)-double(testImage);
value = mean(D(:).^2);
end
