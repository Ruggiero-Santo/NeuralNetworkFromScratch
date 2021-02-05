function [accuracy] = model_metrics_classification(y_test, y_predi)
    %   Calcola l'accuratezza necessaria per valutare un modello
    %   Params:
    %       y_test: sono i dati target che ci aspettiamo del modello
    %       y_predi: sono i dati output che il modello ha dato
    
    if size(y_test,2) ~= 1
        [M,y_test] = max(y_test,[],2);
        [M,y_predi] = max(y_predi,[],2);
    end
    p = y_test - round(y_predi);
    accuracy = (sum(p == 0) / size(y_test, 1));
end