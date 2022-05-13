function fingerprint=create_constellation_adaptive_threshold(song_name)
%Dinoume to onoma tou tragoudiou sto function kai epistrefei to
%constellation


newfs = 8192;

[song, Fs] = audioread(song_name);
if length(song(1,:))>1
    song_mono = ((song(:,1)+song(:,2))./2)';
else
    song_mono=song'; 
end
song_mono = song_mono - mean(song_mono); 
song_rs = resample(song_mono, newfs,Fs);

% Den pairnoume ta freq katw twn 1000Hz logw anaksiopistias
otherfs = 500:2:4096;

timePerWindow = 0.1;
window = round(timePerWindow*newfs); 
noverlap = round(0.75*window); 

[song_spect,fspec,tspec] = spectrogram(song_rs,window,noverlap,otherfs,newfs,'yaxis'); 

magSpec = abs(song_spect); 

%vriskoume ta peaks

gs = 3;
peaks = ones(size(magSpec)); 
for horShift = -gs:gs
    for vertShift = -gs:gs
        if(vertShift ~= 0 || horShift ~= 0) % Avoid comparing to self
            peaks = peaks.*( magSpec > circshift(magSpec,[horShift,vertShift]) );
        end
    end
end

peakMags = peaks.*magSpec;

%Adaptive Threshold

%Pairnoume ta prwta 30 peaks gia na ta antistixisoume kai thetoume
%opoiodipote value einai apo katw sto 0. Auto epitrepei ston kwdika na
%kanei tautisi kathe fora se mikra kommatia orizontia kai meta na psaxnei
%katheta gia na kanei tin tautisi

num_peaks=30;
song_spect_threshold = [];
threshold_size = floor((8192/(window/4))*1);
i = 0;
while 1
    i=i+threshold_size;
    if i-(threshold_size-1)>length(tspec)
        break
    end
    if i>length(tspec)
        song_spect_part=peakMags(:,i-(threshold_size-1):length(tspec));
        sorted_part = sort(song_spect_part(:),'descend');
        threshold = sorted_part(ceil(num_peaks*((i-length(tspec))/threshold_size)));
    else
        song_spect_part=peakMags(:,i-(threshold_size-1):i);
        sorted_part = sort(song_spect_part(:),'descend');
        threshold = sorted_part(num_peaks);
    end
    song_spect_part(song_spect_part<threshold)=0;
    song_spect_threshold = [song_spect_threshold, song_spect_part];
end


[f1 f2 delTPoints] = createPairs_adjustable(song_spect_threshold,tspec,otherfs);
fingerprint = [f1;f2;delTPoints];

end
