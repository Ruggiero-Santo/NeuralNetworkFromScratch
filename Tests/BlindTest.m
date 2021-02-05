%{BLIDN TEST
    %} 
    
    %Acquisizione dati
    filenameTrain = 'ML-CUP17-TR.csv';
    filenameTest='ML-CUP17-TS.csv';
    trainSet = readDataset(filenameTrain, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    %Preparazione dei dati per il Train
    target=trainSet(:, 11:end);
    trainSet = minMax(trainSet);
    [trainPattern, trainTarget] = splitPatternOutput(trainSet, 10);
    
    %Costruzione della rete
    eta = 0.0015;
    momentum = 0.85;
    lambda = 1e-6;
    rho = 0.9;
    optimizer = AdaDelta("m"+momentum, "l"+lambda, "r0.9");
    hidden1 = Layer(@fLogistic, 8, 10, @initialize_Normal);
    outLayer1 = Layer(@fLogistic, 2, @initialize_Normal);
    cupnet = NN([hidden1, outLayer1], optimizer, eta);
   
    %Train dell rete
    result = ...
        cupnet.train(trainPattern, trainTarget, 1000, 100, 't1e-10');
    
    %Print del grafico e delle info della rete
    makePlotCup(result, 'Batch', 'north');
    outString = outputTemplate(filenameTest, cupnet, target, "PEST_E_FASOUL_ML-CUP17TS.csv" );