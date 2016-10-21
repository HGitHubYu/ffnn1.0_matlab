function net = ann_new(numInputUnits, numHiddenNeurons, numOutputUnits)

% set up a multi-layer ann. Each layer has a bias term, which is 1 here.
% The output layer does not have a sigmoid function.
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
%     .numHiddenLayers
%     .weights[]
%         .dest
%         .source
%         .value
%         .type
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

%%
% set the number of all units
numAllUnits=1+ numInputUnits + sum(numHiddenNeurons) + numOutputUnits;

% set net attributes
net.numInputUnits = numInputUnits;
net.numHiddenNeurons = numHiddenNeurons;
net.numOutputUnits = numOutputUnits;
net.numAllUnits=numAllUnits;
net.numHiddenLayers=length(numHiddenNeurons);

% set weight attributes
weight = struct('dest',0,'source',0,'value',0,'type',1);

%% set network weights
index=1;
% set weights from input layer to the 1st hidden layer
for d= (numInputUnits+2 : numInputUnits+1+numHiddenNeurons(1)) 
    for s = (1: numInputUnits+1)
        net.weights(index)=weight;
        net.weights(index).dest = d;
        net.weights(index).source = s;
        index=index+1;
    end
end

% set weights from hidden layer to the next hidden layer. 
if net.numHiddenLayers >1
    for lyr=(2:net.numHiddenLayers)
        for d=(numInputUnits+1+sum(numHiddenNeurons(1:lyr-1))+1 : numInputUnits+1+sum(numHiddenNeurons(1:lyr)))
            for s=[1, numInputUnits+1+sum(numHiddenNeurons(1:lyr-1))+1-numHiddenNeurons(lyr-1) :numInputUnits+1+sum(numHiddenNeurons(1:lyr-1))]
                net.weights(index)=weight;
                net.weights(index).dest = d;
                net.weights(index).source = s;
                index=index+1;
            end
        end
    end
end

% set weights from hidden layer to output layer. 
% There is also a constant bias unit connected to the output layer
for d= (numAllUnits-numOutputUnits+1: numAllUnits)
    for s = [1, numAllUnits-numOutputUnits-numHiddenNeurons(end)+1 : numAllUnits-numOutputUnits]
        net.weights(index)=weight;
        net.weights(index).dest = d;
        net.weights(index).source = s;
        index=index+1;
    end
end
net.numWeights=index-1;

%%
init_weights=0;
if init_weights==1
    % initialize weights randomly in [-range_magnitude ~ range_magnitude]
    range_magnitude=0.5;
    for index=(1:net.numWeights)
        net.weights(index).value = rand .* 2 .* range_magnitude - range_magnitude;
    end
else
    % load weights from saved file
    loadfile=sprintf('%s\\..\\project\\weightsValue.mat',pwd);
    load(loadfile);
    for index=(1:net.numWeights)
        net.weights(index).value = weightsValue(index);
    end
end
