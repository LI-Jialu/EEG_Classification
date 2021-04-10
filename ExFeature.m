function Feature = ExFeature(EEG)
%EXFEATURE 此处显示有关此函数的摘要
%   此处显示详细说明
    trial_num = size(EEG,1);
    channel_num = size(EEG,3);
    band_power = zeros(trial_num,channel_num);   	% the shape of [trial_num,band_num,channel_num]

    for i = 1:trial_num
        for j = 1:channel_num
            band_power(i,j) = mean(EEG(i,:,j).^2);
%             if j==13 || j == 14 
%                 band_power(i,j) = mean(EEG(i,:,j).^2)*0.6;
%             elseif j == 9 || j == 10 || j == 16
%                 band_power(i,j) = mean(EEG(i,:,j).^2)*1.4;
%             else
%                 band_power(i,j) = mean(EEG(i,:,j).^2);
%             end
        end
    end

    Feature = band_power;
end

