function value = calculate_psnr(mseValue)
% PSNR for images normalized to [0,1].
if mseValue == 0
    value = Inf;
else
    value = 10*log10(1/mseValue);
end
end
