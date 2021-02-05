%{
    %Random search Cross Validation..
    %Cup = %d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f ML-CUP17.csv
    %}

    %Acqusizione dati
    filename = 'ML-CUP17-TR-80.csv';
    data = readDataset(filename, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    %Preparazione dei dati
    data = minMax(data);
    [pattern, target] = splitPatternOutput(data, 10);
    
    %Range di ricerca
    etaRange= 0.01:0.1:1;
    momentumRange=0:0.1:0.9;
    units=2:2:10;
    batchRange=0:100:500;
    lambdaRange=logspace(-10,-2, 5);
    activation={@fLogistic, @fTanh, @fSoftplus};
    init={@initialize_Rand, @initialize_Normal, @initialize_Fanin};
    
    %estraggo le configurazioni casuali 
    randomSetting=randomSearch(10, etaRange, momentumRange, units, ...
        batchRange, lambdaRange, activation, init);
    
    %per ogni configurazione trovata
    for j=1:size(randomSetting,1)
        
        %Salvo la configurazione
        randomSearchResult{j, 1}=randomSetting(j,:);
        
        %estraggo i parametri
        eta=randomSetting{j, 1};
        momentum=randomSetting{j, 2};
        units=randomSetting{j, 3};
        batchSize=randomSetting{j, 4};
        lambda=randomSetting{j, 5};
        activation=randomSetting{j, 6};
        init=randomSetting{j, 7};
        
        %fisso le epoche
        epochs=1000;
        
        %Creo la rete
        optimizer=SGD("m"+momentum, "l"+lambda);
        hidden1 = Layer(activation, units, 10, init);
        outLayer1 = Layer(activation, 2, init);
        cupnet = NN([hidden1, outLayer1],optimizer,eta);
        
        avgResult= CV(pattern, target, 3, cupnet, epochs, batchSize);
        
        %Salvo il risultato della configurazione testato
        randomSearchResult{j, 2}=avgResult;   
    end

 %plot dei risultati
  for i=1:size(randomSearchResult, 1)
    makePlotCup(randomSearchResult{i, 2}, 'Batch', 'north');
  end