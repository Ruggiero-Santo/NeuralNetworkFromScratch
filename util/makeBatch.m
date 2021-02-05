function batchMatrix = makeBatch(pattern, target, batch_size)
    %   Organizza i dati di input necessari per l'addestramento della rete secondo
    %   il metodo di addestramento di Cross Validation.
    %   Prams:
    %      pattern: pattern di input della rete 
    %      target: pattern di output della rete
    %      batch_size: numero di pattern presenti in ogni batch
    %   return:
    %       result: matrice di cell di due colonne e N.Pattern/batch_size 
    %       (arrotondato in accesso) righe. Ogni riga è un batch da far fare 
    %       alla rete, la prima colonna contiene l'insieme di pattern di
    %       input la seconda colonna i target. 
    
    batchMatrix = {};
    for j = 0 : floor(size(pattern,1) / batch_size) - 1
        
        batch_s = (j * batch_size) + 1; 
        batch_e = (j + 1) * batch_size;
        
        batchMatrix(j+1, 1) = {pattern(batch_s:batch_e, :)};
        batchMatrix(j+1, 2) = {target(batch_s:batch_e, :)};
        
    end
    batch_e = batch_e + 1;
    if batch_e < size(pattern,1)
        batchMatrix(j+2, 1) = {pattern(batch_e:end, :)};
        batchMatrix(j+2, 2) = {target(batch_e:end, :)};
    end
end