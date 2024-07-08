function varargout = renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,rig,files,directory,first_analysis_day)
% Written by Kayla Fernando (7/8/22)

for k = first_analysis_day:length(files)
    % CS1-US trials will become 'CS1_conditioning_trials'
    eyelid3_5_trials{k} = cs1paired_all_cell{k}; 
        CS1_conditioning_trials{k} = mean(eyelid3_5_trials{k});
    
    % CS1-catch trials will become 'CS1_catch_trials'
    eyelid3_0_trials{k} = cs1catch_all_cell{k}; 
            if isempty(eyelid3_0_trials{k})
                eyelid3_0_trials{k} = zeros(1,((strcmp(rig{k},'black')==1)*334 + (strcmp(rig{k},'blue')==1)*200));
            end
        CS1_catch_trials{k} = mean(eyelid3_0_trials{k});
            if numel(CS1_catch_trials{k}) == 1;
                CS1_catch_trials{k} = eyelid3_0_trials{k};
            end
    
    % CS2-US trials will become 'CS2_conditioning_trials'
    eyelid3_6_trials{k} = cs2paired_all_cell{k}; 
        CS2_conditioning_trials{k} = mean(eyelid3_6_trials{k});
    
    % CS2-catch trials will become 'CS2_catch_trials'
    eyelid3_00_trials{k} = cs2catch_all_cell{k}; 
            if isempty(eyelid3_00_trials{k})
                eyelid3_00_trials{k} = zeros(1,((strcmp(rig{k},'black')==1)*334 + (strcmp(rig{k},'blue')==1)*200));
            end
        CS2_catch_trials{k} = mean(eyelid3_00_trials{k});
            if numel(CS2_catch_trials{k}) == 1;
                CS2_catch_trials{k} = eyelid3_00_trials{k};
            end
            
    % Get the dates
    date{k} = directory(k+2).name; 

end

if nargout > 0 
    varargout{1} = CS1_conditioning_trials;
    varargout{2} = CS1_catch_trials;
    varargout{3} = CS2_conditioning_trials;
    varargout{4} = CS2_catch_trials;
    varargout{5} = eyelid3_5_trials;
    varargout{6} = eyelid3_0_trials;
    varargout{7} = eyelid3_6_trials;
    varargout{8} = eyelid3_00_trials;
    varargout{9} = files;
    varargout{10} = date;
end