% Defines fitness function here
fitnessFunction = @(x) sum(x.^2); % Example fitness function (minimize sum of squares)

% Defines genetic algorithm options
options = gaoptimset('UseParallel', true, 'Display', 'off'); % Enables parallel computing

% Defines problem and GA parameters
nVar = 10; % Number of variables in the optimization problem
lb = -10 * ones(1, nVar); % Lower bounds for variables
ub = 10 * ones(1, nVar); % Upper bounds for variables

% Runs parallelized genetic algorithm for different core counts
coresToTest = [2, 4, 6, 8, 10, 12]; % Cores to test
timeTaken = zeros(size(coresToTest)); % Array to store execution times

for i = 1:length(coresToTest)
    numCores = coresToTest(i);
    
    % Checks if there's an existing pool and delete it before creating a new one
    existingPool = gcp('nocreate');
    if ~isempty(existingPool)
        delete(existingPool);
    end
    
    % Runs the genetic algorithm without explicitly setting parallel pool
    options = gaoptimset(options, 'UseParallel', true, 'Display', 'off');
    
    % Runs the genetic algorithm
    tic;
    [~, ~] = ga(fitnessFunction, nVar, [], [], [], [], lb, ub, [], options);
    timeTaken(i) = toc;
end

% Displays the execution times
disp('Execution times for different core counts:');
disp(timeTaken);

% Visualizes the execution times against core counts
figure;
plot(coresToTest, timeTaken, 'bo-', 'LineWidth', 2);
xlabel('Number of Cores');
ylabel('Execution Time (seconds)');
title('Execution Time vs Number of Cores');
grid on;
