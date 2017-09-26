function varargout = KineticModelingGUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KineticModelingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @KineticModelingGUI_OutputFcn, ...
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


% --- Executes just before KineticModelingGUI is made visible.
function KineticModelingGUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for KineticModelingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = KineticModelingGUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Environment paths
% --- Executes on button press in browseInput.
function browseInput_Callback(hObject, eventdata, handles)
handles = guidata(hObject);

pathImageToProcessFolder = uigetdir;
set(handles.pathInput,'string',pathImageToProcessFolder);

numberOfFiles = calcNumberOfFiles(pathImageToProcessFolder);
set(handles.fileNumber,'string',numberOfFiles);

guidata(hObject,handles);

function pathImageToProcessFolder_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function pathInput_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pathReferenceVOI_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pathReference_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseReference.
function browseReference_Callback(hObject, eventdata, handles)
handles=guidata(hObject);

[pathReferenceVOIFile, pathReferenceVOIFolder] = uigetfile({'*.nii'},'File Selector');
pathReferenceVOI = [pathReferenceVOIFolder, pathReferenceVOIFile];
set(handles.pathReference,'string',pathReferenceVOI);

guidata(hObject,handles);

%% Reference Index


function referenceIdx_Callback(hObject, eventdata, handles)
function referenceIdx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getReference.
function getReference_Callback(hObject, eventdata, handles)
handles=guidata(hObject);

indices = str2num(get(handles.referenceIdx,'string'));

oldPath = get(handles.pathReference,'string');
newPath = [oldPath(1:end-4), '_reduced.nii'];

referenceVOIred = getReferenceFromAtlas(indices,oldPath,newPath);

set(handles.pathReference,'string',newPath);

guidata(hObject,handles);

%% Region of interest coordinates

function xCoord_Callback(hObject, eventdata, handles)
function xCoord_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yCoord_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function yCoord_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zCoord_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function zCoord_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sizeROI_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function sizeROI_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Sliders
% Framenumber
function sliderFrame_Callback(hObject, eventdata, handles)
val = round(hObject.Value);
hObject.Value=val;

sliderFrame = get(hObject,'Value');
assignin('base','sliderValue',sliderFrame);

set(handles.startFrame,'string',sliderFrame);


% --- Executes during object creation, after setting all properties.
function sliderFrame_CreateFcn(hObject, eventdata, handles)


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Frame length
function sliderLength_Callback(hObject, eventdata, handles)
% Round for only integer numbers
val = round(hObject.Value);
hObject.Value=val;

sliderLength = get(hObject,'Value');
assignin('base','sliderValue',sliderLength);

set(handles.lengthFrame,'string',sliderLength);


% --- Executes during object creation, after setting all properties.
function sliderLength_CreateFcn(hObject, eventdata, handles)


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function lengthFrame_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function lengthFrame_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startFrame_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function startFrame_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Running model scripts

% Patlak Function
function runPatlak_Callback(hObject, eventdata, handles)
set(handles.programType,'string','Patlak');

pathImage = get(handles.pathInput,'string');
pathRef =  get(handles.pathReference,'string');

x = str2double(get(handles.xCoord,'string'));
y = str2double(get(handles.yCoord,'string'));
z = str2double(get(handles.zCoord,'string'));
ROI = [x y z];
sizeROI = str2double(get(handles.sizeROI,'string'));

startframe = str2double(get(handles.startFrame,'string'));
lengthFrame = str2double(get(handles.lengthFrame,'string'));
numberOfFrames = str2double(get(handles.framesToSum,'string'));


