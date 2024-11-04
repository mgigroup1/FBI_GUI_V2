% This script models the co-culture system. The matrix S represents the stoichiometric model 
% for all metabolites measured in the experiment. The expanded matrix S2 is derived from S 
% and includes additional metabolites that the user intends to predict.
%
% S*v = b, b is the measured titer uptake rate. dim(S) = {m,n}
% stoichiometric matrix, S
S =[
-1	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	-1	0
0	0	0	0	0	0	0	0	0	0	0	0	1	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	1	-1	1	-1	0	0	0	0	0	0	1
0	0	0	0	0	0	0	0	0	0	0	1	0	0	0
0	0	0	0	0	0	0	0	0	0	1	-1	0	0	0
0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
0	0	0	0	0	0	0	0	1	0	0	0	0	0	0
0	0	0	0	0	1	-1	0	0	0	0	0	0	0	0
0	0	0	0	0	0	1	0	0	0	0	0	0	0	0
2	0	0	1	0	-2	-2	0	-1	-2	0	-1	-1	2	0
0	1	-1	-1	0	0	0	0	0	0	0	0	0	0	0
2	-1	0	0	0	0	0	0	0	0	-2	0	-1	2	0];

% lower and upper bound of the reactions, e.g., the reversibility
lb = [0,0,0,-1000,0,-1000,0,-1000,0,0,0,0,0,0,0]'; % d,f, h reactions are reversible.
ub = [1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000]';

% expand stoichiometric matrix, S2. 
% dim(S2) = {M,n}, where M>m
% after computing the fluxes, v, with the use of S, plug-in S2.
S2 =[
-1	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	-1	0
0	0	0	0	0	0	0	0	0	0	0	0	1	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	1	-1	1	-1	0	0	0	0	0	0	1
0	0	0	0	0	0	0	0	0	0	0	1	0	0	0
0	0	0	0	0	0	0	0	0	0	1	-1	0	0	0
0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
0	0	0	0	0	0	0	0	1	0	0	0	0	0	0
0	0	0	0	0	1	-1	0	0	0	0	0	0	0	0
0	0	0	0	0	0	1	0	0	0	0	0	0	0	0
2	0	0	1	0	-2	-2	0	-1	-2	0	-1	-1	2	0
0	1	-1	-1	0	0	0	0	0	0	0	0	0	0	0
2	-1	0	0	0	0	0	0	0	0	-2	0	-1	2	0
0	0	0	0	0	0	0	1	-1	0	0	0	0	0	0
0	1	0	0	0	0	0	1	0	0	2	0	0	0	0
];

% met names for the models S (met) and S2 (met2).
% rxn names for both of the models S and S2.
mets = {'Glucose' 'Fructose' 'Lactate' 'Glycerol' 'Acetate' '2,3 BD' 'Acetoin' 'EtOH' 'IPA' 'Butyrate' 'BuOH' 'NADH2' 'FdH2' 'Pyruvate'}';
mets2 = {'Glucose' 'Fructose' 'Lactate' 'Glycerol' 'Acetate' '2,3 BD' 'Acetoin' 'EtOH' 'IPA' 'Butyrate' 'BuOH' 'NADH2' 'FdH2' 'Pyruvate' 'EX_Acetone'  'CO2' }';
rxns = {'Glc'	'Pyruvate decarboxylation'	'H2'	'Fd-NAD'	'Acetate'	'Butyrate'	'Butanol'	'Acetone'	'IPA'	'EtOH'	'Acetoin'	'23BD'	'Lactate'	'Frc'	'WLP'}';

% store the values in the model.
% Create the model structure
model = struct();
model.S = S;
model.S2 = S2;
model.rxns = rxns;
% model.rxnNames = rxnNames;
model.mets = mets;
model.mets2 = mets2;
model.lb = lb;
model.ub = ub;
model.c = zeros(size(S,2),1);
model.b = zeros(size(S,1),1); % set zero in the model, and the value will be substituded with the exp data.
model.description = 'Metabolic Model Coculture';
modelJoint = model;
% save the files with user defined name, e.g., caccljco_v2.mat
save('caccljco_v2.mat', 'modelJoint');
