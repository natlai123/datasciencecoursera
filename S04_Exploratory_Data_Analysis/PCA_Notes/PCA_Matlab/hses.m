function y=hses(PandL_data,cl)
% HSES_SIMPLE ES for specified confidence level
%
% Function estimates the ES of a portfolio using the historical simulation approach, 
% for specified confidence level and holding period implied by data frequency.
% 
% The first argument is a vector of daily portfolio P/L data and the second
% is a scalar confidence level. 
%
% Revised by Kevin Dowd, November 26th, 2001.
% *****************************************************************************
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
if max(cl_rows,cl_cols)>1
    error('Confidence level must be a scalar');
end
%
% Check that inputs obey sign and value restrictions
%
if cl>=1
    error('Confidence level must be less than 1');
end
if cl<=0
    error('Confidence level must be positive')
end
%
% VaR and ES estimation
%
index=n*cl;     % This putative index  value may or may not be an integer. 
%
% Need to consider each case in turn. 
%
% If index value is an integer, VaR follows immediately and then we estimate ES
%
if index-round(index)==0  
%
   var=losses_data(index); % HS VaR
   k=find(var<=losses_data);% Finds indices of tail loss data 
   tail_losses=losses_data(k); % Creates data set of tail loss observations
   es=mean(tail_losses);% ES
   y=es;
end
%
% If index not an integer, take VaR as linear interpolation of loss observations just above and below 'true' VaR
%, and take ES as linear interpolation of corresponding upper and lower ESs
%
if index-round(index)>0|index-round(index)<0 
        %
        % Deal with loss observation just above VaR to derive upper ES
        %
       upper_index=ceil(index);  
       upper_var=losses_data(upper_index); % Upper VaR
       upper_k=find(upper_var<=losses_data);% Finds indices of upper tail loss data 
       upper_tail_losses=losses_data(upper_k); % Creates data set of upper tail loss observations
       upper_es=mean(upper_tail_losses); % Upper es
       % 
       % Deal with loss observation just below VaR to derive lower ES
       %
       lower_index=ceil(index);  
       lower_var=losses_data(lower_index); % Lower VaR
       lower_k=find(lower_var<=losses_data);% Finds indices of lower tail loss data 
       lower_tail_losses=losses_data(lower_k); % Creates data set of lower tail loss observations
       lower_es=mean(lower_tail_losses); % Lower ES
        % 
        % If lower and upper indices are the same, ES is upper ES
        %
        if upper_index==lower_index
            y=upper_es;
        end
        %
        % If lower and upper indices different, ES is weighted average of upper and lower ESs
        %
       if upper_index~=lower_index
            %
            % Weights attached to upper and lower ESs
            %
            lower_weight=(upper_index-index)/(upper_index-lower_index); % weight on lower_var
            upper_weight=(index-lower_index)/(upper_index-lower_index); % weight on upper_var
            % 
            % Finally, the weighted, ES as a linear interpolation of upper and lower ESs
            %
            y=lower_weight*lower_es+upper_weight*upper_es;   % ES
        end
    end
