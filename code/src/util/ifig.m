%% IFig - An Interactive figure exporter
% Based on
% https://interfacegroup.ch/preparing-matlab-figures-for-publication/

%% Init
% Options
opts = struct;
opts.fontType   = 'Times';
opts.fontSize   = 9;
% Range for options
range.filetype = {'png', 'eps'};
% Default options
defaults.width = 6;
defaults.height = 6;
defaults.filetype = 'eps';
% Current figure
the_fig = gcf;

%% Extract user input
% Dimensions
opts.width = str2num(input('Width: ','s'));
opts.height = str2num(input('Height: ', 's'));
% Filetype
opts.filetype = input('Filetype: ','s');

%% Enforce defaults
fn = fieldnames(defaults);
for k=1:numel(fn)
    if isempty(opts.(fn{k}))
        opts.(fn{k}) = defaults.(fn{k});
    end
end

%% Get filename
% Filename
[f,p,~] = uiputfile({['*.' opts.filetype]}, 'Export figure as ...');
opts.filename = [p f];
if ~opts.filename
    error('No filename provided')
    return
end

%% Check for bad input
opts.ft_idx = find(cellfun(@(x) isequal(x, opts.filetype) ...
                , range.filetype));
if isempty(opts.ft_idx)
    error('Unrecognised filetype')
    return
end

%% Resize everything
the_fig.Units               = 'centimeters';
the_fig.Position(3)         = opts.width;
the_fig.Position(4)         = opts.height;

%% Set font
%set(the_fig.Children, ...
%    'FontName',     opts.fontType, ...
%    'FontSize',     opts.fontSize);

%% Wait for user confirmation
if strcmpi( input('Write to file? (Y/n) ','s') , 'n')
    fprintf('Export cancelled\n')
    return
end

%% Export
% Remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

% Set paper mode for exporting
the_fig.PaperPositionMode   = 'auto';

% Export
switch opts.filetype
    case 'png'
        print(opts.filename, '-dpng', '-r600')
    case 'eps'
        print(opts.filename, '-depsc')
end
