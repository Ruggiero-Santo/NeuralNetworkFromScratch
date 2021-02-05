%{
    %test training..
    %Cup = %d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f ML-CUP17-TR.csv
    %}

    %Acquisizione dati
    filenameTrain = 'ML-CUP17-TR-80.csv';
    filenameTest='TEST-20.csv';
    trainSet = readDataset(filenameTrain, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    trainSet = minMax(trainSet);
    
    testSet = readDataset(filenameTest, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    testSet = minMax(testSet);
    
    [trainPattern, trainTarget] = splitPatternOutput(trainSet, 10);
    [testPattern, testTarget] = splitPatternOutput(testSet, 10);

    %Inizializzo la rete
    eta = 0.0015;
    momentum = 0.85;
    lambda = 1e-6;
    rho = 0.9;
    optimizer = AdaDelta("m"+momentum, "l"+lambda, "r0.9");
    hidden1 = Layer(@fLogistic, 8, 10, @initialize_Normal);
    outLayer1 = Layer(@fLogistic, 2, @initialize_Normal);
    monknet = NN([hidden1, outLayer1], optimizer, eta);
    
    tic;
    %Eseguo il train
    result = ...
        monknet.train(trainPattern, trainTarget, 1000, 100, 't1e-10', {testPattern, testTarget});
    toc;
    
    %Visualizzo i risultati della rete
    makePlotCup(result, 'Batch', 'north');
    showCup(target, monknet.predict(pattern), 'Scatter Cup', 'east');
    %{
    sprintf(monknet.NN2str)
    showCup(target, monknet.predict(pattern), 'Scatter Cup', 'east');
    monknet.wipe();
    %}
    
    