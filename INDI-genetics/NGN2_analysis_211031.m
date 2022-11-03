%% 211031 NGN2 analysis
addpath('I:/Scripts/Universal_functions','I:\Scripts\Zeiss\fluorescence_quantification');

cd('I:\Zeiss_examples\KOLF2.1\tifs\Stitched_Images');

mkdir('masks');
files = glob('*.tif');
filenumber = numel(files);
datalabels = {'nuclei','brn2','tuj1','dualpositive','neuritearea/nuclei'};
dataout = zeros(filenumber,numel(datalabels));
options.color = true;


nuclearchannel = 1;
nucleusminradius = 15;
cytoplasmchannel = 4;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v3(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[brn2call,brn2mask,brn2background] = positive_caller_v3(image(:,:,3),nuclearmask,backgroundmask,12); %there's background stainging with brn2 that is being called positive, hence the high threshold. I matched it to empirical observations
[tuj1call,tuj1mask,tuj1background] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,5);

array = [brn2call, foxg1call, tuj1call];

nuclei = double(max(nuclearmask,[],'all'));
brn2pos = sum(array(:,1))/nuclei*100;
tuj1pos = sum(array(:,3))/nuclei*100;

dualpos = sum(array(:,1)==1 & array(:,2)==1 & array(:,3)==1)/nuclei*100;

dataout(n,:)=[nuclei,brn2pos,foxg1pos,tuj1pos,dualpos,(sum(neuritemask>0,'all')/nuclei)];
saveastiff(objectmask,strcat('masks\',file(1:end-4),'mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');

