clc
clear all
close all

%% Fitted models 
% controlSubjects = load("ASD_data\MATLAB\Cont_CNN.mat"); # Change the path
% controlSubjects = controlSubjects.cont;
% 
% % taking 75% of control subjects for models
% controlSubjects = controlSubjects(1:150-45,:,:);
% 
% % taking mean of eeg at ith sensors
% controlSubjects = mean(controlSubjects);
% 
% % reshaping to samples*sensors (samples are for first 31 seconds)
% controlSubjects = reshape(controlSubjects,[19,250*31]);
% controlSubjects = controlSubjects';
% 
% % fitted models 
% fittedModels = cell(1,19*(19-1)/2);
% k = 1;
% for sensor_i = 1:19
%     sensor_j = sensor_i + 1;
%     while sensor_j <= 19
%         disp("k: "); disp(k);
%         fittedModels(1,k) = {createFit(controlSubjects(:,sensor_i),controlSubjects(:,sensor_j))};
%         sensor_j = sensor_j + 1;
%         k = k + 1;
%     end
% end
% 
% save("fittedModels.mat","fittedModels")

%% Loading fitted models
fittedModels = load("fittedModels.mat");
fittedModels = fittedModels.fittedModels;


%% Reformating input and output data and getting predicted values
% loading
testData = load("ASD_data\MATLAB\Cont_CNN.mat");
structName = fieldnames(testData);
testData = testData.(structName{1});

% Taking 25% of data
testData = testData(150-45+1:150,:,:);


% input, output (subjects,samples,171) and prediction
for subject = 1:10 % Change 10 to number of subjects you want
    disp("Subject: "); disp(subject);
    x = reshape(testData(subject,:,:),[19,31*250]);
    x = x';

    % input
    input = [];
    for sensor_i = 1:19
        for sensor_j = 1:19-sensor_i
            input = [input,x(:,sensor_i)];
        end
    end
    
    % output
    output = [];
    for sensor = 2:19
        output = [output,x(:,sensor:end)];
    end

    % prediction
    prediction = [];
    for i = 1:171
        prediction(:,i) = feval(fittedModels{i},input(:,i));
    end

    % RMSE between predicted and actual output
    rmse = sqrt(mean((prediction-output).^2));

    % Network Visualization
    figure();
    PN_Visualization(rmse,10^-1); % change threshold
    title(strcat(upper(structName{1})," ","Subject ",string(subject)))

    % Saving figure
    saveas(gcf,strcat("PN_Network/",upper(structName{1}),"_","Subject_",string(subject),".png"))
end






