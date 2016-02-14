files = dir('./');

connectivities = {[],[],[],[],[],[],[],[],[],[],[]};

for f = files'
    a = strsplit(f.name,'.');
    a = a{1};
    if strcmp(a(1:end-1), 'connectivities')
        load(f.name);
        for i = 1:length(max_connectivities)
           connectivities{i} = [connectivities{i} max(max_connectivities{i})];
        end
    end
end

xs = linspace(0,1,11);
ys = [];
for i = 1:length(connectivities)
    ys(i) = mean(connectivities{i});
end
errs = [];
for i = 1:length(connectivities)
    errs(i) = std(connectivities{i})/sqrt(10);
end
errorbar(xs,ys,errs);xlim([0 1]);ylim([0 1]);
title('NMHS Probabilistic XOR (10 Trials)');
xlabel('Probability');
ylabel('Connectivity');