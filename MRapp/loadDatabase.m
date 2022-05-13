function [database,songNames] = loadDatabase()
%Kanei load ta .text files pou vriskontai ta constellations se matrix
%files. To database einai ena array pou ginontai stored ta constellations.
%songNames einai allo ena array pou kanei store to antistixo titlo tou
%kommatiou


    textInDir = dir('*.txt');
    textNames = {textInDir.name};
    
    database = cell(1,length(textNames)); 
    songNames = cell(1,length(textNames));
    
    
     if(length(textNames)==0) 
        disp 'No Constellation files in current directory'
     else
        for i=1:length(textNames)
            
           filename = char(textNames(i));
           database{i} =  dlmread(filename);
           
           songNames{i} = filename(1:length(filename)-4)
                        
        end

    end
    


end

