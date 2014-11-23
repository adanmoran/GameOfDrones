function graph_m = graph(edge_file,weightings_file,price_weight,time_weight,DEBUG)
%% File setup
% Reads files and prepares initial variables and matrices.
    % Initialization of variables if not passed as arguments.
    if ~exist('DEBUG','var')
        DEBUG = false;
    end
    if ~exist('price_weight','var')
        price_weight = 1;
    end
    if ~exist('time_weight','var')
        time_weight = 1;
    end
    
    %Constants
    DELIM = ',';
    HEADERS = 1;
    
    
    % Read the CSV files with the graph information into a matrix
    % Format of edges is: "node1num,node2num,edge_type,edge_distance"
    % Format of weightings is: "edge_type,price_per_km,speed"
    if DEBUG
        fprintf('names ran:\n');
    end
    edges = read_mixed_csv(edge_file,DELIM);
    edges = edges((HEADERS+1):end,:);
    %NEED TO CHANGE DATA IN EDGES TO NUMBERS, ONCE IT EXISTS.
    if DEBUG
        fprintf('edges ran\n');
    end
    weightings = read_mixed_csv(weightings_file,DELIM);
    weightings = weightings((HEADERS+1):end,:);
    weightings = cellstr2num(weightings,2:3);
    if DEBUG
        fprintf('weightings ran\n');
    end
    
%% Creation of graph
    % Set graph_m to an nxn matrix of -1's to do work on it.
    n = max(cell2mat(edges(:,2)));
    graph_m = -1 .* ones(n);
    
    % Iterate through the edges matrix and assign the price and time values
    for i = 1:length(edges)
        % Holds the values of the weightings type associated with this row
        
        type_vector = weightings(find(strcmp(cell2mat(edges(i,3)), ...
            weightings)),:);
        % Set the values of the edges array based on the distances
        edges{i,5} = edges{i,4} .* type_vector{i,2};
        edges{i,6} = edges{i,4} .* type_vector{i,3};
    end
    
    % Go through graph_m and start setting the values as the lowest
    % weighted average.
    for k = 1:size(edges,1)
        edges(k,1) = i;
        edges(k,2)= j;
            if ((weighted_avg(price_weight, edges(k,5), ...
            time_weight, edges(k,6)) < graph_m(i,j) || ...
            graph_m(i,j) = -1)
            graph_m(i,j) =  weighted_avg(price_weight, ...
            edges(k,5), time_weight, edges(k,6));
    end
end
