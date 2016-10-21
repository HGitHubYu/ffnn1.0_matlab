function [TrainingData_input, TrainingData_output] = TrainingData_Generation(opt)

% opt=6;

if opt==1
    
    %% 
    TrainingData_input=0:(60/1000):60;
    TrainingData_output=sin(TrainingData_input).*sin(TrainingData_input);

    TrainingData_input=[zeros(1,15),ones(1,10), zeros(1,13), ones(1,30), zeros(1,5),ones(1,10), zeros(1,8)];
    TrainingData_output=[zeros(1,16),ones(1,10), zeros(1,13), ones(1,30), zeros(1,5),ones(1,10), zeros(1,7)];
    TrainingData_input=[TrainingData_input;TrainingData_output];
    TrainingData_output=1-TrainingData_output;

    TrainingData_input=0:(60/1000):60;
    TrainingData_output=sin(TrainingData_input);
    input_length=length(TrainingData_input);
    TrainingData_input=ones(1,input_length);
    
elseif opt==2

    %% sin() waveform
    aa=0:(120/1000):120;
    TrainingData_output=sin(aa);
    TrainingData_input=ones(1,length(TrainingData_output));
    
elseif opt==3

    %% on-off sin() wave form
    aa=0:(120/1000):120;
    bb=sin(aa);
    TrainingData_input=zeros(1,50);
    TrainingData_output=zeros(1,50);
    TrainingData_input=[TrainingData_input,ones(1,200)];
    TrainingData_output=[TrainingData_output,bb(1:200)];
    TrainingData_input=[TrainingData_input,zeros(1,60)];
    TrainingData_output=[TrainingData_output,zeros(1,60)];
    TrainingData_input=[TrainingData_input,ones(1,100)];
    TrainingData_output=[TrainingData_output,bb(1:100)];
    TrainingData_input=[TrainingData_input,zeros(1,30)];
    TrainingData_output=[TrainingData_output,zeros(1,30)];
    TrainingData_input=[TrainingData_input;0,TrainingData_input(1:end-1);0,0,TrainingData_input(1:end-2)];
    TrainingData_output=[0,TrainingData_output(1:end-1)];
%     plot(TrainingData_input);
    % hold on;
    % plot(TrainingData_output);
    
elseif opt==4

    %% square waveform
    aa=[zeros(1,10),ones(1,10),zeros(1,10),ones(1,10),zeros(1,10),ones(1,10)];
    bb=[aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa];
    TrainingData_input=[zeros(1,90),ones(1,80),zeros(1,80),ones(1,60),zeros(1,100),ones(1,100),zeros(1,50)];
    input_length=length(TrainingData_input);
    TrainingData_output=TrainingData_input.*bb(1:input_length);
    TrainingData_input=[TrainingData_input;0,TrainingData_input(1:end-1);0,0,TrainingData_input(1:end-2)];


    % plot(TrainingData_input);
    % hold on;
    % plot(TrainingData_output);
    
elseif opt==5

    %% function waveform
    aa=0:0.1:50;
    bb=sin(aa);
    cc=[0,bb(1:end-1)];
    dd=bb.^2-2*cc;
    TrainingData_output(1)=dd(1);
    for n=2:length(dd)
        TrainingData_output(n)=dd(n)-TrainingData_output(n-1);
    end
    TrainingData_input=[bb;cc];
    
elseif opt==6

    %% function waveform
    aa=2*rand(1,1000);
    bb=2*rand(1,1000);
    cc=aa.*bb;
    dd=rand(1,1000);
    TrainingData_output=(cc-(aa-bb).^2).*dd;
    TrainingData_input=[aa;bb;cc;dd];
    
elseif opt==7

    %% function waveform
    aa=0:0.001:1.5;
    bb=0:0.001:1.5;
    cc=aa.*bb;
    TrainingData_output=(cc-(aa-bb).^2);
    TrainingData_input=[aa;bb;cc];
    
elseif opt==8
    
    %
    aa=0:0.1:60;
    bb=sin(aa);
    lg=length(aa);
    for n=2:lg
        bb_d(n)=bb(n)-bb(n-1);
    end
%     TrainingData_input=bb(2:end-1);
    TrainingData_input=[bb(2:end-1);bb_d(2:end-1)];
%     TrainingData_output=bb(3:end);
    TrainingData_output=bb_d(3:end);
    
else
    
    %% default sin() waveform
    aa=0:(120/1000):120;
    TrainingData_output=sin(aa);
    TrainingData_input=ones(1,length(TrainingData_output));    
    
end