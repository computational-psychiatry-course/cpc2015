function purty_plot(figNum, figurename,type)
% Use purty_plot(figureNumber, desiredFigureName)
fontName = 'Helvetica';

hFig = figNum;

% Get axes:
hAxes = get(hFig,'Children');
hPlot = [];

% Get data axes
hData = get(hAxes,'Children');
hTitle = get(hAxes,'Title');
hLegend =  findobj(hFig,'Type','axes','Tag','legend');
hLabel = [get(hAxes,'xlabel') get(hAxes,'ylabel')];


% Adjust fonts of the axis
for l = 1:length(hAxes)
    if iscell(hAxes)
        set(hAxes{l},  ...
            'FontName',fontName , ...
            'FontSize', 14, ...
            'Box'         , 'off'     , ...
            'GridLineStyle' , 'none'     , ...
            'TickDir'     , 'out'     , ...
            'TickLength'  , [.02 .02] , ...
            'XMinorTick'  , 'on'      , ...
            'YMinorTick'  , 'on'      , ...
            'YGrid'       , 'on'      , ...
            'XColor'      , [.3 .3 .3], ...
            'YColor'      , [.3 .3 .3], ...
            'LineWidth'   , 1         );
    else
        set(hAxes(l),  ...
            'FontName',fontName , ...
            'FontSize', 14, ...
            'Box'         , 'off'     , ...
            'GridLineStyle' , 'none'     , ...
            'TickDir'     , 'out'     , ...
            'TickLength'  , [.02 .02] , ...
            'XMinorTick'  , 'on'      , ...
            'YMinorTick'  , 'on'      , ...
            'YGrid'       , 'on'      , ...
            'XColor'      , [.3 .3 .3], ...
            'YColor'      , [.3 .3 .3], ...
            'LineWidth'   , 1         );
    end
    
    grid off
end

% Adjust the line smoothing
if ~isempty(hPlot)
    for k = 1:length(hPlot)
        if iscell(hPlot)
            set(hPlot{k}, ...
                'LineSmoothing', 'on',...
                'LineWidth',2);
        else
            set(hPlot(k), ...
                'LineSmoothing', 'on',...
                'LineWidth',2);
        end
    end
end

% Adjust fonts of the labels
if ~isempty(hLabel)
    for i = 1:length(hLabel)
        if iscell(hLabel)
            set(hLabel{i}, ...
                'FontName'   , fontName ,...
                'FontSize'   , 14          );
        else
            set(hLabel(i), ...
                'FontName'   , fontName ,...
                'FontSize'   , 14          );
        end
    end
end

% Make title purty:
for j = 1:length(hTitle)
    if iscell(hTitle)
        
        set(hTitle{j}                    , ...
            'FontName'   , fontName, ...
            'FontSize'   , 14          , ...
            'FontWeight' , 'bold'      );
    else
        set(hTitle(j)                    , ...
            'FontName'   , fontName, ...
            'FontSize'   , 14          , ...
            'FontWeight' , 'bold'      );
    end
    
end

% Make legend purty:
set([hLegend]                , ...
    'FontSize'   , 10       , ...
    'FontName'   , fontName  , ...
    'location', 'SouthWest'  );

set(gcf, 'PaperPositionMode', 'auto');

if strcmp(type,'eps')
    figurename_eps = [ figurename '.eps'];
    print(figurename_eps,'-deps')
elseif strcmp(type,'pdf')
    figurename_pdf = [ figurename '.pdf'];
    print(figurename_pdf,'-dpdf')
elseif strcmp(type,'png')
    figurename_png = [figurename '.png'];
    print(figurename_png,'-dpng')
end
