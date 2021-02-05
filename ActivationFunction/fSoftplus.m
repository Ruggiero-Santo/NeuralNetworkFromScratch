function [y] = fSoftplus(x, varargin)
    if isempty(varargin)
        y = log10(1 + exp(x));
    else
        y = 1 ./ (1 + exp(-x)); 
    end
end