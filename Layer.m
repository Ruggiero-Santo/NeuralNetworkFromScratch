classdef Layer < handle
    %LAYER Summary of this class goes here
    %   f: funzione di attivazione
    %   units:  numero di unità presenti nel livello
    %   initFunctData: cella contenente i dati della funzione di 
    %       inizializzazione dei pesi
    %   W: matrice dei pesi
    %   out: output del livello [ out = f(net)]
    %   net: input della rete [net = sum(W * out) dove 'out è l'output del livello precedente e W è la matrice dei pesi tra i due livelli']
    %   delta: delta del livello [usato nel calcolo del gradiente]
    %   grad: gradiente del livello [grad = delta W = delta * out del livello precedente ]
    %   oldGrad: gradiente del livello dell'blocco di pattern
    %       precendente [usato per il momentum]
    
    properties   
        f
        units
        
        initFunctData
        
        W
        out
        net
        delta
        grad
        oldGrad
    end
    
    methods
        function L = Layer(f, units, varargin)
            %   Construct an instance of this class
            %   Params:
            %       f: funzione di attivazione
            %       units: numero di unità
            %       varargin: puo contenere una o più tra le seguenti 
            %           informazioni nel seguente odine:
            %               inputUnit: il numero di unita di input cioè il
            %                   numero di pattern ( se non si sta indicando 
            %                   il creando il primo livello della rete 
            %                   omettere questo valore)
            %               inizializeFunction: funzione di
            %                   inizializzazione dei pesi della rete.
            %               Range di inizializzazione: range che deve
            %                   assumere la funzione di inizializzazione
            %                   nella creazione dei vari pesi. Se inserito
            %                   solo un valore il range sarà [-n n]
            
            if units <= 0
                error("Number of unit in layer must be 1 or more.");
            end
            
            L.f = f;
            L.units = units;
            L.W = 0;
            
            L.initFunctData = {};
            
            if ~isempty(varargin)
                if isfloat(varargin{1})
                    if size(varargin,2) == 1
                        if isscalar(varargin{1})
                            %primo livello, solo il numero input
                            L.initializeLayer(varargin{1});
                        else
                            %generico livello, le info F o Range
                            L.initFunctData = varargin;
                        end
                    else
                        %primo livello, numero input e le info F e/o Range
                        L.initFunctData = varargin(2:end);
                        L.initializeLayer(varargin{1});
                    end
                else
                    %generico livello, le info F e/o Range
                    L.initFunctData = varargin;
                end
            end
            
            L.net = 0;
            L.out = 0;
            L.delta = 0;
            L.grad = 0;
            L.oldGrad = 0;
        end
        
        function initializeLayer(L, input, varargin)
            %   Inizializza i pesi dei vari neuroni all'interno del livello
            %   Params:
            %       input: numero di unità di input del livello
            %       varargin: puo contenere una o più tra le seguenti 
            %           informazioni nel seguente odine:
            %               inizializeFunction: funzione di
            %                   inizializzazione dei pesi della rete.
            %               Range di inizializzazione: range che deve
            %                   assumere la funzione di inizializzazione
            %                   nella creazione dei vari pesi.Se inserito
            %                   solo un valore il range sarà [-n n]
            
            input = input + 1;
            if ~isempty(L.initFunctData) && isempty(varargin)
                varargin = L.initFunctData;
            end
            if isempty(varargin)
                L.W = initialize_Rand(input, L.units, [-0.5 0.5]);
            else
                if isa(varargin{1}, 'function_handle')
                    if size(varargin, 2) == 2
                        if isscalar(varargin{2})
                            L.W = varargin{1}(input, L.units, [-varargin{2} varargin{2}]);
                        end
                        if ~isscalar(varargin{2})
                            L.W = varargin{1}(input, L.units, varargin{2});
                        end
                    else
                        L.W = varargin{1}(input, L.units, [-0.5 0.5]);
                    end
                else
                    if isscalar(varargin{1})
                        L.W = initialize_Rand(input, L.units, [-varargin{1} varargin{1}]);
                    end
                    if ~isscalar(varargin{1})
                        L.W = initialize_Rand(input, L.units, varargin{1});
                    end
                end
            end
        end
        
        function wipeLayer(L)
            %   Effettua il wipe della rete mantenendo però inalterati gli
            %   hyperparametri
            
            L.net = 0;
            L.out = 0;
            L.delta = 0;
            L.grad = 0;
            L.oldGrad = 0;
            
            L.initializeLayer(L.inputSize);
        end
        
        function  out = forward(L, pattern)
            %   Effettua uno step di forward tra due livelli
            %   le dimensioni tra input e W devono concordare 
            %   input:
            %       pattern: input del livello
            %   return 
            %       out: output del livello
            
            L.net = pattern * L.W;
            L.out = [L.f(L.net) ones(size(L.net,1), 1)];
            out = L.out;
        end
        
        function inputSize = inputSize(L)
            %   Restituisce il numero di input del livello preso in considerazione 
            inputSize = size(L.W, 1)-1;
        end
        
        function str = layer2str(L, num)
            %   Costriusce una stringa con tutte le informazioni utili sul
            %   livello. 
            %   Params:
            %       num: numero indentificatovo del livello.
            
            str ="\n"+ num +" Livello: "+...
                "\n\t Input: " + L.inputSize +...
                "\n\t Units: " + L.units +...
                "\n\t F Activation: " + func2str(L.f);
            if isempty(L.initFunctData)
                str = str + "\n\t F Initialization: initialize_Rand" +...
                    "\n\t\t Range: [-0,5 0.5]";
            else
                 if size(L.initFunctData,2) == 1
                    if isa(L.initFunctData{1}, 'function_handle')
                        str = str + "\n\t F Initialization: " + func2str(L.initFunctData{1}) +...
                            "\n\t\t Range: [-0,5 0.5]";
                    else
                        if isscalar(L.initFunctData{1})
                            str = str + "\n\t F Initialization: initialize_Rand" +...
                                "\n\t\t Range: [-"+ L.initFunctData{1}+" "+L.initFunctData{1}+"]";
                        else
                            str = str + "\n\t F Initialization: initialize_Rand" +...
                                "\n\t\t Range: "+ mat2str(cell2mat(L.initFunctData(1)));
                        end
                    end
                 else
                     if isscalar(L.initFunctData{2})
                         str = str + "\n\t F Initialization: " + func2str(L.initFunctData{1}) +...
                             "\n\t\t Range: [-"+ L.initFunctData{2}+" "+L.initFunctData{2}+"]";
                     else
                         str = str + "\n\t F Initialization: " + func2str(L.initFunctData{1}) +...
                             "\n\t\t Range: "+ mat2str(cell2mat(L.initFunctData(2)));
                     end
                 end
            end
        end
    end
    
end