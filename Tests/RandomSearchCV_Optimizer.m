%{
    %Random search Cross Validation..
    %Cup = %d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f ML-CUP17.csv
    %}

    %Acquisizione dati
    filename = 'ML-CUP17-TR-80.csv';
    data = readDataset(filename, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    %Preparazione dati
    data = minMax(data);
    [pattern, target] = splitPatternOutput(data, 10);
    
    %Range di ricerca
    etaRange= 0.01:0.01:0.2;
    momentumRange=0.3:0.1:0.9;
    units=2:2:10;
    batchRange=0:100:500;
    lambdaRange=logspace(-10,-2, 5);
    activation={@fLogistic, @fSoftplus, @fTanh};
    init={@initialize_Rand, @initialize_Normal, @initialize_Fanin};
    rhoRange=0.8:0.1:1;
    optimizer={@AdaGrad};
    
    %estraggo le configurazioni casuali 
    randomSetting=randomSearch(10, etaRange, momentumRange, units, ...
        batchRange, lambdaRange, activation, init, rhoRange, optimizer);
    
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
        rho=randomSetting{j, 8};
        optimizer=randomSetting{j, 9};
        
        %fisso le epoche
        epochs=1000;
        
        %Creo la rete
        %optimizer=optimizer('m'+momentum, 'l'+lambda, "r"+rho);
        optimizer=optimizer("m"+momentum, "l"+lambda);
        hidden1 = Layer(activation, units, 10, init);
        outLayer1 = Layer(activation, 2, init);
        cupnet = NN([hidden1, outLayer1],optimizer,eta);
        
        %eseguo il Cross Validation
        avgResult= CV(pattern, target, 3, cupnet, epochs, batchSize);

        %Salvo il risultato della configurazione testato
        randomSearchResult{j, 2}=avgResult;            
    end  

 %plot dei risultati
  for i=1:size(randomSearchResult, 1)
    makePlotCup(randomSearchResult{i, 2}, 'Batch', 'north');
  end