function out = outputTemplate(filenameIN, network, target, varargin)
    %   Crea la stringa di out secondo il template dato del professore per
    %   l'output della Cup
    %   Params:
    %       filenameIN: File di input per i dati per il predict
    %       network: rete addestrata per effettuare il predict
    %       target: Dati per la denormalizzazone dell'out dell rete
    %       varargin: 
    %           [pathfilename]: il percorso di un file csv nel quale verrà
    %               creato/sovrascritto il template
    %   Return:
    %       out: String di che verra inserita nel file
    
    data = readDataset(filenameIN, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 9, 1);
    id = readDataset(filenameIN, '%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 9, -10);
    data = minMax(data);
    
    %normalizzo i target
    [target ,delta] = minMax(target);
    %eseguo la rete
    outNet = network.predict(data);
    %denormalizzo l'output della rete
    outNet = minMax(outNet, delta);
    
    movegui(figure('Name', 'Grafico'), 'north');
    hold on;
    scatter(outNet(:,1),outNet(:,2), 10, '+');
    
    out = "# Michele Cafagna, Ruggiero Santo\n# Nickname\n# ML-CUP17\n# 02/11/2017\n";
    for i = 1 : size(outNet)
        out = out +"\n"+ id(i) +","+outNet(i,1)+","+outNet(i,2);
    end
    if ~isempty(varargin)
        fid = fopen(varargin{1},'wt');
        fprintf(fid, out);
        fclose(fid);
    end
end