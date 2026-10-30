function main_project7()
% PROJECT 7: Salt-and-Pepper Noise Removal Challenge
% Compatible with MATLAB R2014 + Image Processing Toolbox.
% Run this function from the folder containing all project files.

clc; close all;
fprintf('PROJECT 7: Salt-and-Pepper Noise Removal Challenge\n');

[filename, pathname] = uigetfile( ...
    {'*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff', 'Supported images'}, ...
    'Select a clean reference image');
if isequal(filename,0)
    fprintf('No image selected. Exiting.\n');
    return;
end

I = imread(fullfile(pathname, filename));
if ndims(I) == 3
    if size(I,3) > 3
        I = I(:,:,1:3);
    end
end
I = im2double(I);
if max(I(:)) > 1
    I = I ./ 255;
end

% Experimental settings. Keep the same noisy image for all filters.
noiseLevels = [0.05 0.10 0.20 0.30 0.40 0.50];
methods = {'Mean','Median','Gaussian','AdaptiveMedian'};
results = cell(length(noiseLevels)*length(methods), 6);
resultRow = 0;

outDir = fullfile(pwd, 'Project7_Results');
if ~exist(outDir,'dir'), mkdir(outDir); end

for ni = 1:length(noiseLevels)
    density = noiseLevels(ni);
    noisy = add_salt_pepper_custom(I, density, 1000 + ni);
    imwrite(noisy, fullfile(outDir, sprintf('noisy_%02d_percent.png', round(100*density))));

    figure('Name',sprintf('Noise density %d%%',round(100*density)), ...
        'NumberTitle','off');
    subplot(2,3,1); imshow(I); title('Original');
    subplot(2,3,2); imshow(noisy);
    title(sprintf('Noisy: %d%%',round(100*density)));

    for mi = 1:length(methods)
        tic;
        switch methods{mi}
            case 'Mean'
                restored = mean_filter_custom(noisy, 3);
            case 'Median'
                restored = median_filter_custom(noisy, 3);
            case 'Gaussian'
                restored = gaussian_filter_custom(noisy, 3, 0.8);
            case 'AdaptiveMedian'
                restored = adaptive_median_filter_custom(noisy, 3, 7);
        end
        elapsed = toc;

        mseValue = calculate_mse(I, restored);
        psnrValue = calculate_psnr(mseValue);
        ssimValue = calculate_ssim_global(I, restored);

        resultRow = resultRow + 1;
        results(resultRow,:) = {round(100*density), methods{mi}, ...
            mseValue, psnrValue, ssimValue, elapsed};

        imwrite(restored, fullfile(outDir, sprintf('%s_%02d_percent.png', ...
            methods{mi}, round(100*density))));

        % Show all four restorations in a second figure per density.
        figure(findobj('Type','figure','Name',sprintf('Noise density %d%%',round(100*density))));
        subplot(2,3,mi+2); imshow(restored);
        title(sprintf('%s | PSNR %.2f dB', methods{mi}, psnrValue));
    end
end

% Export results table to CSV using MATLAB R2014-compatible file I/O.
csvPath = fullfile(outDir, 'quality_metrics.csv');
fid = fopen(csvPath,'w');
fprintf(fid,'NoiseDensityPercent,Filter,MSE,PSNR_dB,SSIM_Global,TimeSeconds\n');
for r = 1:size(results,1)
    fprintf(fid,'%d,%s,%.10f,%.6f,%.6f,%.6f\n', ...
        results{r,1}, results{r,2}, results{r,3}, ...
        results{r,4}, results{r,5}, results{r,6});
end
fclose(fid);

% Plot PSNR versus noise density for each method.
figure('Name','PSNR Comparison','NumberTitle','off');
hold on;
for mi = 1:length(methods)
    x = noiseLevels*100;
    y = zeros(size(noiseLevels));
    for ni = 1:length(noiseLevels)
        row = (ni-1)*length(methods)+mi;
        y(ni) = results{row,4};
    end
    plot(x,y,'-o','LineWidth',1.5);
end
xlabel('Salt-and-pepper noise density (%)');
ylabel('PSNR (dB)');
title('Filter Performance: PSNR vs Noise Density');
legend(methods,'Location','best'); grid on; hold off;
saveas(gcf, fullfile(outDir,'psnr_comparison.png'));

% Plot SSIM comparison.
figure('Name','SSIM Comparison','NumberTitle','off');
hold on;
for mi = 1:length(methods)
    x = noiseLevels*100;
    y = zeros(size(noiseLevels));
    for ni = 1:length(noiseLevels)
        row = (ni-1)*length(methods)+mi;
        y(ni) = results{row,5};
    end
    plot(x,y,'-o','LineWidth',1.5);
end
xlabel('Salt-and-pepper noise density (%)');
ylabel('Global SSIM estimate');
title('Filter Performance: SSIM vs Noise Density');
legend(methods,'Location','best'); grid on; hold off;
saveas(gcf, fullfile(outDir,'ssim_comparison.png'));

fprintf('\nFinished. Results saved in:\n%s\n', outDir);
fprintf('Review quality_metrics.csv and saved images before writing conclusions.\n');
end
