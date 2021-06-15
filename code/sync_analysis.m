%%
s_sync = load_xdf('liveamp_with_markers.xdf');

%%
s_no_clock_sync = load_xdf('liveamp_with_markers.xdf', 'HandleClockSynchronization', false);
s_no_dejitter = load_xdf('liveamp_with_markers.xdf', 'HandleJitterRemoval', false);

%%
for n=1:length(s_sync)
    if(strcmp(s_sync{n}.info.type, 'EEG'))
        eeg_idx = n;
    end
    if(strcmp(s_sync{n}.info.type, 'Markers'))
        mrkr_idx = n;
    end
end

ts_eeg_sync = s_sync{eeg_idx}.time_stamps;
ts_mrkr_sync = s_sync{mrkr_idx}.time_stamps;
first_ts = min(ts_eeg_sync(1), ts_mrkr_sync(1)); 
ts_eeg_sync = ts_eeg_sync - first_ts; 
ts_mrkr_sync = ts_mrkr_sync - first_ts; 

ts_eeg_no_clock_sync = s_no_clock_sync{eeg_idx}.time_stamps;
ts_mrkr_no_clock_sync = s_no_clock_sync{mrkr_idx}.time_stamps;

ts_eeg_no_dejitter = s_no_dejitter{eeg_idx}.time_stamps;
ts_mrkr_no_dejitter = s_no_dejitter{mrkr_idx}.time_stamps;
first_ts = min(ts_eeg_no_dejitter(1), ts_mrkr_no_dejitter(1)); 
ts_eeg_no_dejitter = ts_eeg_no_dejitter - first_ts;
ts_mrkr_no_dejitter = ts_mrkr_no_dejitter - first_ts; 

%%
figure;
subplot(3,1,1)
plot(ts_eeg_sync(1:2499), diff(ts_eeg_sync(1:2500)))
for n=1:2
    xline(ts_mrkr_sync(n), 'color', 'r');
end
ylabel('sample interval (s)', 'fontsize', 11);
title('default');

subplot(3,1,2)
plot(ts_eeg_no_clock_sync(1:2499), diff(ts_eeg_no_clock_sync(1:2500)))
for n=1:2
    xline(ts_mrkr_no_clock_sync(n), 'color', 'r');
end
title('no clock sync');

subplot(3,1,3)
plot(ts_eeg_no_dejitter(1:2499), diff(ts_eeg_no_dejitter(1:2500)))
for n=1:2
    xline(ts_mrkr_no_dejitter(n), 'color', 'r');
end
xlabel('time (s)', 'fontsize', 11);
title('no dejitter');
sgtitle('LiveAmp data + python Markers');
legend('diff(time\_stamps) from LiveAmp', 'Markers');
%%
