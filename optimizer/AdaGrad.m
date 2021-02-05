function data = AdaGrad(varargin)
    %   Per l'utilizzo dell'ottimizzatore bisogna per prima cosa chiamare questa
    %   funzione passando come parametri i vari hyperparametri come indicato nel
    %   paragrafo successivo. Il risultato di questa prima chiamata deve essere
    %   passato nel campo optimizer della classe NN. 
    %   E' consigliato un valore basso di eta (valore consigliato 0.01)
    %   
    %   Params: Sono tutti opzionali e possono essere inseriti in ordine sparso
    %       [momemtum]: String "m"+Valore. Valore di default 0. 
    %       [lamda]: String "l"+Valore. Valore di default 0.

    momentum = 0;
    lambda = 0;
    SumGrad = {};
    for j = 1 : size(varargin, 2) 
        if isstring(varargin{j})
            varargin{j} = char(varargin{j});
        end
        if ischar(varargin{j}) && varargin{j}(1) == 'm'
            momentum = str2double(extractAfter(varargin{j},1));
        elseif ischar(varargin{j}) && varargin{j}(1) == 'l'
            lambda = str2double(extractAfter(varargin{j},1));
        elseif iscell(varargin{j})
            SumGrad = varargin{j};
        end
    end
    network = varargin{1};
    %Se ho come primo paramatri NN vuol dire sto usando l'optimizer nella
    %rete e quindi devo fare l'aggiornamento dei pesi
    if isa(network,'NN') 
        %Se non ho SumGrad come parametro lo creo
        if size(SumGrad, 2) == 0
            for i = 1: size(network.layers,2); SumGrad(i) = {0}; end
        end
        
        %partendo dall'ultimo livello
        for i = size(network.layers,2) : -1 : 1                
            %Aggiorno il G
            SumGrad(i) = {SumGrad{i} + diag(network.layers(i).grad * network.layers(i).grad')};
            %Aggiorna i pesi
            network.layers(i).W = network.layers(i).W + (network.eta./(SumGrad{i}+1e-8).^0.5)' * network.layers(i).grad ...
                + momentum * network.layers(i).oldGrad ...
                - lambda * network.layers(i).W;
        end
        data = {"m"+momentum "l"+lambda SumGrad};
    else
        %Non ho NN quindi devo costruire i dati da passare nel costruttore
        %della rete
        data = {@AdaGrad {"m"+momentum "l"+lambda}};
    end
end