classdef NN < handle
    %NN Summary of this class goes here
    %   description_Model: String per la descrizione del modello topologia
    %       della rete
    %   description_Train: String per la descrizione dei dati di input
    %       durante l'addestramento della rete
    %   layers: vettore dei livelli della rete
    %   eta: learning rate
    %   dloss: derivata del loss 
    %   fOptimizer: puntatore della funzione di ottimizzazione della rete
    %   DataOptimizer: Dati necessari per la funzione di ottimizzazione 
    
    properties
        description_Model
        description_Train
        layers
        eta       
        dloss
        fOptimizer
        dataOptimizer
    end
    
    methods
        function network = NN(layers, optimizer, eta)
            %   Costruttore della rete 
            %	Params:
            %       Layers: vettore ordinato di Layers
            %       optimizer: Cella contenete il puntatore alla funzione
            %           di ottimizzazione ed un atltra cella con tutti i dati
            %           necessari per la funzione stessa (La costruzione di
            %           questa struttura è fatta direttamente dalla funzione di
            %           ottimizzazione se chiamata con i parametri da noi
            %           scelti)
            %       eta: learning rate
            %   Return params:
            %       network: rete costruita e inizializzata          
            
            if isempty(layers)
                error('You cannot make a Neural Network without layers');
            end
            if layers(1).W == 0
                error('In first layer you must insert number of input');
            end
                
            network.description_Model = "NumLayer: "+ size(layers, 2) + ...
                "\nInput Network: " + layers(1, 1).inputSize +...
                "\nInfo Layer:" + layers(1, 1).layer2str(1);
            
            for i = 2: size(layers, 2)
                layers(1, i).initializeLayer(layers(1, i-1).units);
                network.description_Model = network.description_Model + layers(1, i).layer2str(i);
            end
            
            network.fOptimizer = optimizer{1};
            network.dataOptimizer = optimizer{2};
            
            network.description_Model = network.description_Model +...
                "\nF Optimizer: " + func2str(network.fOptimizer) +...
                "\nData Optimizer: " + strcat(network.dataOptimizer{:});

            network.layers = layers;
            network.eta = eta;
            network.dloss = 0;
        end
        
        function out = forward(network, pattern)
            %   Esegue un forward su tutta la rete
            %   Params:
            %       network: rete
            %       pattern: pattern di input della rete
            %   Return params: 
            %       out: output della rete

            out = network.layers(1).forward(pattern);
            for i = 2 : size(network.layers,2)
                out = network.layers(i).forward(out);
            end
            
           out = out(:, 1:end-1);
        end
        
        function prediction = predict(network, pattern)
            %   Esegue le previsioni sulla rete dai i pattern
            %   Params:
            %       network: rete
            %       pattern: pattern di input della rete
            %   Return params: 
            %       out: output della rete
            pattern = [pattern ones(size(pattern, 1), 1)];
            prediction = forward(network, pattern);
        end
        
        function [result] = train(network, allPattern, allTarget, epoch, batch_size, varargin)            
            %   Esegue il training della rete
            %   Params:
            %       network: rete
            %       allPattern: pattern di input della rete 
            %       allTarget: output atteso della rete
            %       epoch: numero di epoche (epoca = propagazione dell'intero training set nella rete)
            %       batch_size:  la dimensione del batch:
            %           value = 0 per batch:
            %               applica il gradiente alla fine di ogni epoca (la 
            %               somma dei gradienti dei pattern di esempio del training)
            %           value = 1 per online: 
            %               applica il gradiente ad ogni pattern) [default value]
            %           value = n per mini-batch: 
            %               applica il gradiente alla fine di n pattern (la
            %               somma dei gradienti degli 'n' pattern)
            %               [se n = dimensione del dataset equivalente a batch] 
            %       Optional Params: 
            %           [validation]: percentuale del da usare come validationset [0 to 0.5]
            %           [test_data]: cell di pattern e target di test della
            %               rete {pattern target}
            %           [threshold]: stringa composta da "t<numero>" per
            %               impostare il valore di sogla per l'early stop
            %   Return: 
            %       result: Matrice contenente i risultati di accuratezza e 
            %           loss del modello ad ogni epoca per i pattern di
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
            
            testPattern = 0;
            testTarget = 0;
            valid_percent = 0;
            threshold = Inf;
            
            %Controllo dei parametri all'interno del varargin
            if ~isempty(varargin)
                for j = 1 : size(varargin, 2) 
                     if isscalar(varargin{j})
                        valid_percent = varargin{j};
                     elseif ischar(varargin{j}) && varargin{j}(1) == 't'
                         threshold = str2double(extractAfter(varargin{j},1));                           
                     else
                         testPattern = varargin{j}{1};
                         testTarget = varargin{j}{2};
                     end
                end
            end
            testPattern = [testPattern ones(size(testPattern, 1), 1)];
            
            %Check validity of validation percent
            if valid_percent < 0 || valid_percent > 0.5
                error('il validation deve essere compreso tra 0 e 50%')
            end
            
            %Controllo sui dati in di addestramento
            if size(allPattern, 2) ~= network.layers(1).inputSize
                error('Number of units in output layer must be same to target size. Use to_categorical function if you have more classes.');
            end
            if size(allPattern, 1) ~= size(allTarget, 1)
                error('Number of Pattern and Target must be same');
            end
            
            allPattern = [allPattern ones(size(allPattern, 1), 1)];
            
            %default 10 epoche
            if epoch == 0
                epoch = 10;
            end
            
            sizePattern = size(allPattern, 2);
            %Mischio il dataset in maniere omogenea tra pattern e target
            data = shuffle([allPattern allTarget]);

            if valid_percent ~= 0
                %Divido il dataset in training e validation 
                [valSet, trainSet]= split(data, valid_percent);

                %Ottengo i pattern e i target dal validationSet 
                [valSet_pattern, valSet_target] = splitPatternOutput(valSet, sizePattern);
                
            else
                trainSet = [allPattern allTarget];
            end
            
            %controllo e correzione del batch size
            nPattern = size(allPattern,1);
            if batch_size == 0
                batch_size = size(trainSet, 1);
            elseif batch_size > nPattern
                batch_size = nPattern;
            elseif batch_size < 0
                error('Batch size value must be positive.');
            end
            
            for i = 1 : epoch
                trainSet = shuffle(trainSet);
                
                %Ottengo i pattern e i target dal trainingSet
                [trainSet_pattern, trainSet_target] = splitPatternOutput(trainSet, sizePattern);
                
                batchMatrix = makeBatch(trainSet_pattern, trainSet_target, batch_size);
                for j = 1 : size(batchMatrix,1)
                    %eseguo la BackPropagation su ogni Batch
                    network.backprop(cell2mat(batchMatrix(j, 1)), cell2mat(batchMatrix(j, 2)));
                end
                [train_loss(i), train_acc(i)] = network.validate(trainSet_pattern, trainSet_target);
                if valid_percent ~= 0
                    [valid_loss(i), valid_acc(i)] = network.validate(valSet_pattern, valSet_target);
                end
                if ~isscalar(testTarget)
                    [test_loss(i), test_acc(i)] = network.validate(testPattern, testTarget); 
                end
                
                %Early stop criteria
                if i > 2 && abs(train_loss(end - 1) - train_loss(end)) < threshold
                    break;
                end
            end
            
            network.description_Train = "\nEta: " +  network.eta +...
                "\nEpoch: " + epoch +...
                "\nBatch size: " + batch_size;
            if threshold ~= Inf 
                network.description_Train = network.description_Train + ...
                    "\nThreshold: " + threshold;
            end
            network.description_Train = network.description_Train  + ...
                "\nValid %%: " + valid_percent +...
                "\n\nMin Loss Train: " + min(train_loss) +...
                "\nLast Loss Train: " + train_loss(end) +...
                "\nMax Accuracy Train: " + max(train_acc) +...
                "\nLast Accuracy Train: " + train_acc(end); 
            
            result = [train_loss; train_acc];
            
            if valid_percent ~= 0
                network.description_Train = network.description_Train  + ...
                    "\nMin Loss Valid: " + min(valid_loss) +...
                    "\nLast Loss Valid: " + valid_loss(end) +...
                    "\nMax Accuracy Valid: " + max(valid_acc) +...
                    "\nLast Accuracy Valid: " + valid_acc(end); 
                result = [result; valid_loss; valid_acc];
            end
            if ~isscalar(testTarget)
                network.description_Train = network.description_Train  + ...
                    "\nMin Loss Test: " + min(test_loss) +...
                    "\nLast Loss Test: " + test_loss(end) +...
                    "\nMax Accuracy Test: " + max(test_acc) +...
                    "\nLast Accuracy Test: " + test_acc(end); 
                result = [result; test_loss; test_acc];
            end
            
        end
        
        function backprop(network, pattern, target)
            %Aggiorna i pesi della rete tramite la backpropagation
            %   Params:
            %       network: rete
            %       pattern: pattern di input della rete 
            %           necessario per il calcolo del gradiente
            %       target: output atteso della rete
            %           necessario per il calcolo del gradiente
            
            network.compute_gradient(pattern, target);
            network.dataOptimizer = network.fOptimizer(network, network.dataOptimizer{:});
            
        end
        
        function compute_gradient(network, pattern, target)
            %Calcola i gradiente su tutta la rete
            %   Params:
            %       network: rete
            %       pattern: pattern di input della rete
            %           utilizzato per il forward e il calcolo del
            %           gradiente del livello di input
            %       target: output atteso della rete 
            %           utilizzato per il calcolo del loss (utile per il
            %           calcolo del delta del layer di output)
            
            outNet = network.forward(pattern);
            network.compute_loss(outNet, target);
            
            %partendo dall'ultimo livello (output)
            for i = size(network.layers,2) : -1 : 2  
                network.layers(i).oldGrad = network.layers(i).grad;
                network.layers(i).grad = (network.layers(i-1).out' * network.compute_delta_layer(i)) / size(pattern,1);
            end  
            %layer di input
            network.layers(1).oldGrad = network.layers(1).grad;
            network.layers(1).grad = (pattern' * network.compute_delta_layer(1)) / size(pattern,1);
        end
        
        function delta = compute_delta_layer(network, i)
            %Calcola il delta di un solo livello
            %   Params:
            %       i: indice del livello su cui calcolare il delta
            
            df_net = network.layers(i).f(network.layers(i).net, 'derived');

            %se è l'ultimo livello usa la formula chiusa
            if i == size(network.layers,2)
                %delta output layer
                network.layers(i).delta = network.dloss .* df_net;
            else
                %delta hidden layer                
                network.layers(i).delta = (network.layers(i+1).W(1:end-1, :) * network.layers(i+1).delta')' .* df_net; 
            end
            
            delta = network.layers(i).delta;
        end
        
        function loss = compute_loss(network, output, target)
            %   Calcola il vettore delle loss per l'ultimo livello
            %   Params:
            %       net: l'oggetto NN
            %       pattern: input della rete
            %       target: valore atteso della rete
            
            %Calcolo il vettore delle derivate del loss  
            network.dloss = target - output;          
            %Calcolo il loss totale della rete per il/i pattern
            loss = sum(network.dloss .^ 2) / (2 * size(output, 1));
        end
        
        function [loss, acc] = validate(network, valSet_pattern, valSet_target)
            %   Effettua la validazione sul validation set e calcola l'errore
            %   Params:
            %       network: oggetto NN
            %       valSet_pattern: input della rete su cui fare la
            %           validazione
            %       valSet_target: output atteso dalla rete sui pattern di
            %           validazione
            
            outNet = forward(network, valSet_pattern);
            %Se ho più unità di output prendo quella con il loss maggiore
            loss = max(compute_loss(network, outNet, valSet_target), [], 2);
            %Verifico tramite i valori target la tipologia di problema
            if floor(sum(valSet_target)) ~= sum(valSet_target)
                acc = model_metrics_regression(valSet_target, outNet);
            else
                acc = model_metrics_classification(valSet_target, outNet);
            end
        end
        
        function wipe(network)
            %   Effettua un reset dei pesi di tutta la rete
            %   Params:
            %       network: oggetto NN
            
            for i = 1: size(network.layers, 2)
                network.layers(1, i).wipeLayer();
            end
        end
        
        function str = NN2str(network)
            if isempty(network.description_Model) || isempty(network.description_Train)
                error("You must create NN and execute Train");
            end
            str = network.description_Model + network.description_Train;
        end
    end
end