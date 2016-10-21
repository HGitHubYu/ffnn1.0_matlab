function [act, act_d]=activation_function_and_derivative(unit_input_sum, opt)
% the activation function, and its derivative

% opt=2;

if opt==1
    
    %% option 1: sigmoid function
    act = 1 ./ (1+exp(-unit_input_sum));
    act_d = act * (1-act);
    
elseif opt==2
    
    %% option 2: tanh
    act = (exp(unit_input_sum)-exp(-unit_input_sum)) ./ (exp(unit_input_sum)+exp(-unit_input_sum));
    act_d = 1-act.^2;
    
else
    
    %% default option: sigmoid function
    act = 1 ./ (1+exp(-unit_input_sum));
    act_d = act * (1-act);
    
end
