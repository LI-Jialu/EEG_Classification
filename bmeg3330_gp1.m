%% BMEG3330 FINAL PROJECT GROUP 1

%% Organizing training data
train_folder = 'training_data\';

[EEG,LABELS] = OrgData(train_folder,29,-3,3);

%% Feature Extraction

band_num = 1;                                                   % number of bands
trial_num = size(EEG,1);
channel_num = size(EEG,3);
band_power = zeros(trial_num,band_num,channel_num);   	% the shape of [trial_num,band_num,channel_num]

for i = 1:trial_num
    for j = 1:band_num
        for k = 1:channel_num
            band_power(i,j,k) = mean(EEG(i,:,k).^2);
        end
    end
end

training_feature = reshape(band_power,[size(band_power,1),size(band_power,2)*size(band_power,3)]);

%% Model Trainning

% -------------train the NN classifier--------------
% nn_mdl = patternnet([8,6],'traingd');
% onehot_LABELS = (LABELS==0:3);
% nn_mdl = train(nn_mdl,training_feature',onehot_LABELS');
% 
% y = nn_mdl(training_feature');

% -------------train  LDA classifier--------------

% thelda_mdl = fitcdiscr(training_feature,LABELS,'DiscrimType','linear');

% ---------------------------------------------------

% -------------train the SVM classifier--------------
svm_mdls = cell(4,1);
classes = unique(LABELS);

for j = 1:length(classes)
    indx = strcmp(string(LABELS),string(classes(j)));    % Create binary classes for each classifier
    svm_mdls{j} = fitcsvm(training_feature,indx,'ClassNames',[false true] ,'Standardize',true,...
        'KernelFunction','linear','KernelScale','auto','Standardize',true); 
end
% ---------------------------------------------------

% ------------train the KNN classifier--------------
% knn_mdl = fitcknn(training_feature,LABELS,'NumNeighbors',5,'Standardize',1,'Distance','euclidean');
% ---------------------------------------------------




classes = vec2ind(y);
decision = classes - 1;
decision = decision';

x = find(decision == LABELS);
acc = length(x)/length(LABELS)






















