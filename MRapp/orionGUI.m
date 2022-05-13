function varargout = orionGUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @orionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @orionGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function orionGUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);



function varargout = orionGUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function createDatabaseButton_Callback(hObject, eventdata, handles)

    notify = msgbox('Creating database');
    delete(notify); 



function recordButton_Callback(hObject, eventdata, handles)
    
    fs = 44100;
    recordingTime = 10;
    A = audiorecorder(fs,16,1); 
    recordblocking(A,recordingTime); 
    delete(notify); 
    
    micRecording = getaudiodata(A);
    audiowrite('mic.wav',micRecording,fs)
    
    hashRecording = create_constellation_adaptive_threshold('mic.wav')';

    global database
    global songNames
    
    matches = zeros(1,length(database)); 
    
    for(j=1:length(database))

        hashList = cell2mat(database(j))'; 
        
        for( i=1:size(hashRecording,1) )

            f = ismembertol(hashRecording(i,:),hashList,1,'ByRows',true,'DataScale',[1 1 0.05]);
            
            if(f==1)
               matches(j) = matches(j)+1; 
            end

        end

    end
    
    [maxMatches,maxIndex] = max(matches);

    set(handles.resultBox ,'string',char( songNames(maxIndex)) )

    axes(handles.bargraph)
    bar(1:length(matches),matches)
    title('Number of Hits per Song')
    xlabel('Song Numbers')
    ylabel('Number of Hits')
        
    
    
