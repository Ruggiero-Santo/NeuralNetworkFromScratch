function shuffled = shuffle(data)
    %   Mischia il dataset e restituisce il pattern e il target
    %   Params:
    %       data: matice dei dati
    %   Return:
    %       shuffled: matrice data con le righe mischiate

    shuffled = data(randperm(size(data,1)),:);
end