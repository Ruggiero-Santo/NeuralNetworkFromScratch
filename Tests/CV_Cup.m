%{
    %Cross Validation..
    %Cup = %d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f ML-CUP17.csv
    %}
    
    %Acqusizione dati
    filename = 'ML-CUP17-TR-80.csv';
    data = readDataset(filename, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    %Preparazione dei dati
    data = minMax(data);
    [pattern, target] = splitPatternOutput(data, 10);
    
    %Creo i folds per il cross validation
    folds = crossValidationSplitter(pattern, target, 5);
    
    %Creo la rete
    eta = 0.0015;
    momentum = 0.85;
    lambda = 1e-6;
    optimizer = AdaDelta("m"+momentum, "l"+lambda, "r0.9");
    hidden1 = Layer(@fLogistic, 8, 10, @initialize_Normal);
    outLayer1 = Layer(@fReLU, 2, @initialize_Normal);
    cupnet = NN([hidden1, outLayer1],optimizer, eta);
    
    %setto i parametri per il training
    epoch=2000;
    batchSize=100;
    
    tic;
    %eseguo la cross validation
    avgResult= CV(pattern, target, 3, cupnet, epochs, batchSize);
    toc;
    
    makePlotCup(avgResult, 'Batch', 'north');
   %sprintf(monknet.NN2str)
   %showCup(target, monknet.predict(pattern), 'Scatter Cup', 'east');
   %monknet.wipeNet();
    
    
    