function  data = readDataset(filename, regex, varargin)
    %   readDataset legge il dataset Numerico da un file di testo 
    %   Params:
    %       filename: percorso del file
    %       regex: espressione in formato per la letture di ogni riga del file
    %       Optional Params:(se ho un solo valore verrà considerato offset)
    %           offset: riga di partenza dei pattern da leggere e
    %               memorizzare
    %           deleteRow: indice positivo per eliminare le prime N colonne
    %                     indice negativo per eliminare le ultime N colonne
    %   Return:
    %       data: matrice prettamente numerica che elimina lultima colonna
    %       del file
    
    file = fopen(filename, 'r');
    
    if ~isempty(varargin) && isscalar(varargin{1})
        text = textscan(file, regex, 'headerlines', varargin{1});
    else
        text = textscan(file, regex);
    end
    fclose(file);
    
    if ~isempty(varargin) && size(varargin,2) == 2 && isscalar(varargin{2})
        if varargin{2} < 0
            data = cell2mat(text(1:end+varargin{2}));
        else
            data = cell2mat(text(1+varargin{2}:end));
        end
    else
        data =cell2mat(text);
    end
end