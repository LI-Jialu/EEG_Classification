%% BMEG3330 FINAL PROJECT GROUP 1
T_in = -4; 
T_out = 1; 
%% Train data
train_folder = 'train_data\';
[train_EEG,train_LABELS] = OrgData(train_folder,30,T_in,T_out);
train_feature = ExFeature(train_EEG);
%% Test Data
test_folder = 'test_data\';
[test_EEG,test_LABELS] = OrgData(test_folder,30,T_in,T_out);
test_feature = ExFeature(test_EEG);
%% Project Data
project_folder = 'test\';
[project_EEG,project_LABELS] = OrgData(project_folder,30,T_in,T_out);
project_feature = ExFeature(project_EEG);
%% Model Trainning
rng(1);
% -------------train the NN classifier--------------
nn_mdl = patternnet([16,8,4]);
onehot_LABELS = (train_LABELS==0:3);
nn_mdl = train(nn_mdl,train_feature',onehot_LABELS');
% ---------------------------------------------------

% -------------train  LDA classifier-----------------
lda_mdl = fitcdiscr(train_feature,train_LABELS);
% ---------------------------------------------------

% -------------train the SVM classifier--------------
svm_mdls = cell(4,1);
classes = unique(train_LABELS);
rng(1); % For reproducibility
SVM_predicted_labels = [];
for j = 1:length(classes)
    indx = strcmp(string(train_LABELS),string(classes(j)));    % Create binary classes for each classifier
    svm_mdls{j} = fitcsvm(train_feature,indx,'ClassNames',[false true] ,'Standardize',true,...
        'KernelFunction','linear','KernelScale','auto'); 
end 
% ---------------------------------------------------

% ------------train the KNN classifier--------------
knn_mdl = fitcknn(train_feature,train_LABELS,'NumNeighbors',3,'Standardize',1,'Distance','euclidean');
% ---------------------------------------------------

%% validation
% for NN 
NN_predicted_labels = nn_mdl(test_feature');
nnclasses = vec2ind(NN_predicted_labels);
decision = nnclasses - 1;
decision = decision';
x_nn = find(decision == test_LABELS);
acc_nn = length(x_nn)/length(test_LABELS)

% for LDA
LDA_predicted_labels = predict(lda_mdl,test_feature);
x_lda = find(LDA_predicted_labels == test_LABELS);
acc_lda = length(x_lda)/length(test_LABELS)

% for SVM
Scores = zeros(length(test_LABELS),length(classes));
for j = 1:length(classes)
    [~,score] = predict(svm_mdls{j},test_feature);
    Scores(:,j) = score(:,2); 
end
[~,maxScore] = max(Scores,[],2);
decision = maxScore - 1;
x_svm = find(decision == test_LABELS);
acc_svm = length(x_svm)/length(test_LABELS)

% for KNN
KNN_predicted_labels = predict(knn_mdl,test_feature);
x_knn = find(KNN_predicted_labels == test_LABELS);
acc_knn = length(x_knn)/length(test_LABELS)

%% Generate Prediction on Project Data
% for SVM
Scores = zeros(length(project_LABELS),length(classes));
for j = 1:length(classes)
    [~,score] = predict(svm_mdls{j},project_feature);
    Scores(:,j) = score(:,2); 
end
[~,maxScore] = max(Scores,[],2);
svm_decision = maxScore - 1;

xlswrite('predicted.xlsx',svm_decision)