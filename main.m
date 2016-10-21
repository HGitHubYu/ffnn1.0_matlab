clc;
clear;
close all;

tic

%% prepare data
% path='';
% data=load(path);
% TrainingData=data;

[TrainingData_input, TrainingData_output] = TrainingData_Generation(8);

[input_dimension, input_length]=size(TrainingData_input);
[output_dimension, output_length]=size(TrainingData_output);

%%
numInputUnits= input_dimension;
numHiddenNeurons= [5]; % multilayer
numOutputUnits= output_dimension;
deltaWeight=0.0002;
ann_error_threshold=0.005;
ann_error_iteration=inf; % output error in a single training iteration
training_iteration=0;
training_iteration_threshold=5000;

net=ann_new(numInputUnits, numHiddenNeurons, numOutputUnits);

while ann_error_iteration>ann_error_threshold && training_iteration<training_iteration_threshold
    
    ann_error_iteration=0;
    training_iteration=training_iteration+1
    net=ann_train_bp(net, TrainingData_input, TrainingData_output, deltaWeight);
    output=ann_simulate(net, TrainingData_input, output_dimension);
    for m=1:output_dimension
        for n=1:output_length
            ann_error_iteration = ann_error_iteration+0.5*(output(m,n)-TrainingData_output(m,n))^2;
        end
    end
    ann_error_iteration
    ann_error(training_iteration)=ann_error_iteration;
end

toc

subplot(2,2,1);
plot(ann_error);
subplot(2,2,2);
plot(TrainingData_output,'b-');
subplot(2,2,2);
hold on;
plot(output, 'r-');
hold on;
plot(TrainingData_input(2,:), 'g-');

