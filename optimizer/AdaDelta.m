function data = AdaDelta(varargin)
    %   Per l'utilizzo dell'ottimizzatore bisogna per prima cosa chiamare questa
    %   funzione passando come parametri i vari hyperparametri come indicato nel
    %   paragrafo successivo. Il risultato di questa prima chiamata deve essere
    %   passato nel campo optimizer della classe NN. 
    %   E' consigliato un valore basso di eta (valore consigliato 0.01)
    %   
    %   Params: Sono tutti opzionali e possono essere inseriti in ordine sparso
    %       [momemtum]: String "m"+Valore. Valore di default 0. 
    %       [lamda]: String "l"+Valore. Valore di default 0.
    %       [rho]: String "r"+Valore. Valore di default 0.95.

    rho = 0.95;
    momentum = 0;
    lambda = 0;
    EGrad = {};
    EDelta = {};
    for j = 1 : size(varargin, 2) 
        if isstring(varargin{j})
            varargin{j} = char(varargin{j});
        end
        if ischar(varargin{j}) && varargin{j}(1) == 'm'
            momentum = str2double(extractAfter(varargin{j},1));
        elseif ischar(varargin{j}) && varargin{j}(1) == 'l'
            lambda = str2double(extractAfter(varargin{j},1));
        elseif ischar(varargin{j}) && varargin{j}(1) == 'r'
            rho = str2double(extractAfter(varargin{j},1));
        elseif iscell(varargin{j})
            data = varargin{j};
            EGrad = data{1};
            EDelta = data{2};
        end
    end 
    network = varargin{1};
    %Se ho come primo paramatri NN vuol dire sto usando l'optimizer nella
    %rete e quindi devo fare l'aggiornamento dei pesi
    if isa(network,'NN') 
        %Se non ho EGrad e EDelta come parametro li creo
        if size(EGrad, 2) == 0
            for i = 1: size(network.layers,2); EGrad(i) = {0}; end
            for i = 1: size(network.layers,2); EDelta(i) = {0}; end
        end
        %partendo dall'ultimo livello
        for i = size(network.layers,2) : -1 : 1                
            %Aggiorno EGrad e EDelta
            EGrad(i) = {rho * EGrad{i} + (1 - rho) * network.layers(i).grad.^2 };
            RMSGrad = (EGrad{i} + 1e-8).^0.5;
            Delta = network.eta./ RMSGrad(i) * network.layers(i).grad;
            EDelta(i) = {rho * EDelta{i} + (1 - rho) * Delta.^2 };
            RMSDelta = (EDelta{i} + 1e-8).^0.5;
            
            %Aggiorna i pesi
            network.layers(i).W = network.layers(i).W + RMSDelta(i)/RMSGrad(i) * network.layers(i).grad...
                + momentum * network.layers(i).oldGrad ...
                - lambda * network.layers(i).W;
        end
        data = {"m"+momentum "l"+lambda "r"+rho {EGrad EDelta}};
    else
        %Non ho NN quindi devo costruire i dati da passare nel costruttore
        %della rete
        data = {@AdaDelta {"m"+momentum "l"+lambda "r"+rho}};
    end
end