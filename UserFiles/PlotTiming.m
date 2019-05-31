close all

figure
t = (1:length(Tact.data))/Tact.info.SamplingRateHz*1000;
plot(t, Tact.data(:,3), '--')
hold on
plot(t, Tact.data(:,4))
plot(t, Tact.data(:,8),'k', 'linewidth', 2)

% plot(t, Tact.data(:,6), '--')
% plot(t, Tact.data(:,7), '--')

stimPerceivedSamps = [find(Tact.data(:,8)>0.5,1), find(Tact.data(:,8)>0.5,1,'last')];
tactorPerceivedSamps = [find(Tact.data(:,5)>0.5,1), find(Tact.data(:,5)>0.5,1,'last')];


stimPerceived = stimPerceivedSamps/Tact.info.SamplingRateHz*1000 + 300;
stimPerceived(2) = stimPerceived(2);

tactorPerceived = tactorPerceivedSamps/Tact.info.SamplingRateHz*1000 + 100;
tactorPerceived(2) = tactorPerceived(2) - 900;

scatter(stimPerceived, [0.5, 0.5], 'X', 'linewidth', 2)
scatter(tactorPerceived, [0.5, 0.5], 'linewidth', 2)

% legend('stim button', 'beeps', 'stim starting', 'DCS button', 'tactor button')
legend('stim button', 'beeps', 'stim starting', 'approx stim perceived ~300 PPT', 'approx tactor perceived ~100')
xlabel('time (ms)')