function [response, rt, exitflag] = ...
    wrapper_keyProcess(keys_pressed, press_times, trial_start, expt)

% RT is always based on first key press

% keyboard input for arrow keys is weird
switch expt
    case 'occularDominance'
        if any(keys_pressed == 102)
            keys_pressed = 39; %RightArrow
            rt = press_times(102) - trial_start;
        elseif any(keys_pressed == 100)
            keys_pressed = 37; %LeftArrow
            rt = press_times(100) - trial_start;
        else
            keys_pressed = keys_pressed(1);
            rt = press_times(keys_pressed) - trial_start;
        end
    otherwise
        rt = press_times(keys_pressed(1)) - trial_start;
end

% exit flag and empty responses
switch keys_pressed(end)
    case KbName('Return') 
        exitflag = {'Return'};
        keys_forResp = keys_pressed(1:end-1);
        emptyResp = {'Return'};
    case KbName('Escape')
        exitflag = {'ESCAPE'};
        keys_forResp = keys_pressed(1:end-1);
        emptyResp = {'ESCAPE'};
    otherwise
        exitflag = {'OK'};
        keys_forResp = keys_pressed;
        emptyResp = {''};
end

response = cleanResp(keys_forResp, keys_pressed, emptyResp);

end


function response = cleanResp(keys_forResp, keys_pressed, emptyResp)

% this will return empty matrix if not found
space_position = find(keys_pressed==KbName('space'));

% remove spaces so that they're not included in the response (KbName
% outputs the word 'space')
keys_forResp(space_position) = [];

% handle empty responses
if isempty(keys_forResp)
    response = emptyResp;
else
    response = {cell2mat(arrayfun(@(x) KbName(x), keys_forResp, 'UniformOutput',false))};
end

% if there were any spaces pressed, put them back in as actual spaces
if ~isempty(space_position)
    for space = 1:length(space_position)
        response{1} = [response{1}(1:space_position(space)-1), ' ',...
            response{1}(space_position(space):end)];
    end
end



end