function plotPOMDP(results)

% Get the data
X1 = results.plot.belief_space;
YMatrix1 =  results.plot.alpha_values;
YMatrix2 =  results.plot.action_values;
ymatrix3 = results.plot.policy_belief';

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create subplot
subplot1 = subplot(2,2,1,'Parent',figure1,'FontSize',16);
box(subplot1,'on');
hold(subplot1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',subplot1);
set(plot1(1),'LineWidth',3);
set(plot1(end),'LineWidth',3,'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);

% Create xlabel
xlabel('belief states');
set(gca,'XTick',[0,1],'XTickLabel',results.pomdp.states);
set(gca,'YLim',[-120,25],'YTick',-100:20:20);

% Create title
title('alpha values');

% Create subplot
subplot2 = subplot(2,2,2,'Parent',figure1,'FontSize',16);
box(subplot2,'on');
hold(subplot2,'on');

% Create multiple lines using matrix input to plot
plot2 = plot(X1,YMatrix2,'Parent',subplot2,'LineWidth',3);
set(plot2(1),'DisplayName','listen',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(plot2(2),'DisplayName','open left',...
    'Color',[0 0.447058826684952 0.74117648601532]);
set(plot2(3),'DisplayName','open right',...
    'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);

% Create xlabel
xlabel({'belief states',''});
set(gca,'XTick',[0,1],'XTickLabel',results.pomdp.states);
set(gca,'YLim',[-120,25],'YTick',-100:20:20);

% Create title
title('action values');

% Create legend
legend1 = legend(subplot2,'show');
set(legend1,...
    'Position',[0.779194630872482 0.39688041594454 0.140939597315436 0.0866551126516463]);

% Create subplot
subplot3 = subplot(2,2,3,'Parent',figure1,...
    'YTickLabel',{'','','listen','','open right','','open left'},...
    'FontSize',16);
box(subplot3,'on');
hold(subplot3,'on');

% Create multiple lines using matrix input to area
%area1 = area(X1,ymatrix3,'Parent',subplot3);

for i=1:numel(plot1)
    
    x1=results.plot.belief_space(find(results.plot.policy_belief(i,:),1,'first'));
    x2=results.plot.belief_space(find(results.plot.policy_belief(i,:),1,'last'));
    y = max(results.plot.policy_belief(i,:));
    p(i)=patch([x1 x1 x2 x2],[0 y y 0],plot1(i).Color,'EdgeColor',plot1(i).Color,'LineWidth',2);
end

% Create xlabel
xlabel('belief states');
set(gca,'XTick',[0,1],'XTickLabel',results.pomdp.states);

% Create title
title('policy value');

