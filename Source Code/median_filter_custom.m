function J = median_filter_custom(I, windowSize, progressCallback)
% Custom median filter; optional progress callback receives [0,1].
if nargin < 3, progressCallback = []; end
if mod(windowSize,2)==0, error('windowSize must be odd.'); end
pad=floor(windowSize/2); J=zeros(size(I));
totalRows=size(I,1)*size(I,3); done=0;
for c=1:size(I,3)
    A=I(:,:,c); P=padarray(A,[pad pad],'symmetric'); B=zeros(size(A));
    for r=1:size(A,1)
        for col=1:size(A,2)
            block=P(r:r+windowSize-1,col:col+windowSize-1);
            values=sort(block(:));
            B(r,col)=values(ceil(length(values)/2));
        end
        done=done+1;
        if ~isempty(progressCallback) && (mod(r,5)==0 || r==size(A,1))
            progressCallback(done/totalRows);
        end
    end
    J(:,:,c)=B;
end
end
