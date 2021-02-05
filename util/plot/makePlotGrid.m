function makePlotGrid(gridResult,varargin)
    %   Crea i grafici per il confonto dell'andamento dell' accuratezza e del
    %   loss durante le varie epoche di addestramento del modello calolate sui
    %   input:
    %       history: dati di addestramento e di validazione
    %         deve essere una matrice di 2 o 4 righe che deve contenere i
    %         seguenti array nel'ordine
    %           train_loss: array dei valori di loss calcolati sul trainingSet
    %           train_acc: array dei valori di accuratezza calcolati sul trainingSet 
    %           valid_loss: array dei valori di loss calcolati sul validationSet
    %           valid_acc: array dei valori di accuratezza calcolati sul validationSet
    %       Optional Params:
    %           [filename]: nome del file in cui verranno salvati i grafici
    
    filename='';
    if ~isempty(varargin)
        if size(varargin, 2)==1
            filename=varargin{1};
        end
    end
    
    for i=1:size(gridResult, 1)
        gcf=figure(i);
        set(gcf, 'Position', [100, 200, 300, 250])
        history=gridResult{i, 2};
        train_acc = history(2,:);
        valid_acc = history(4,:);
        hold on
        plot(train_acc(2:end));
        plot(valid_acc(2:end));
        hold off
        
        if ~isempty(filename)
            print(filename+'plot'+num2str(i), '-dpng');
        end
    end
end