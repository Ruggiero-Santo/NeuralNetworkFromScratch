function avgResult = CV(pattern, target, k, net, epochs, batchSize)
    %   Crea e esegue il trein dei vari fold creati con la cross validation
    %   e restituisce la media dei risultati avuti con i vari modelli
    %   validati.
    %   Params:
    %   Return:
    %       avgResult: Matrice contenente i risultati di accuratezza e 
    %           loss medi per ogni modello ad ogni epoca per i pattern di
    %           Train e di validation e test se indicati. La
    %           matrice è cosi costruta:
    %           [
    %               [Train Accuracy]
    %               [Train Loss]
    %               [Validation Accuracy](Se indicata la precentuale)
    %               [Validation Loss]
    %               [Test Accuracy](Se indicati i pattern di Test)
    %               [Test Loss]
    %           ]
    
    %Creo i folds per il cross validation
    folds = crossValidationSplitter(pattern, target, k);
    %eseguo il Cross Validation
    avgResult=[];

    for i=1:size(folds, 1)
        train=folds{i,1};
        valid=folds{i,2};    

        metrics = ...
            net.train(train{1}, train{2}, epochs, batchSize, 't0', {valid{1}, valid{2}});

        if isempty(avgResult)
            avgResult = metrics;
        else    
            oldMetrics = avgResult;
            newMetrics = [oldMetrics(1,:); metrics(1,:)];
            metrics(1,:) = mean(newMetrics, 1); 

            newMetrics = [oldMetrics(2,:); metrics(2,:)];
            metrics(2,:) = mean(newMetrics, 1); 

            avgResult = metrics;
        end
        net.wipe();
    end
end

