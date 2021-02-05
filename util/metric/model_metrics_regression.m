function [accuracy] = model_metrics_regression(y_test, y_predi)
    %   Calcola l'accuratezza necessaria per valutare un modello
    %   Params:
    %       y_test: sono i dati target che ci aspettiamo del modello
    %       y_predi: sono i dati output che il modello ha dato
    
    global delta
    
    diff=(y_predi - y_test) .* delta(end-1:end);
    
    p = diff.^2;
    p = sqrt(sum(p,2));
    accuracy = sum(p)/ size(p,1);
end