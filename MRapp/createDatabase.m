function [] = createDatabase()
%Dimiourgei txt me ta freq peaks apo to mp3 pou sto en logw txt, exei tin
%freq spacing kai binsize. Gia na diavastei to .txt se matrix
%xrisimopoioume dlmread()

    audioInDir = dir('*.mp3');
    audioNames = {audioInDir.name};

    if(length(audioNames)==0)
        disp 'No Audio Files in Current Directory'
    else
        for i=1:length(audioNames)
            
            filename = char(audioNames(i));
            filenameToSave = strcat( filename(1:(length(filename)-4)),'.txt');
                        
            constellation = create_constellation_adaptive_threshold(filename);
            dlmwrite(filenameToSave,constellation,'delimiter',' '); %Writes the constellation to .txt file
            
        end

    end

end

