
sampling_rate = 360; % Sample rate of 360 samples per second

% Create time vector
num_samples = length(noisySig); 
time = (0:num_samples-1) / sampling_rate; % Time vector in seconds
%%
% Plot ECG signals

figure;
subplot(2,1,1);
plot(time, noisySig, 'b', 'LineWidth', 1.5); % Plot first signal in blue
% Add labels and title
xlabel('Time (seconds)');
ylabel('Voltage (mV)');
title('Noisy Signals');
grid on;
%hold on;
subplot(2,1,2);
plot(time, origSig, 'r', 'LineWidth', 1.5); % Plot second signal in red
%hold off;

% Add labels and title
xlabel('Time (seconds)');
ylabel('Voltage (mV)');
title('Original Signals');


% Adjust plot settings if necessary
grid on; % Add grid

%--------------FFT signal for the noisy signal-------------------------
% Compute the FFT
fft_signal = fft(noisySig);

% Compute the frequency axis
frequencies = (-num_samples/2 : num_samples/2 - 1) * sampling_rate / num_samples;

% Compute the shifted spectrum
fft_signal_shifted = fftshift(fft_signal);

% Plot the shifted spectrum
figure;
plot(frequencies, abs(fft_signal_shifted));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Fourier Transform of Noisy Signal (Shifted Spectrum)');

%------------High frequency noise and main hums noise detection--------
% Find the index corresponding to 60 Hz (assuming mains hum frequency)
grid_frequency = 60; % Frequency of the electricity grid (Hz)
[~, grid_frequency_index] = min(abs(frequencies - grid_frequency)); % Find the closest frequency index

% Get the magnitude of the FFT at the mains hum frequency
mains_hum_magnitude_pos = abs(fft_signal_shifted(grid_frequency_index));

% Calculate the index corresponding to the negative frequency counterpart
negative_grid_frequency_index = num_samples - grid_frequency_index + 2; % +2 to account for 0 Hz

% Get the magnitude of the FFT at the negative mains hum frequency
mains_hum_magnitude_neg = abs(fft_signal_shifted(negative_grid_frequency_index));

hold off;
% Find peaks in the spectrum
[peaks, peak_indices] = findpeaks(abs(fft_signal_shifted), 'MinPeakHeight', max(abs(fft_signal_shifted))/2);

% Find the index of the highest peak
[~, highest_peak_index] = max(peaks);


%-------------Determine the cut-off frequency and label in graph-----------

% Identify the cutoff frequencies visually from the plot
cutoff_frequency_hz = 90; % Adjust this value based on visual inspection
negative_cutoff_frequency_hz = -90; % Adjust this value based on visual inspection
cutoff_frequency_normalized = cutoff_frequency_hz / sampling_rate; % Normalized cutoff frequency
negative_cutoff_frequency_normalized = negative_cutoff_frequency_hz / sampling_rate; % Normalized cutoff frequency

fprintf('Cutoff Frequency: %.2f Hz\n', cutoff_frequency_hz);
fprintf('Normalized Cutoff Frequency: %.2f\n', cutoff_frequency_normalized);

% Plot the chosen cutoff frequency on the FFT plot with legends
figure;
plot(frequencies, abs(fft_signal_shifted));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Fast Fourier Transform of Noisy Signal');
hold on;
plot([cutoff_frequency_hz, cutoff_frequency_hz], [0, max(abs(fft_signal_shifted))], 'r--');
plot([negative_cutoff_frequency_hz, negative_cutoff_frequency_hz], [0, max(abs(fft_signal_shifted))], 'r--');
%plot(frequencies(peak_indices(highest_peak_index)), peaks(highest_peak_index), 'ro', 'MarkerSize', 10);
plot(frequencies(grid_frequency_index), mains_hum_magnitude_pos, 'go', 'MarkerSize', 10);
plot(frequencies(negative_grid_frequency_index), mains_hum_magnitude_neg, 'go', 'MarkerSize', 10);
legend('FFT', 'Cutoff Frequency', 'Negative Cutoff Frequency', 'Main hums', 'Location', 'northeast');
hold off;
grid on;

%-------applying the FIR and IIR filter-----------------------------------
% Design FIR filter using fir1
%%
fir_order = 5; % Maximum order of 5
fir_filter = fir1(fir_order, cutoff_frequency_normalized, 'low');

% Display FIR filter coefficients
disp('FIR Filter Coefficients:');
disp(fir_filter);

% Design IIR filter using butter
[b, a] = butter(5, cutoff_frequency_normalized, 'low');

% Display IIR filter coefficients
disp('IIR Filter Coefficients:');
disp('Numerator (b):');
disp(b);
disp('Denominator (a):');
disp(a);

