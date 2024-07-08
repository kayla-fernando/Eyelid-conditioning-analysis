%% Prompts to preprocess eyelid conditioning data %%

% Written by Kayla Fernando (10/27/22)

prompt = input('Does this mouse have multiple sessions at any point during training? ("1" for yes, "0" for no) ');
switch prompt
    % If mouse has no multiple sessions at any point during training:
    case 0 
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces
                [cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,files,directory,trials,date] = ...
                    getAllEyelidTracesVarISI(mouse,basepath);
                % Generate a list of which rig was used on each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s");
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
                % Rename eyelid traces
                [CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                    eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                    renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                    rig,files,directory,1);
                % Write text file
                writematrix([prompt prompt1],'promptData.txt');
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session
                        [cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,cs1paired_all,cs1catch_all,cs2paired_all,cs2catch_all,...
                            files,directory,trials,date] = getAllEyelidTracesVarISI(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                        [CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                            eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                            renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                            rig,files,directory,1);
                        % Write text file
                        writematrix([prompt prompt1 prompt2],'promptData.txt');
                    % Black rig throughout all of training
                    case 1         
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session
                        [cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,cs1paired_all,cs1catch_all,cs2paired_all,cs2catch_all,...
                            files,directory,trials,date] = getAllEyelidTracesVarISI(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                        [CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                            eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                            renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                            rig,files,directory,1);
                        % Write text file
                        writematrix([prompt prompt1 prompt2],'promptData.txt');
                end
        end
    % If mouse has multiple sessions at any point during training:    
    case 1
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces, combining multiple sessions on a given day if necessary
                [cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,files,directory,trials,date] = ...
                    getAllEyelidTraces_mSessionsVarISI(mouse,basepath);
                % Generate a list of which rig was used for each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s");
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
                % Rename eyelid traces
                [CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                    eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                    renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                    rig,files,directory,1);
                % Write text file
                writematrix([prompt prompt1],'promptData.txt');
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,files,directory,trials,date] = ...
                            getAllEyelidTraces_mSessionsVarISI(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                        [CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                            eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                            renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                            rig,files,directory,1);
                        % Write text file
                        writematrix([prompt prompt1 prompt2],'promptData.txt');
                  % Black rig throughout all of training
                    case 1
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,files,directory,trials,date] = ...
                            getAllEyelidTraces_mSessionsVarISI(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                        [CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                            eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                            renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                            rig,files,directory,1);
                        % Write text file
                        writematrix([prompt prompt1 prompt2],'promptData.txt');
              end
        end    
end

promptData = readmatrix('promptData.txt');
promptData = num2str(promptData);