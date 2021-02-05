%{
    %Grid search Cross Validation..
    %Cup = %d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f ML-CUP17.csv
    %}
    
    %Acquisizione dati
    filename = 'ML-CUP17-TR-80.csv';
    data = readDataset(filename, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    %Preparazione dati
    data = minMax(data);
    [pattern, target] = splitPatternOutput(data, 10);
    
    %Range di ricerca
    etaRange= [0.001, 0.004, 0.008];
    momentumRange=0.8;
    unitsRange=[6, 8, 10];
    batchRange=100;
    lambdaRange=1e-8;
    activation={@fLogistic}; 
    init={@initialize_Rand};
    
    %estraggo le configurazioni casuali 
    gridSetting=makeGrid(etaRange, momentumRange, unitsRange, ...
        batchRange, lambdaRange, activation, init);

    %per ogni configurazione trovata
    for j=1:size(gridSetting,1)
        
        %Salvo la configurazione
        GridSearchResult{j, 1}=gridSetting(j,:);
        
        %estraggo i parametri
        eta=gridSetting{j, 1};
        momentum=gridSetting{j, 2};
        units=gridSetting{j, 3};
        batchSize=gridSetting{j, 4};
        lambda=gridSetting{j, 5};
        activation=gridSetting{j, 6};
        init=gridSetting{j, 7};
        
        %fisso le epoche
        epochs=1000;
        
        %Creo la rete
        optimizer=AdaDelta("m"+momentum, "l"+lambda, "r0.9");
        hidden1 = Layer(activation, units, 10, init);
        outLayer1 = Layer(activation, 2, init);
        cupnet = NN([hidden1, outLayer1],optimizer,eta);
        
        avgResult= CV(pattern, target, 3, cupnet, epochs, batchSize);
        
        %Salvo il risultato della configurazione testato
        GridSearchResult{j, 2}=avgResult;
    end
    
 %plot e salvataggio risultati
  makePlotGrid(GridSearchResult(), "grid/")
  
  %plot dei risultati
  %{
  for i=1:size(GridSearchResult, 1)
    makePlotCup(GridSearchResult{i, 2}, 'Batch', 'north');
  end
 %} 

