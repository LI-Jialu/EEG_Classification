function eeg = Denoise(EEG,low,high)
    EEG = EEG';
    EEG = EEG * 10^6;
    EEG = pop_importdata('dataformat','matlab','nbchan',16,'data',EEG,'setname','train1','srate',256,'pnts',0,'xmin',0);
    EEG = eeg_checkset( EEG );
    EEG = pop_reref( EEG, []);
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, 'locutoff',low,'hicutoff',high,'plotfreqz',1);
    EEG = eeg_checkset( EEG );
    EEG = eeg_checkset( EEG );
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
    EEG = eeg_checkset( EEG );
    EEG = eeg_checkset( EEG );
    
    close all
    
    eeg = EEG.data;
    eeg = eeg';
    
end