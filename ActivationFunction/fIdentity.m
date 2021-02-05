function [y] = fIdentity(x, varargin)
    if isempty(varargin)
        y = x;
    else
        y = x./x;
    end
end