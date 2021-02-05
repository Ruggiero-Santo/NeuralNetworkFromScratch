function [y] = fTanh(x, varargin)
    if isempty(varargin)
        y = (2 ./ (1 + exp(-2.*x))) - 1;
    else
        y = 1 - fTanh(x) .^2;
    end
end