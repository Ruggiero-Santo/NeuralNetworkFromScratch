function matrix= initialize_Normal(row, col, varargin)
    %Initializer with Normal Distribution
    if ~isempty(varargin)
        val = varargin{1};
        mean = val(1);
        std = val (2);
    else
        mean = 0.0;
        std = 0.05;
    end
    matrix=normrnd(mean, std, [row, col]);
end

