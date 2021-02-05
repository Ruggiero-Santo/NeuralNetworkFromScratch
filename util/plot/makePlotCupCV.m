function makePlotCupCV(history, varargin)
    %  ADATTATO PER LA RICERCA DEL MIGLIOR K NEL CROSS VALIDATION
    %   input:
    %       history: dati di addestramento e di validazione
    %         deve essere una matrice di 2 o 4 righe che deve contenere i
    %         seguenti array nel'ordine
    %           train_loss: array dei valori di loss calcolati sul trainingSet
    %           train_acc: array dei valori di accuratezza calcolati sul trainingSet 
    %           valid_loss: array dei valori di loss calcolati sul validationSet
    %           valid_acc: array dei valori di accuratezza calcolati sul validationSet
    %       Optional Params:
    %           [figName]: il nome della finestra in cui verranno visualizzati i
    %               grafici
    %           [position]: posizione della finestra nello schermo.( punti
    %               cardinali)
    %           [Nunfold]: Numero dei foldi di partenza del cross
    %               validation
    
    if size(history,1) == 6
        train_loss = history(1,:);
        train_acc = history(2,:);
        valid_loss = history(3,:);
        valid_acc = history(4,:);
        test_loss = history(5,:);
        test_acc = history(6,:);
    else
        if size(history,1) == 4
            train_loss = history(1,:);
            train_acc = history(2,:);
            valid_loss = history(3,:);
            valid_acc = history(4,:);
        else
            train_loss = history(1,:);
            train_acc = history(2,:);
        end
    end
      
    if ~isempty(varargin)
        if size(varargin,3) == 1
            startK=varargin{3};
            varargin{3}=[];
            
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
    ax1 = subplot(2,1,1);
    hold on
    title(ax1, 'Accuracy');
    plot(train_acc(2:end));
    axis([startK+1 size(train_acc, 2) 0 max([train_acc, valid_acc])+1]);
    xlabel('K');
    ylabel('MEE');
    if size(history,1) == 6
        plot(valid_acc(2:end));
        plot(test_acc(2:end));
        legend(ax1, 'Training Accuracy', 'Validation  Accuracy', 'Test Accuracy');
        
    else
        if size(history,1) == 4
            plot(valid_acc(2:end));
            legend(ax1, 'Training Accuracy', 'Test  Accuracy');
            
        else
            legend(ax1, 'Training Accuracy');
            
        end
    end
    
    hold off
    
    ax2 = subplot(2,1,2);
    hold on
    title(ax2,'Loss');
    plot(train_loss(2:end));
    xlabel('K');
    ylabel('MSE');
    if size(history,1) == 6
        plot(valid_loss(2:end));
        plot(test_loss(2:end));
        axis([startK+1 size(train_acc, 2) 0 max([train_loss,valid_loss,test_loss])]);
        legend(ax2, 'Training loss', 'Validation  loss', 'Test Loss');
  
    else
        if size(history,1) == 4
            plot(valid_loss(2:end));
            axis([startK+1 size(train_acc, 2) 0 max([train_loss,valid_loss])]);
            legend(ax2, 'Training loss', 'Test loss');
        else
            axis([1 size(train_acc, 2) 0 max(train_loss)]);
            legend(ax2, 'Training loss');
        end
    end
end