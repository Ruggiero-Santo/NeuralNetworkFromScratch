function result = randomSearch(numSample, varargin)
    %   Restituisce numSample combinazioni casuali sui renge inseriti ne
    %   varargin.
    %   Params:
    %       NumSample: Numero di esempi che deve restituire.
    %       varargin: Vari range su cui deve creare la grisgli e prendere
    %       delgi esempi casuali. (Vedi doc della makeGrid)
    %   Return:
    %       result: cella con gli esempi estratti casualmete dalla griglia
    
    if ~isscalar(numSample) && floor(numSample) == numSample
        error("numSample must be real positive integers");
    end
    
    comb = makeGrid(varargin{:});
    shuffledComb = comb(randperm(size(comb,1)),:);
    %Prendo numSample indici senza ripetizioni
    index=datasample(1:1:size(shuffledComb, 1), numSample, 'Replace', false);
    result = shuffledComb(index,:);
end

