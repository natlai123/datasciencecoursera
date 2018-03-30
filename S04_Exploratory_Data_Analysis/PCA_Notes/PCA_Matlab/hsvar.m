function y=hsvar(PandL_data,cl)
% HSVAR VaR for specified confidence level(s)
%
% Function estimates the VaR of a portfolio using the historical simulation approach, 
% for specified range of confidence levels and holding period implied by data frequency.
% 
% The first argument is a vector of daily portfolio P/L data and the second
% is a vector VaR confidence levels. 
%
% Revised by Kevin Dowd, November 26th, 2001.
% **********************************************************************
% 
% Determine if there are two arguments, and ensure that arguments
% are read as intended
%
if nargin<2,
    error('Too few arguments');
end
if nargin>2,
    error('Too many arguments');
end
if nargin ==2
    unsorted_loss_data=-PandL_data;   % Derives L/P data from inputted P/L data
    losses_data=sort(unsorted_loss_data); % Puts losses in ascending order
    n=length(losses_data);
end
% 
% Check that inputs have correct dimensions
%
[cl_rows,cl_cols]=size(cl);
if min(cl_rows,cl_cols)>1
    error('Confidence level must be a vector');
end
%
% Check that inputs obey sign and value restrictions
%
if max(cl)>=1
    error('Confidence level must be less than 1');
end
% 
% To check that cl is read as a scalar or row vector as required
%
if cl_rows>cl_cols
    cl=cl';
end
%
% VaR estimation
%
length(cl);
i=1:length(cl);
    %
    index=cl*n;     % This putative index value may or may not be an integer
    %
    % If index value is an integer, VaR follows immediately
    %
    if index-round(index)==0    % If index value is an integer, VaR and ETL follow immediately
        y(i)=losses_data(index); % HS VaR
    end
    %
    % If index not an integer, take VaR as linear interpolation of loss observations just above and below 'true' VaR
    %
    if index-round(index)>0|index-round(index)<0 
        %
        % Deal with loss observation just above VaR 
        %
        upper_index=ceil(index);  
        upper_var=losses_data(upper_index); % Loss observation just above VaR or upper VaR
        % 
        % Deal with loss observation just below VaR 
        %
        lower_index=floor(index);
        lower_index
        lower_var=losses_data(lower_index); % Loss observation just below VaR or lower VaR
        %
        % If lower and upper indices are the same, VaR is upper VaR
        %
        if upper_index==lower_index
            y=upper_var;
        end
        %
        % If lower and upper indices different, VaR is weighted average of upper and lower VaRs
        %
       if upper_index~=lower_index
            %
            % Weights attached to upper and lower VaRs
            %
            lower_weight=(upper_index-index)/(upper_index-lower_index); % weight on lower_var
            upper_weight=(index-lower_index)/(upper_index-lower_index); % weight on upper_var
            % 
            % Finally, the weighted, VaR as a linear interpolation of upper and lower VaRs
            %
            y=lower_weight*lower_var+upper_weight*upper_var;   % VaR
        end
    end
