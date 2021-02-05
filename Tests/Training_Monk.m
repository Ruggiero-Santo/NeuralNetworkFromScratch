%{
    %test training..
    %monks 1 = '%f %f %f %f %f %f %f %s'
    %}

    %Acquisizione dati
    filename = 'monks1_train.txt';
    data = readDataset(filename, ' %f %f %f %f %f %f %f %s', 0, -1);
    [target, pattern] = splitPatternOutput(data, 1);
    pattern = one_of_K(pattern);
    
    filename_test = 'monks1_test.txt';
    test_data = readDataset(filename_test, ' %f %f %f %f %f %f %f %s', 0, -1);
    [target_test, pattern_test] = splitPatternOutput(test_data, 1);
    pattern_test = one_of_K(pattern_test);
    
    %Inizializzo la rete
    eta = 0.01;
    momentum = 0.85;
    lambda = 0;
    optimizer = AdaDelta("m"+momentum, "l"+lambda);
    hidden1 = Layer(@fLogistic, 3, 17);
    outLayer1 = Layer(@fLogistic, 1);
    monknet = NN([hidden1, outLayer1], optimizer, eta);
   
 %{  
    momentum = 0.8;
    regularization = 1e-4;
    
    monknet.eta = 0.7;
    result = ...
        monknet.train(pattern, target, 1200, momentum, regularization, 0, {pattern_test target_test});
    makePlot(result, 'Batch', 'northwest');
    monknet.wipe()
 %}
    result = ...
        monknet.train(pattern, target, 200, 25, 't0.98', {pattern_test target_test});
    makePlot(result, 'Mini Batch', 'north');
    sprintf(monknet.NN2str)
    monknet.wipe();
    
 %{
    monknet.eta = 0.05;
    momentum = 0.1;
    regularization = 1e-4;
    result = ...
        monknet.train(pattern, target, 500, momentum, regularization, 1, {pattern_test target_test});
    makePlot(result, 'OnLine', 'northeast');
  %} 
    