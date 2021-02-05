function coded = one_of_K(matrix)
    %   Esegue al codifica del One of K sulla mtrice dei dati.
    coded = [];
    for i = 1 : size(matrix,2)
        coded = [coded to_categorical(matrix(:,i))];
    end
end