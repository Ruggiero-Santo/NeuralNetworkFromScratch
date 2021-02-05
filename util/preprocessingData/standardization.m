function [data, standDat]  = standardization(data, varargin)
    % Standardizations: per ottenere media zero e varianza 1, su 
    %   ogni features -> v-mean /standard
    %  dataset: la matrice dei dati su cui deve eseguire
    %   l'orperazione di standardizzazione (verrà eseguita su 
    %   ognifeatures separatamente)
    
    if ~isempty(varargin)
        %De Standardizzazione
        standDat = varargin{1};
        standardD = standDat{1};
        meanD = standDat{2};
        for i = 1: size(data,2)
            data(:,i) = data(:,i) * standardD(i);
        end
        data = data + meanD;
    else
        %Standardizzazione
        standardD = var(data);
        meanD = mean(data);
        standDat = {standardD meanD};
        data = data - meanD;
        for i = 1: size(data,2)
            data(:,i) = data(:,i) / standardD(i);
        end
    end
    
end