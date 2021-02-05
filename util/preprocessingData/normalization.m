function [data, norms] = normalization(data, varargin)
    % Rescaling: normalizza o de-normalizza il vettore di ogni features
    %   dataset: la matrice dei dati su cui deve eseguire
    %       l'orperazione di normalizzazione 
    %   Optional Params
    %        Vettore delle norme
    
    if ~isempty(varargin)
        %denormalizzo
        norms = varargin{1};
        for i = 1: size(data,2)
            data(:,i) = data(:,i) * norms(i);
        end
    else
        %Normalizzo
        for i = 1: size(data,2)
            norms(i) = norm(data(:,i));
            data(:,i) = data(:,i) / norms(i);
        end
    end
end