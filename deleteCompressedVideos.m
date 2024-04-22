%% Delete compressed videos after analysis to save space on Isilon %%

% Assumes a mouse is completely finished with training

% Written by Kayla Fernando (4/19/24)

close all
clear all
clc

experiment = 'ASTN2';
mouse = {'KF49'; 'KF50'; 'KF51';
         'KF52'; 'KF58'; 'KF59';
         'KF60'; 'KF61'; 'KF62';
         'KF63'; 'KF64'; 'KF65';
         'KF66'; 'KF67'; 'KF68';
         'KF70'; 'KF71'; 'KF72'};
basepath = ['Z:\\home\kayla\Eyelid conditioning\' experiment '\'];

for n = 1:length(mouse)
    directory = dir([basepath mouse{n}]);
    for ii = 1:numel(directory(:,1))
        filename = [basepath mouse{n} '\' directory(ii).name '\compressed'];
        files{ii} = filename;
        if strcmp(files{ii},[basepath mouse{n} '\.\compressed'])|strcmp(files{ii},[basepath mouse{n} '\..\compressed'])
            files{ii} = [];
        end
        files = files(~cellfun('isempty',files));
    end
    
    disp('Deleting video files')

    for jj = 1:length(files)
        cd(string(files(jj)));
        delete *.mp4
    end
end
