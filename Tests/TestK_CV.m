%TEST NUMERO DI FOLD CROSS VALIDATION
%{
    %Cross Validation..
    %Cup = %d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f ML-CUP17.csv
    %}
    
    %Acquisizione dati
    filename = 'ML-CUP17-TR-80.csv';
    data = readDataset(filename, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 10, 1);
    %Preparazione dati
    data = minMax(data);
    [pattern, target] = splitPatternOutput(data, 10);
    
    %Creo la rete
    eta = 0.1;
    momentum = 0.8;
    lambda = 0;
    optimizer = SGD("m"+momentum, "l"+lambda);
    hidden1 = Layer(@fLogistic, 5, 10);
    outLayer1 = Layer(@fLogistic, 2);
    cupnet = NN([hidden1, outLayer1],optimizer, eta);
    
    %setto i parametri per il training
    epoch=1000;
    batchSize=500;
    
    resultset=[];
    for k=2:7
        result=CV(pattern, target, 3, cupnet, epoch, batchSize);
        resultset=[resultset, min(result,[], 2)];
    end
  
   makePlotCupCV(resultset, 'CV', 'north',2);
   %sprintf(monknet.NN2str)
   %showCup(target, monknet.predict(pattern), 'Scatter Cup', 'east');
   %monknet.wipeNet();