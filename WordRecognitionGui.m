function varargout = WordRecognitionGui(varargin)
% WORDRECOGNITIONGUI MATLAB code for WordRecognitionGui.fig
%      WORDRECOGNITIONGUI, by itself, creates a new WORDRECOGNITIONGUI or raises the existing
%      singleton*.
%
%      H = WORDRECOGNITIONGUI returns the handle to a new WORDRECOGNITIONGUI or the handle to
%      the existing singleton*.
%
%      WORDRECOGNITIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WORDRECOGNITIONGUI.M with the given input arguments.
%
%      WORDRECOGNITIONGUI('Property','Value',...) creates a new WORDRECOGNITIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WordRecognitionGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WordRecognitionGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WordRecognitionGui

% Last Modified by GUIDE v2.5 13-Feb-2017 23:01:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WordRecognitionGui_OpeningFcn, ...
                   'gui_OutputFcn',  @WordRecognitionGui_OutputFcn, ...
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
% End initialization code - DO NOT EDIT

% --- Executes just before WordRecognitionGui is made visible.
function WordRecognitionGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WordRecognitionGui (see VARARGIN)

% Choose default command line output for WordRecognitionGui
handles.output = hObject;

handles.wordList = {'rot' ...
            'grün' ... 
            'gelb' ... 
            'blau' ...
            'schwarz' ...
            'weiß' ...
            'eins' ...
            'zwei' ...
            'drei' ...
            'vier' ...
            'fünf' ...
            'sechs' ...
            'sieben' ...
            'acht' ...
            'neun'...
            'zehn'};
handles.wordListPopup.String = handles.wordList;

handles.bitrate = 16000;
handles.samplerate = 16;
handles.channel = 1;
handles.recordDuration = 3;
handles.samplesFolderName = 'Samples';
handles.sampleMode = SampleMode.Preemphasis_Off_Liftering_Off;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WordRecognitionGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = WordRecognitionGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in trainWordBtn.
function trainWordBtn_Callback(hObject, eventdata, handles)
% hObject    handle to trainWordBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audioData = RecordAudioData(handles);
mfcc = GetMFCCCoefficients(audioData, handles.bitrate, handles.sampleMode, true);
SaveMFCCToFile(mfcc, handles, handles.sampleMode);

% --- Executes on button press in trainWordAllModesBtn.
function trainWordAllModesBtn_Callback(hObject, eventdata, handles)
% hObject    handle to trainWordAllModesBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audioData = RecordAudioData(handles);

mfcc = GetMFCCCoefficients(audioData, handles.bitrate, SampleMode.Preemphasis_Off_Liftering_Off, false);
SaveMFCCToFile(mfcc, handles, SampleMode.Preemphasis_Off_Liftering_Off);

mfcc = GetMFCCCoefficients(audioData, handles.bitrate, SampleMode.Preemphasis_Off_Liftering_On, false);
SaveMFCCToFile(mfcc, handles, SampleMode.Preemphasis_Off_Liftering_On);

mfcc = GetMFCCCoefficients(audioData, handles.bitrate, SampleMode.Preemphasis_On_Liftering_Off, false);
SaveMFCCToFile(mfcc, handles, SampleMode.Preemphasis_On_Liftering_Off);

mfcc = GetMFCCCoefficients(audioData, handles.bitrate, SampleMode.Preemphasis_On_Liftering_On, false);
SaveMFCCToFile(mfcc, handles, SampleMode.Preemphasis_On_Liftering_On);


% --- Executes during object creation, after setting all properties.
function wordListPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wordListPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in clearTrainingBtn.
function clearTrainingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearTrainingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(exist(handles.samplesFolderName, 'dir') ~= 0)
    rmdir(handles.samplesFolderName, 's');
end

% --- Executes on button press in recognizeWordBtn.
function recognizeWordBtn_Callback(hObject, eventdata, handles)
% hObject    handle to recognizeWordBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audioData = RecordAudioData(handles);
mfcc = GetMFCCCoefficients(audioData, handles.bitrate, handles.sampleMode, true);
index = FindMatchingPattern(mfcc, handles);
handles.recognizedWordTxt.String = strjoin(handles.wordList(index));

% --- Executes on button press in preEmphasisCheckBox.
function preEmphasisCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to preEmphasisCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.lifteringCheckBox.Value
    if get(hObject,'Value')
        handles.sampleMode = SampleMode.Preemphasis_On_Liftering_On;
    else
        handles.sampleMode = SampleMode.Preemphasis_Off_Liftering_On;
    end
else
    if get(hObject,'Value')
        handles.sampleMode = SampleMode.Preemphasis_On_Liftering_Off;
    else
        handles.sampleMode = SampleMode.Preemphasis_Off_Liftering_Off;
    end
end
guidata(hObject, handles);

% --- Executes on button press in lifteringCheckBox.
function lifteringCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to lifteringCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.preEmphasisCheckBox.Value
    if get(hObject,'Value')
        handles.sampleMode = SampleMode.Preemphasis_On_Liftering_On;
    else
        handles.sampleMode = SampleMode.Preemphasis_On_Liftering_Off;
    end
else
    if get(hObject,'Value')
        handles.sampleMode = SampleMode.Preemphasis_Off_Liftering_On;
    else
        handles.sampleMode = SampleMode.Preemphasis_Off_Liftering_Off;
    end
end
guidata(hObject, handles);