function result = crossValidationSplitter(pattern, target, k_fold)
    %   Organizza i dati di input necessari per l'addestramento della rete secondo
    %   il metodo di addestramento di Cross Validation.
    %   Parmas:
    %      pattern: pattern di input della rete 
    %      target: pattern di output della rete
    %      k_fold: numero di partizione in cui si vuole dividere i pattern
    %   Return:
    %       result: matrice di cell di due colonne e k_fold righe. 
    %           Ogni riga contiene nella prima cella i pattern e i target
    %           di adestramento nella seconda quelli di Validazione.
    %                       Cosi Costruita.
    %           {    _______Train_________    _____Validation________
    %               {{patternTr},{targetTr}},{{patternVal},{targetVal}}
    %               {{patternTr},{targetTr}},{{patternVal},{targetVal}}
    %                   .
    %                   Pari al numero k_fold indicato nella chiamata
    %                   .
    %               {{patternTr},{targetTr}},{{patternVal},{targetVal}}
    %           }
    %
    
    result = {};
    if size(pattern, 1) ~= size(target,1)
        error('Number of Pattern and Target must be same');
    end
    size_fold = floor(size(pattern,1) / k_fold);
    fold = makeBatch(pattern, target, size_fold);
    
    for i = 1: k_fold
        result{i, 1} = {cell2mat(fold([1:i-1 i+1:end],1)) cell2mat(fold([1:i-1 i+1:end],2))};
        result{i, 2} = {cell2mat(fold(i, 1)) cell2mat(fold(i, 2))};
    end
end