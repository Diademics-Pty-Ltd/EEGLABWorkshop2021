%% load file with and without dejittering
s = load_xdf('changing_srate.xdf');
s_no_jitter = load_xdf('changing_srate.xdf', 'HandleJitterRemoval', false);


%% analyze
for n=1:length(s)
    if strcmp(s{n}.info.type, 'Markers')
        mrkr_idx = n;
    end
    if strcmp(s{n}.info.type, 'EEG')
        eeg_idx = n;
    end
end

first_ts = min(s{mrkr_idx}.time_stamps(1), s{eeg_idx}.time_stamps(1));
first_ts_no_jitter = min(s_no_jitter{mrkr_idx}.time_stamps(1), s_no_jitter{eeg_idx}.time_stamps(1));
mrkrs_as_numbers = []
for n=1:length(s{mrkr_idx}.time_series)
    mrkrs_as_numbers(n) = str2double(s{mrkr_idx}.time_series(n))
end
ts_diffs=[]
for n=1:length(mrkrs_as_numbers)
    ts_idx = find(s{eeg_idx}.time_series==mrkrs_as_numbers(n))
    ts_diffs(n) = s{mrkr_idx}.time_stamps(n) - s{eeg_idx}.time_stamps(ts_idx);
end
%%
figure;
subplot(2,2,1)
plot(s{eeg_idx}.time_stamps-first_ts, s{eeg_idx}.time_series, '*', 'linewidth', 1);
hold
plot(s{mrkr_idx}.time_stamps-first_ts, mrkrs_as_numbers, 'o', 'linewidth', 1);
ylabel('data values (counting samples)', 'fontsize', 13)
subplot(2,2,3)
plot(s{eeg_idx}.time_stamps(1:end-1)-first_ts, diff(s{eeg_idx}.time_stamps));
hold
for n=1:length(s{mrkr_idx}.time_stamps)
   xline(s{mrkr_idx}.time_stamps(n)-first_ts, 'color', 'red', 'linewidth', 1); 
end
ylabel('sample interval (s)');

subplot(2,2,2)
plot(s_no_jitter{eeg_idx}.time_stamps-first_ts_no_jitter, s_no_jitter{eeg_idx}.time_series, '*', 'linewidth', 1);
hold
plot(s{mrkr_idx}.time_stamps-first_ts_no_jitter, mrkrs_as_numbers, 'o', 'linewidth', 1);
 
subplot(2,2,4)
plot(s_no_jitter{eeg_idx}.time_stamps(1:end-1)-first_ts_no_jitter, diff(s_no_jitter{eeg_idx}.time_stamps),'linewidth', 1);
hold
for n=1:length(s{mrkr_idx}.time_stamps)
   xline(s{mrkr_idx}.time_stamps(n)-first_ts_no_jitter, 'color', 'red', 'linewidth', 1); 
end
xlabel('time (seconds)');
