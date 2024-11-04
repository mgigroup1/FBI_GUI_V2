function [v_observe] = userdefinedFBA(modelJoint, measured_mets)
%%% example: run without GUI
% % load(modelJoint_name)
% % Measured metabolite uptake rates
%   b1 = [-107.249, -2.404620858, 0, -1.729838122, 0, 5.499468282, ...
%          4.134158638, 0.074900509, 42.98724836, 0, 0, 0, 0, 18.62694718, 0, 0]';
%     
% % Identify corresponding metabolite uptake rates in the model
%   measured_mets = {'EX_glc__D_e', 'EX_lac__D_e', 'EX_glyc_e', 'EX_ac_e', ...
%                      'EX_for_e', 'EX_but_e', 'EX_etha_e', 'EX_acald_e', ...
%                      'EX_succ_e', 'EX_fum_e', 'EX_mal__L_e', 'EX_pyr_e', ...
%                      'EX_glyclt_e', 'EX_co2_e', 'EX_h2o_e', 'EX_h2_e'};
%                  

%% START
% Substitute the element of b1 with the corresponding metabolite uptake rates
%     for i = 1:length(measured_mets)
%         met_index = find(strcmp(modelJoint.rxns, measured_mets{i}));
%         if ~isempty(met_index)
%             modelJoint.b(met_index) = modelJoint.b(i);
%         end
%     end
%     
[m, n] = size(modelJoint.S);
% assert(size(modelJoint.S, 1) == length(modelJoint.b), 'Dimension mismatch: modelJoint.S and modelJoint.b');
% assert(size(modelJoint.S, 2) == length(modelJoint.lb), 'Dimension mismatch: modelJoint.S and modelJoint.lb');
% assert(size(modelJoint.S, 2) == length(modelJoint.ub), 'Dimension mismatch: modelJoint.S and modelJoint.ub');

%% Deterministic NLP solvers: fmincon
% Optimization settings for fmincon. may sensitive to the starting point
% Set a consistent initial guess
v_guess = 0.1 * ones(n, 1);
options = optimoptions('fmincon', ...
                       'MaxIterations', 1000, ...
                       'FunctionTolerance', 1e-10, ...
                       'Display', 'iter');

% Define the objective function
objective = @(v) (norm(modelJoint.S * v - modelJoint.b, 2)).^2;

% Perform optimization using fmincon
[v_opt_fmincon, ~] = fmincon(objective, v_guess, [], [], [], [], modelJoint.lb, modelJoint.ub, [], options);

% Calculate observed flux distribution
v_observe = modelJoint.S2 * v_opt_fmincon;


% %% stochastic NLP solvers: SA method
%     % Optimization settings
%     [m, ~] = size(modelJoint.lb);
%     v_guess = 0.1 * ones(m, 1);
%     options = optimoptions('simulannealbnd', ...
%                            'MaxIterations', 1000, ...
%                            'FunctionTolerance', 1e-10);
% 
%     % Define the objective function
%     objective = @(v) (norm(modelJoint.S * v - modelJoint.b, 2)).^2;
% 
%     % Perform optimization using simulated annealing
%     [v_opt_sa, ~] = simulannealbnd(objective, v_guess, modelJoint.lb, modelJoint.ub, options);
% 
%     % Calculate observed flux distribution
%     v_observe = modelJoint.S2 * v_opt_sa;

end