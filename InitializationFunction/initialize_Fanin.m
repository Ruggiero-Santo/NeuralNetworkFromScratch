function matrix = initialize_Fanin(row, col, range)
    %Inizializza i pesi con distribuzione casuale nel range indicato ma 
    % divide il veso generato per il fanin del livello
    size_range = range(1,2) - range(1,1);
    
    matrix = (rand(row, col) * size_range) + range(1,1);
    matrix = 2 * matrix ./ row;
end