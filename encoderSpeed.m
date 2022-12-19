%% Encoder speed

% Written by Kayla Fernando (12/14/22)

clear all
close all
clc

mouse = 'KF72'; 
basepath = 'Y:\\home\kayla\Eyelid conditioning\';
cyclesPerRev = 32; % cycles per revolution for US Digital H5-32-NE-S encoder
d = 14; % diameter of running wheel in cm
sections = 16; % split the wheel into n number of sections
encodingFactor = 1; % LabJack U6 default; influences encoder resolution
    % 1 if only counting rising phase of pin A
    % 2 if rising & falling of A 
    % 4 if rising & falling of A and rising & falling of B

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess

r = d/2; % radius in cm
centralAngle = (2*pi)/sections; % radians traversed in 1 section
arcLength = r*centralAngle; % distance traveled in 1 section in cm
revDistance = arcLength*sections; % distance traveled in 1 revolution in cm
countsPerRev = cyclesPerRev*encodingFactor; % counts per revolution; NOTE: this value changes subsequent calculations

for k = 1:length(files)
    n = input(['Counter on ' num2str(date{k}) ': ']);
    counts(k) = n; 
    revolutions(k) = counts(k)/countsPerRev; % number of revolutions at this resolution
    distance(k) = (revolutions(k)*revDistance)/100; % total distance traveled in m
    time(k) = 3600; % 1 hr training session in s
    speed(k) = distance(k)/time(k); % average speed per session in m/s
end

avgspeed = mean(speed) % average speed over all sessions in m/s