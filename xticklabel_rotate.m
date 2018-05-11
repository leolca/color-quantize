## get position of current xtick labels
h = get(gca,'xlabel');
xlabelstring = get(h,'string');
xlabelposition = get(h,'position');

## construct position of new xtick labels
yposition = xlabelposition(2);
yposition = repmat(yposition,length(xtick),1);

## disable current xtick labels
set(gca,'xtick',[]);

## set up new xtick labels and rotate
hnew = text(xtick, yposition, xticklabel);
set(hnew,'rotation',90,'horizontalalignment','right');
