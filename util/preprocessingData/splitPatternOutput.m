function [first, second] = splitPatternOutput(dataset, colDividing)
    %   Divide la matrice dataset in due parti(verticalmente) prendento come
    %   colonna divisoria colDividing
    %   Params:
    %       dataset: matrice che deve essere divisa in due parte
    %       colDividing: indice della colonna di divisione ( la colonna e
    %       inserita nel primo blocco)
    %   Return: le due parti dopo lo splitting
    %       part1: le prime colDividin colonne
    %       part2: le colonne rimanenti
     
    first = dataset(:, 1:colDividing);
    second = dataset(:, colDividing + 1:end);
end
