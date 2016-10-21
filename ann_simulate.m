function output=ann_simulate(net, input, output_dimension)
% 

[input_dimension, input_length]=size(input);
if input_dimension ~= net.numInputUnits
    error ('Number of input units and input patterns do not match.'); 
end


%% setting parameters
firstStep=1;
lastStep=input_length;

ACT=zeros(net.numAllUnits, lastStep);
ACT(1,:)=1; % constant bias unit
ACT(2:net.numInputUnits+1 , firstStep:lastStep) = input;
ACTD=zeros(net.numAllUnits, lastStep); % derivative: unit_output / unit_input

% assign paramters
weightsDest   = [net.weights.dest]; 
weightsDest(end+1) = -1; % used as a sign if index goes out of range
weightsSource = [net.weights.source];
weightsValue  = [net.weights.value];

for step=(firstStep:lastStep)
    
    % feed forward
    nextDest= weightsDest(1);
    Weight_Index=1;
    while Weight_Index <= net.numWeights
        unit_input_sum = 0; % unit_input_sum : the input to a unit, which is a sum of wi*xi
        dest=nextDest;
        while dest == nextDest
           unit_input_sum=unit_input_sum+ weightsValue(Weight_Index) * ACT(weightsSource(Weight_Index), step); 
           Weight_Index=Weight_Index+1;
           nextDest = weightsDest(Weight_Index);
        end
        if dest >=net.numAllUnits-net.numOutputUnits+1
             % output unit, derivative = 1
            ACT(dest, step)=unit_input_sum;
            ACTD(dest, step)=1;
        else
            % hidden unit, use activation function
            [ACT(dest, step), ACTD(dest, step)]= activation_function_and_derivative(unit_input_sum, 2);
        end   
    end
end

output=ACT((net.numAllUnits-net.numOutputUnits+1) : (net.numAllUnits-net.numOutputUnits +output_dimension) , firstStep:lastStep);
