clear
%% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();

% make a new stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'linear_vals','EEG',1,100,'cf_float32','sdfwerr32432');
marker_info = lsl_streaminfo(lib, 'linear_mrkrs', 'Markers', 1,0,'cf_string', 'mrkr1234');
disp('Opening an outlet...');
outlet = lsl_outlet(info);
marker_outlet = lsl_outlet(marker_info);

%%
% send data into the outlet, sample by sample
disp('Now transmitting data...');
val = zeros(1,1);
sample_interval = [1/100,1/50];
idx = 0;
now = lsl_local_clock(lib);
switch_offset = 10;
switch_span = 10;
random_val = randn;
switch_time = switch_offset + switch_span * random_val;

while true
    outlet.push_sample(val);
    pause(.01)
    pause(sample_interval(idx + 1));
    if lsl_local_clock(lib) - now > switch_time
        marker_outlet.push_sample(val);
        switch_time =  switch_offset + switch_span * random_val;
        now = lsl_local_clock(lib);
        idx = mod((idx + 1),2);
        disp(sprintf("switching to sampling interval %1.3f", sample_interval(idx+1))); 
    end
    val(1) = val(1) + 1;
end