meanSlopesROI = Patlak(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
meanSlopeROI = meanSlopesROI(1);

set(handles.slope,'string',meanSlopeROI);
set(handles.filesWritten,'string','Files written to:');
set(handles.outputFolder,'string',[pathImage, '/Patlak/']);


% Logan Function
function runLogan_Callback(hObject, eventdata, handles)
set(handles.programType,'string','Logan');

pathImage = get(handles.pathInput,'string');
pathRef =  get(handles.pathReference,'string');

x = str2double(get(handles.xCoord,'string'));
y = str2double(get(handles.yCoord,'string'));
z = str2double(get(handles.zCoord,'string'));
ROI = [x y z];
sizeROI = str2double(get(handles.sizeROI,'string'));

startframe = str2double(get(handles.startFrame,'string'));
lengthFrame = str2double(get(handles.lengthFrame,'string'));

meanSlopesROI = Logan(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame);
meanSlopeROI = meanSlopesROI(1);

set(handles.slope,'string',meanSlopeROI);
set(handles.filesWritten,'string','Files written to:');
set(handles.outputFolder,'string',[pathImage, '/Logan/']);

% LoganK2 Function
function runLoganK2_Callback(hObject, eventdata, handles)
set(handles.programType,'string','LoganK2');

pathImage = get(handles.pathInput,'string');
pathRef =  get(handles.pathReference,'string');

x = str2double(get(handles.xCoord,'string'));
y = str2double(get(handles.yCoord,'string'));
z = str2double(get(handles.zCoord,'string'));
ROI = [x y z];
sizeROI = str2double(get(handles.sizeROI,'string'));

startframe = str2double(get(handles.startFrame,'string'));
lengthFrame = str2double(get(handles.lengthFrame,'string'));


meanSlopesROI = LoganK2(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame);
meanSlopeROI = meanSlopesROI(1);

set(handles.slope,'string',meanSlopeROI);
set(handles.filesWritten,'string','Files written to:');
set(handles.outputFolder,'string',[pathImage, '/LoganK2/']);

% MRTM Function
function runMRTM_Callback(hObject, eventdata, handles)
set(handles.programType,'string','MRTM');

pathImage = get(handles.pathInput,'string');
pathRef =  get(handles.pathReference,'string');

x = str2double(get(handles.xCoord,'string'));
y = str2double(get(handles.yCoord,'string'));
z = str2double(get(handles.zCoord,'string'));
ROI = [x y z];
sizeROI = str2double(get(handles.sizeROI,'string'));

startframe = str2double(get(handles.startFrame,'string'));
lengthFrame = str2double(get(handles.lengthFrame,'string'));

[meanSlopesROI,chiSquaresROI,averageK2Primes] = MRTM(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame);
meanSlopeROI = meanSlopesROI(1);
chiSquareROI = chiSquaresROI(1);
averageK2Prime = averageK2Primes(1);
disp(chiSquareROI);

set(handles.slope,'string',meanSlopeROI);
set(handles.filesWritten,'string','Files written to:');
set(handles.outputFolder,'string',[pathImage, '/MRTM/']);


% SRTM Funcion
function runSRTM_Callback(hObject, eventdata, handles)
set(handles.programType,'string','SRTM');

pathImage = get(handles.pathInput,'string');
pathRef =  get(handles.pathReference,'string');

x = str2double(get(handles.xCoord,'string'));
y = str2double(get(handles.yCoord,'string'));
z = str2double(get(handles.zCoord,'string'));
ROI = [x y z];
sizeROI = str2double(get(handles.sizeROI,'string'));

startframe = str2double(get(handles.startFrame,'string'));
lengthFrame = str2double(get(handles.lengthFrame,'string'));
numberOfFrames = str2double(get(handles.framesToSum,'string'));

[meanSlopesROI,chiSquaresROI,averageK2s] = SRTM(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
meanSlopeROI = meanSlopesROI(1);
chiSquareROI = chiSquaresROI(1);
averageK2 = averageK2s(1);

set(handles.slope,'string',meanSlopeROI);
set(handles.filesWritten,'string','Files written to:');
set(handles.outputFolder,'string',[pathImage, '/SRTM/']);



function framesToSum_Callback(hObject, eventdata, handles)

function framesToSum_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
