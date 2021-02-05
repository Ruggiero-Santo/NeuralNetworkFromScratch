function [y] = fReLU(x, varargin)
    if isempty(varargin)
        y = double(x > 0) .* x;
    else
        if x >= 0
            y = x./x;
        else
            y = 0;
        end
    end
end