function J = adaptive_median_filter_custom(I, initialWindow, maxWindow, progressCallback)
% Fast adaptive-median approximation for MATLAB R2014.
% Uses vectorized medfilt2 passes instead of nested per-pixel loops.
% This is substantially faster on normal photographs and high noise levels.
if nargin < 4, progressCallback = []; end
if mod(initialWindow,2)==0 || mod(maxWindow,2)==0 || ...
        initialWindow<3 || maxWindow<initialWindow
    error('Window sizes must be odd; maxWindow >= initialWindow >= 3.');
end
if exist('medfilt2','file') ~= 2
    error('medfilt2 was not found. Check that Image Processing Toolbox is installed.');
end

J = I;
windows = initialWindow:2:maxWindow;
nStages = length(windows);
for c = 1:size(I,3)
    A = I(:,:,c);
    % Mark impulse-valued pixels; each pass replaces only remaining extremes.
    unresolved = (A <= 0) | (A >= 1);
    B = A;
    for k = 1:nStages
        med = medfilt2(B,[windows(k) windows(k)],'symmetric');
        replaceMask = unresolved;
        B(replaceMask) = med(replaceMask);
        unresolved = (B <= 0) | (B >= 1);
        if ~isempty(progressCallback)
            progressCallback(((c-1)*nStages+k)/(size(I,3)*nStages));
        end
        drawnow;
    end
    % One final median pass handles stubborn impulses in dense-noise regions.
    if any(unresolved(:))
        med = medfilt2(B,[maxWindow maxWindow],'symmetric');
        B(unresolved) = med(unresolved);
    end
    J(:,:,c) = B;
end
J = min(max(J,0),1);
end
