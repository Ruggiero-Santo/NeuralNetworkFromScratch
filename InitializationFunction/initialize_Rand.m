function matrix = initialize_Rand(row, col, range)
    %Initializer with Random Distribution
    size_range = range(1,2) - range(1,1);
    
    matrix = (rand(row, col) * size_range) + range(1,1);
end