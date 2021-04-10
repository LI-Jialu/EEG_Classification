%% BMEG3330 FINAL PROJECT GROUP 1

%% Organizing training data
train_folder = 'training_data\';

[EEG,LABELS] = OrgData(train_folder,30,-3.5,1.5);

%% Feature Extraction
training_feature = ExFeature(EEG);

%% Model Trainning
rng(1);
% -------------train the NN classifier--------------
nn_mdl = patternnet([120,4]);
onehot_LABELS = (LABELS==0:3);
nn_mdl = train(nn_mdl,training_feature',onehot_LABELS');
% ---------------------------------------------------

% -------------train  LDA classifier--------------
lda_mdl = fitcdiscr(training_feature,LABELS);
% ---------------------------------------------------

% -------------train the SVM classifier--------------
% svm_mdls = cell(4,1);
% classes = unique(LABELS);
% rng(1); % For reproducibility
% SVM_predicted_labels = [];
% for j = 1:length(classes)
%     indx = strcmp(string(LABELS),string(classes(j)));    % Create binary classes for each classifier
%     svm_mdls{j} = fitcsvm(training_feature,indx,'ClassNames',[false true] ,'Standardize',true,...
%         'KernelFunction','linear','KernelScale','auto'); 
% %         SVM_predicted_labels = [SVM_predicted_labels predict(svm_mdls{j},test_feature)];
% end 
% 
% ---------------------------------------------------

% ------------train the KNN classifier--------------
knn_mdl = fitcknn(training_feature,LABELS,'NumNeighbors',5,'Standardize',1,'Distance','euclidean');
% KNN_predicted_labels = predict(knn_mdl,training_feature)
% ---------------------------------------------------



%% test data

test_folder = 'test_data\';

[EEG,LABELS] = OrgData(test_folder,30,-3,1.5);

test_feature = ExFeature(EEG);
test_feature = training_feature;


%% validation
% for NN 
NN_predicted_labels = nn_mdl(test_feature');
nnclasses = vec2ind(NN_predicted_labels);
decision = nnclasses - 1;
decision = decision';
x_nn = find(decision == LABELS);
acc_nn = length(x_nn)/length(LABELS)

% for LDA
LDA_predicted_labels = predict(lda_mdl,test_feature);
x_lda = find(LDA_predicted_labels == LABELS);
acc_lda = length(x_lda)/length(LABELS)

% for SVM
% scores = zeros(size(test_feature,1),length(classes));
% for j = 1:length(classes)
%     [~,score] = predict(SVMModels{j},test_feature);
%     Scores(:,j) = score(:,2);
% %     indx = strcmp(string(LABELS),string(classes(j)));    % Create binary classes for each classifier
% %         svm_mdls{j} = fitcsvm(test_feature,indx,'ClassNames',[false true] ,'Standardize',true,...
% %           'KernelFunction','linear','KernelScale','auto','Standardize',true); 
% %         SVM_predicted_labels = [SVM_predicted_labels predict(svm_mdls{j},test_feature)];
% end 
% [~,maxScore] = max(Scores,[],2);
% x_svm = (SVM_predicted_labels) == onehot_LABELS;
% acc_svm = length(x_svm)/length(LABELS)

% % for KNN
% KNN_predicted_labels = predict(knn_mdl,test_feature);
% x_knn = find(KNN_predicted_labels == LABELS);
% acc_knn = length(x_knn)/length(LABELS)






