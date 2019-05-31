%% 8/7/2017 - JAC - stim and tactor simultaneous timing file generator 
% Edited from DJC's respTimingFilegen code

% this script will generate two text files. One of these has the sample
% number at which each stimulus train will be delivered. the second has the
% condition which should be read in 

prompt = {'Enter subject name','What is the range of ITI?', 'What is the sample rate of the TDT?','Which file number is this?'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'stimTactorSim','[4.0,5.0]','24414.0625','1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
sid = answer{1};
ITI = str2num(answer{2});
fs = str2num(answer{3});
fileNum = answer{4};


%% make the timing file
% add 1 to ITI - changed from 0.8 which we originally thought. This is to
% account for 200 ms of pulse, then the 800 ms of downtime, then the ITI

% so the range of the ITI is actually 2.5-3.5 s

ITIlo = ITI(1)+1;
ITIhi = ITI(2)+1;

% number of trials

numTrials = 140;
randTimes = unifrnd(ITIlo,ITIhi,numTrials,1);


% here the vector is converted to the sample number where the stimulus
% train should start to be delivered 
sample = 1; % start with sample 1 
pts = [];
for i = 1:length(randTimes)
    sample = round(sample + randTimes(i)*fs);
    pts = [pts; sample];
end

pts1 = pts;
clear pts


%% make the conditions file

% tactor 
tact = repmat(-1,20,1);

% no stim
noStim = repmat(0,10,1);

% stim conditions

%numbers of stimuli to delivery 
numEachStim = 20;

offTarg = repmat(1,numEachStim,1);
stim1 = repmat(2,numEachStim,1);
stim2 = repmat(3,numEachStim,1);
stim3 = repmat(4,numEachStim,1);
stim4 = repmat(5,numEachStim,1);


vectorCond = [stim1;stim2;stim3;stim4;noStim;offTarg];
vectorTact = [tact;noStim];

vectorCondRand1 = vectorCond(randperm(length(vectorCond)));
vectorTactRand1 = vectorTact(randperm(length(vectorTact)));



ptsTotal = [pts1];
vectorCondRandTotal = [vectorCondRand1; vectorTactRand1];

%% account for latency in beeps for tactor touch of experimenter
% assuming 200 ms hi, 300 ms lo for each beep, and a train of 3 beeps where
% the experimenter is delivering a touch on the 3rd beep, subtract 1000 ms
% from each response time pt where the condition is for tactor touch 

timeToDelay = 1; % 1000 ms = 1 s
logicalValues = (vectorCondRandTotal == -1);
ptsTotal(logicalValues) = (ptsTotal(logicalValues)-(round(fs*timeToDelay)));


%% write these times to file for stim train delivery

filename = sprintf('%s_stimTrainDelivery_%s.txt',sid,fileNum);
fileID = fopen(filename,'w+');
fprintf(fileID,'%d\r\n',ptsTotal);
fclose(fileID);

%% write these times to file for condition 

filename = sprintf('%s_condition_%s.txt',sid,fileNum);
fileID = fopen(filename,'w+');
fprintf(fileID,'%d\r\n',vectorCondRandTotal);
fclose(fileID);