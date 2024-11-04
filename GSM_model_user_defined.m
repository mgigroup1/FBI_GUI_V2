% ref: Papoutsakis, Eleftherios Terry. "Equations and calculations for fermentations of butyric acid bacteria." Biotechnology and bioengineering 67.6 (2000): 813-826.
% user-defined model
% creat a structure for storing all the info.
model = struct();
% store the information by defining model.the_dictionary_name.
% stoichiometric matrix (dim ={m,n})
model.S= [
    2, -1, 0, 0, 0, 0, 0, 0, 0, 0, -2;  % 2a -> b + 2k
    0, 1, 0, 0, -1, -1, -1, -1, 0, -1, 0;  % b -> e + f + g + h + j
    2, 0, 0, 1, 0, -2, -2, 0, -1, -2, 0;  % 2a - 1.75 + d -> 2f + 2g + i + 2j
    0, 1, -1, -1, 0, 0, 0, 0, 0, 0, 0;  % b -> c + d
    6, -1, 0, 0, -2, -2, -2, -2, 0, -2, -6;  % Carbon balance
];
% the tag name for the mets and rxns
model.mets = {'1', '2', '3', '4', '5'}'; % row
model.rxns = {'a','b','c','d','e','f','g','h','i','j','k'}'; % column

% set a larve positive or negative value for the lb and ub.
model.lb = [0,0,0,-1000,0,-1000,0,-1000,0,0,0]'; % d,f, h reactions are reversible.
model.ub = [1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000]';

% revisibility (dim = {n})
model.rev = [0,0,0,1,0,1,0,1,0,0,0]'; % rev = 1

% S*v = b, b =0 or b ~= 0. (dim = {m})
model.b = [0,0,1.75,0,0]';

% model.c is the objective vector (dim = {n}). When the coefficient of the first element =1, we
% say a is the objective. The vector can be defined in the GUI.
model.c = [0,0,0,0,0,0,0,0,0,0,0]';

% rename the model: the name of the structure need to be "modelJoint", but
% there is no naming rule for the data file name. 
modelJoint = model;
% save the file to the path (.mat)


