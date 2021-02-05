function [part1, part2] = split(data, percent)
    %divide una matrice per righe in base ad una percentuale
    %   Params:
    %       data: matrice
    %       percent: percentuale in decimale es: 0.27 --> 27%
    %   Return: le due parti dopo lo splitting
    %       part1: la parte percentuale scelta
    %       part2: la parte rimanente

    if percent <= 0 || percent > 99
        error('invalid percentage')
    end

    splitIndex = floor(size(data,1) * percent);
    
    part1 = data(1:splitIndex,:);
    part2 = data(splitIndex+1:end ,:);
end