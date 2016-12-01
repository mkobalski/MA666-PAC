%patch on one cycle
time=[0:0.001:1];
x=sin(time*2*pi);
fig=plot(time,x,'k','LineWidth',2.5);
ylim([-1.25 1.25])
ax=gca;
ax.XTick=[0 0.25 0.5 0.75 1];
ax.XTickLabel=[{'0', 'pi/2', 'pi', '3/2 pi', '2pi'}];
z=[0.125 0.375 0.375 0.125];
y=[-1.25 -1.25 1.25 1.25];
patch(z,y,'blue','FaceAlpha',0.3);


time=[0:0.001:4];
x=sin(time*2*pi);
fig2=plot(time,x,'k','LineWidth',2.5);
ylim([-1.25 1.25])
ax2=gca;
ax2.XTick=[0 0.5 1 1.5 2 2.5 3 3.5 4];
ax2.XTickLabel=[{'0', 'pi', '2pi', '3pi', '4pi', '5pi', '6pi'}];
for gg=1:4
z=[0.125 0.375 0.375 0.125]+gg-1;
y=[-1.25 -1.25 1.25 1.25];
patch(z,y,'blue','FaceAlpha',0.3);
end

