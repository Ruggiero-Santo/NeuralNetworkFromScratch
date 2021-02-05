function showCup(target, prediction, varargin)
    %   Crea lo scatter plot del target e dei dati predeti
    %   input:
    %      	target: dati di output target della Cup
    %       prediction: dati di output predetti dalla rete dopo il train
    %           della Cup
    %       Optional Params:
    %           [figName]: il nome della finestra in cui verranno visualizzati i
    %               grafici
    %           [position]: posizione della finestra nello schermo.( punti
    %               cardinali)
    
    if ~isempty(varargin)
        if size(varargin,2) == 1
            figName = varargin{1};
            position = 'north';
        else
            figName = varargin{1};
            position = varargin{2};
        end
    else
        figName = 'Grafico';
        position = 'north';
    end

    movegui(figure('Name', figName), position);
    hold on;
    scatter(prediction(:,1),prediction(:,2), 10, '+');
    scatter(target(:,1),target(:,2), 10, 'o')
    legend('Dati Predetti', 'Dati Target');
end

