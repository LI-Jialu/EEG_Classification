function [EEG,LABELS] = OrgData(fileFolder,trial_num,t_pre,t_post)
    SampleRate = 256;
    channel_num = 16;
     
    dirOutput=dir(fullfile(fileFolder,'*.mat'));
    fileNames={dirOutput.name}';
    num_of_sets = length(fileNames);
    tp_each_trial = SampleRate*(t_post-t_pre);
    
    LABELS = [];         % labels for trials 
    EEG = [];   % data for trials

    for count = 1:num_of_sets
        load([fileFolder, char(fileNames(count))]);
        Temp_EEG = zeros(trial_num, tp_each_trial, channel_num);

        % denoise through eeglab
        EEGData = Denoise(EEGData,13,30);

        onset_stimuli = Stimulus_TimeMark(2:2:end);
        for i=1:channel_num
            for j=1:trial_num
                startPoint = floor(((onset_stimuli(j)+t_pre)*SampleRate+1));
                endPoint = floor((onset_stimuli(j)+t_post)*SampleRate);
                Temp_EEG(j,:,i)=EEGData(startPoint:endPoint,i);
            end
        end
        
        if exist('Stimulus_Type','var')
            Temp_Label = Stimulus_Type(1:trial_num);
        else
            Temp_Label = zeros(trial_num,1) - 1;
        end
        LABELS = [LABELS; Temp_Label];
        EEG = [EEG; Temp_EEG];

    end
    
end