function [y] = fLogistic(x, varargin)
    if isempty(varargin)
        y = 1 ./ (1 + exp(-x));
    else
        y = fLogistic(x) .* (1 - fLogistic(x)); 
    end
end