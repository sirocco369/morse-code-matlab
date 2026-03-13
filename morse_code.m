% ---------------------------------------------------------
% Project: Morse Code Signal Generation using MATLAB
% Author: Rithika (ECE)
% ---------------------------------------------------------
% This program converts a user-entered text message (A–Z, 0–9)
% into Morse code and generates a corresponding
% pulse signal representation.
% ---------------------------------------------------------

clc; clear; close all;

% Define Morse code for all alphabets and digits using containers.Map
keys = { 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z', ...
         '1','2','3','4','5','6','7','8','9','0' };
values = {'.-','-...','-.-.','-..','.','..-.','--.','....','..','.---','-.-','.-..','--','-.','---','.--.','--.-','.-.','...','-','..-','...-','.--','-..-','-.--','--..', ...
          '.----','..---','...--','....-','.....','-....','--...','---..','----.','-----' };
Morse = containers.Map(keys, values);

% ---------------- User Input ----------------
message = input('Enter the message to convert to Morse code: ', 's');
% --------------------------------------------

% Signal parameters
Fs = 1000;                 % Sampling frequency
dot_duration = 0.1;        % Duration of a dot (in seconds)
dash_duration = 3*dot_duration;
gap = dot_duration;        % Gap between elements (dot/dash)
letter_gap = 3*dot_duration; % Gap between letters
word_gap = 7*dot_duration;   % Gap between words

% Create time vectors
t_dot = 0:1/Fs:dot_duration;
t_dash = 0:1/Fs:dash_duration;

% Define pulse shapes
dot = ones(size(t_dot));       % Short pulse
dash = ones(size(t_dash));     % Long pulse
short_gap = zeros(size(0:1/Fs:gap));        % Between dot/dash
medium_gap = zeros(size(0:1/Fs:letter_gap)); % Between letters
long_gap = zeros(size(0:1/Fs:word_gap));     % Between words

% Initialize output signal
signal = [];

% Generate Morse signal
for k = 1:length(message)
    ch = upper(message(k));
    if ch == ' '
        signal = [signal long_gap]; % Space between words
        continue;
    end
    
    if isKey(Morse, ch)
        code = Morse(ch);
        for i = 1:length(code)
            if code(i) == '.'
                signal = [signal dot short_gap];
            elseif code(i) == '-'
                signal = [signal dash short_gap];
            end
        end
        signal = [signal medium_gap]; % Space between letters
    else
        % For unsupported characters, add silence of a word gap
        signal = [signal long_gap];
    end
end

% Time axis for plotting
time = (0:length(signal)-1)/Fs;

% Plot the generated Morse code signal
figure;
plot(time, signal, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Amplitude');
title(['Morse Code Signal for Message: "' upper(message) '"']);
grid on;

% Optional: Play the Morse code sound
sound(signal, Fs);
