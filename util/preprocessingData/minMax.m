function [data, params] = minMax(data, varargin)
    % Rescaling: per avere ogni features nel range [0,1]
    %   dataset: la matrice dei dati su cui deve eseguire
    %       l'orperazione di rescaling (verrà eseguita su 
    %       ogni features separatamente) -> v-min /(max-min)
    
    global delta
        
    %denormalizzo
    if ~isempty(varargin)
        
        params=varargin{1};
        minV = params{1};
        delta= params{2};
       
        for i = 1: size(data,2)
            data(:,i) = data(:,i) * delta(i) + minV(i);
        end
    %normalizzo
    else
        minV = min(data);
        delta= max(data)-minV;
        

        for i = 1: size(data,2)
            data(:,i) = (data(:,i) - minV(i)) / delta(i);
        end
    end  
    params={minV, delta};
end