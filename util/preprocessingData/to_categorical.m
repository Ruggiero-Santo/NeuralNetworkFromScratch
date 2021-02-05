function matrix = to_categorical(data)
    %   Trasforma un verttore numerico ( che solitamente rappresenta la
    %   classe di appartenenza) in una matrice di pattern avente N colonne
    %   quante sono le classi e ogni riga è piena di 0 apparte per la
    %   colonna corrispondente alla classe.
    %   Params:
    %       data: vettore conenente le classi
    %   Return:
    %       matrix: ogni riga è cosi formata per un valore del vettore
    %           corrispondente a 3 ed un numero di classi totali corrispondente
    %           a 4. [0 0 1 0]
    
    if min(data) == 0
        add = 1;
    else
        add = 0;
    end 
    
    matrix = zeros(size(data,1), max(data));
    for i = 1 : size(data,1)
        matrix(i, data(i) + add) = 1;
    end
end