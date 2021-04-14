function Feature = ExFeature(EEG)
    trial_num = size(EEG,1);
    channel_num = size(EEG,3);
    band_power = zeros(trial_num,channel_num*2);   	% the shape of [trial_num,band_num,channel_num]

    for i = 1:trial_num
        for j = 1:channel_num
            band_power(i,2*j-1) = mean(EEG(i,:,j).^2);
            band_power(i,2*j) = std(EEG(i,:,j)); 
        end
    end 
    Feature = band_power;
end