% Calculate the frequency response of the FIR filter
[H_fir, freq] = freqz(fir_filter, 1, 1024, sampling_rate);

% Calculate the frequency response of the IIR filter
[H_iir, freq] = freqz(b, a, 1024, sampling_rate);

% Plot frequency responses
figure;
subplot(2,1,1);

plot(freq, abs(H_fir));
title('Frequency Response of FIR Filter');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
grid on;

subplot(2,1,2);
plot(freq, abs(H_iir));
title('Frequency Response of IIR Filter');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
grid on;

% Apply FIR filter to noisy signal
filtered_signal_fir = filter(fir_filter, 1, noisySig);

% Apply IIR filter to noisy signal
filtered_signal_iir = filter(b, a, noisySig);
%%
% Plot original and filtered signals
figure;
subplot(3,1,1);
plot(time, origSig);
title('Original Signal');
xlabel('Time');
ylabel('Voltage (mV)');
grid on;

subplot(3,1,2);
plot(time, filtered_signal_fir);
title('Filtered Signal - FIR');
xlabel('Time');
ylabel('Voltage (mV)');
grid on;

subplot(3,1,3);
plot(time, filtered_signal_iir);
title('Filtered Signal - IIR');
xlabel('Time');
ylabel('Voltage (mV)');
grid on;
%%

% Apply bandpass filter to remove noise
f_low = 0.5; % Hz
f_high = 40; % Hz
[b, a] = butter(5, [f_low, f_high]/(sampling_rate/2), 'bandpass');
filtered_signal = filter(b, a, noisySig);

% Detect R-peaks for segmentation
threshold = 0.5 * max(filtered_signal); % Adjust the threshold as needed
[~, r_locs] = findpeaks(filtered_signal, 'MinPeakHeight', threshold);

% Normalize amplitude of filtered ECG signal to range [-1, 1]
normalized_signal = (filtered_signal - min(filtered_signal)) / (max(filtered_signal) - min(filtered_signal)) * 2 - 1;

% Plot 5 seconds of the normalized ECG signal
figure;
t_5sec = time(time<=5); % Adjust time vector to only span first 5 seconds
plot(t_5sec, filtered_signal(1:length(t_5sec)));
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('PQRST ECG Signal');
grid on;

% Detect P-wave peaks
p_locs = zeros(size(r_locs));
for i = 1:length(r_locs)
    if i > 1
        % Find the maximum positive peak before the R-peak
        [~, p_locs(i)] = max(filtered_signal(r_locs(i-1):r_locs(i)));
        p_locs(i) = p_locs(i) + r_locs(i-1) - 1;
    end
end

% Detect QRS peaks
q_locs = r_locs; % For simplicity, assuming Q peaks align with R peaks
s_locs = zeros(size(r_locs));
for i = 1:length(r_locs)
    if i < length(r_locs)
        % Find the minimum peak between R and the next R
        [~, s_locs(i)] = min(filtered_signal(r_locs(i):r_locs(i+1)));
        s_locs(i) = s_locs(i) + r_locs(i) - 1;
    else
        % Last R peak, set S peak to the end of the signal
        s_locs(i) = length(filtered_signal);
    end
end

% Detect T-wave peaks
t_locs = zeros(size(r_locs));
for i = 1:length(r_locs)
    if i < length(r_locs)
        % Find the maximum positive peak after the R-peak
        [~, t_locs(i)] = max(filtered_signal(r_locs(i):r_locs(i+1)));
        t_locs(i) = t_locs(i) + r_locs(i) - 1;
    else
        % Last R peak, set T peak to the end of the signal
        t_locs(i) = length(filtered_signal);
    end
end

try
    % Plot ECG signal with P-wave peaks
    figure;
    plot(t_5sec, normalized_signal(1:length(t_5sec)));
    hold on;
    plot(p_locs, normalized_signal(p_locs), 'go'); % P-wave peaks
    hold off;
    xlabel('Sample Index');
    ylabel('Amplitude');
    title('P-Wave Peak Indices on ECG Signal');
catch exception
    disp(exception.message);
end



% Visualize peak indices against time
figure;
plot(time, filtered_signal);
hold on;
plot(time(r_locs), filtered_signal(r_locs), 'ro'); % R peaks
plot(time(q_locs), filtered_signal(q_locs), 'bo'); % Q peaks
plot(time(s_locs), filtered_signal(s_locs), 'ko'); % S peaks
plot(time(t_locs), filtered_signal(t_locs), 'mo'); % T peaks
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('PQRST ECG Signal');
legend('ECG Signal', 'R Peaks', 'Q Peaks', 'S Peaks', 'T Peaks');
grid on;