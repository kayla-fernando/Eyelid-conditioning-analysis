function varargout = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,first_analysis_day)
% Written by Kayla Fernando (7/8/22)

for k = first_analysis_day:length(files)
    % CS-US trials will become 'conditioning_trials'
    eyelid3_5_trials{k} = cspaired_all_cell{k}; 
        conditioning_trials{k} = mean(eyelid3_5_trials{k});
    
    % US-only trials will become 'calib_trials'
    eyelid3_7_trials{k} = usonly_all_cell{k}; 
            if isempty(eyelid3_7_trials{k})
                eyelid3_7_trials{k} = zeros(1,((strcmp(rig{k},'black')==1)*334 + (strcmp(rig{k},'blue')==1)*200));
            end
        calib_trials{k} = mean(eyelid3_7_trials{k});
            if numel(calib_trials{k}) == 1;
                calib_trials{k} = eyelid3_7_trials{k};
            end
    
    % CS-catch trials will become 'catch_trials'
    eyelid3_0_trials{k} = cscatch_all_cell{k}; 
            if isempty(eyelid3_0_trials{k})
                eyelid3_0_trials{k} = zeros(1,((strcmp(rig{k},'black')==1)*334 + (strcmp(rig{k},'blue')==1)*200));
            end
        catch_trials{k} = mean(eyelid3_0_trials{k});
            if numel(catch_trials{k}) == 1;
                catch_trials{k} = eyelid3_0_trials{k};
            end
            
    % Get the dates
    date{k} = directory(k+2).name; 

end

if nargout > 0 
    varargout{1} = conditioning_trials;
    varargout{2} = calib_trials;
    varargout{3} = catch_trials;
    varargout{4} = eyelid3_5_trials;
    varargout{5} = eyelid3_7_trials;
    varargout{6} = eyelid3_0_trials;
    varargout{7} = files;
    varargout{8} = date;
end