function neto=ann_train_bp(net, TrainingData_input, TrainingData_output, deltaWeight)

% train ANN using back propagation
%
% numInputUnits : number of input units for InputData
% numHiddenNeurons : it's a vector, which contains number of units in each hidden layer.
% numOutputUnits : number of output units
%
% net{
%     .numInputUnits
%     .numHiddenNeurons
%     .numOutputUnits
%     .numAllUnits
%     .weights[]
%         .dest
%         .source
%         .value
%     .numWeights
%    }
%
% ANN1.0 structure: 
%              input_layer    Hidden_layer    Hidden_layer    Hidden_layer   output_layer
% 
%     bias=1 -------O
%
%                                   O     
%   input[1,:]------O                               O               O
%                                   O
%   input[2,:]------O                               O               O              O--------------TrainingData_output[1,:]
%                                   O
%   input[ ,:]------O                               O               O              O--------------TrainingData_output[ ,:]
%                                   O
%   input[ ,:]------O                               O               O              
%                                   O
%                                                   O               O              
%                                   O
%                           


% parameter checking
[input_dimension, input_length]=size(TrainingData_input);
[output_dimension, output_length]=size(TrainingData_output);
if input_dimension ~= net.numInputUnits
    error ('Number of input units and input pattern size do not match.'); 
end
if output_dimension ~= net.numOutputUnits
    error ('Number of output units and target pattern size do not match.'); 
end
if input_length ~= output_length
    error ('length of input and output samples is different.'); 
end

%% setting parameters
firstStep=1;
lastStep=input_length;

ACT=zeros(net.numAllUnits, lastStep);
ACT(1,:)=1; % constant bias unit
ACT(2:net.numInputUnits+1 , firstStep:lastStep) = TrainingData_input;
ACTD=zeros(net.numAllUnits, lastStep); % derivative: unit_output / unit_input

% assign paramters
weightsDest   = [net.weights.dest]; 
weightsDest(end+1) = -1; % used as a sign if index goes out of range
weightsSource = [net.weights.source];
weightsValue  = [net.weights.value];

step_OutputError_derivatives_weights=zeros(net.numWeights, net.numOutputUnits, lastStep);
total_OutputError_derivatives_weights=zeros(1,net.numWeights);
%% main loop
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
    
    % back propagation
    ffnnOutput_derivatives_weights=zeros(net.numWeights, net.numOutputUnits); % derivatives: ffnnOutput/weights
    ffnnOutput_derivatives_unitActivity=zeros(net.numAllUnits, net.numOutputUnits); % ffnn derivatives: ffnnOutput/unit_outputs
    ffnnOutput_derivatives_unitActivity(net.numAllUnits-net.numOutputUnits+1:net.numAllUnits , 1:net.numOutputUnits)=eye(net.numOutputUnits);
   
    nextDest = weightsDest(net.numWeights);
    Weight_Index=net.numWeights;
    while Weight_Index >0
        dest=nextDest;       
        while dest==nextDest
            source=weightsSource(Weight_Index);
            ffnnOutput_derivatives_weights(Weight_Index, :)=ffnnOutput_derivatives_unitActivity(dest, :)*ACTD(dest,step)*ACT(source,step);
            
            % calculate ffnn derivatives: ffnnOutput/unitOutputs
            ffnnOutput_derivatives_unitActivity(source,:)=ffnnOutput_derivatives_unitActivity(source,:) ...
                +ffnnOutput_derivatives_unitActivity(dest, :)*ACTD(dest,step)*weightsValue(Weight_Index);
            
            % get next destination node
            Weight_Index = Weight_Index-1;
            if Weight_Index==0, break; end;
            nextDest = weightsDest(Weight_Index);
        end               
    end
    
    % calculate current step OutputError derivatives: step_OutputError/weights
    for UI=1:net.numOutputUnits
        step_OutputError_derivatives_weights(:,UI,step)= ffnnOutput_derivatives_weights(:,UI) ...
            *(ACT(UI+(net.numAllUnits-net.numOutputUnits), step)-TrainingData_output(UI, step));
    end
end

%% calculate total OutputError derivatives: total_OutputError/weights
for WI=1:net.numWeights
    for UI=1:net.numOutputUnits
        for st=(firstStep:lastStep)
            total_OutputError_derivatives_weights(WI)=total_OutputError_derivatives_weights(WI)+step_OutputError_derivatives_weights(WI,UI,st);
        end
    end
end
% adjust weights
weightsValue = weightsValue - total_OutputError_derivatives_weights*deltaWeight;
for WI=1:net.numWeights
    net.weights(WI).value = weightsValue(WI); 
end

neto=net;