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
[xDim, yDim, zDim] = getDimension(pathImageToProcessFolder);

set(handles.dimX,'string',num2str(xDim));
set(handles.dimY,'string',num2str(yDim));
set(handles.dimZ,'string',num2str(zDim));

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


function framesToSum_Callback(hObject, eventdata, handles)

function framesToSum_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseOutput.
function browseOutput_Callback(hObject, eventdata, handles)

handles = guidata(hObject);

pathOutputFolder = uigetdir;
set(handles.pathOutput,'string',pathOutputFolder);

guidata(hObject,handles);


function pathOutput_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function pathOutput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonNormalize.
function buttonNormalize_Callback(hObject, eventdata, handles)

pathImageFolder = get(handles.pathOutput,'string');
relativeImages(pathImageFolder);


% --- Executes on selection change in boxModel.
function boxModel_Callback(hObject, eventdata, handles)
% hObject    handle to boxModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns boxModel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from boxModel


% --- Executes during object creation, after setting all properties.
function boxModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Running the Program
% --- Executes on button press in runProgram.
function runProgram_Callback(hObject, eventdata, handles)
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

set(handles.filesWritten,'string','Files written to:');
set(handles.textChiSquare,'string','Fit Deviation:');
set(handles.textSlope,'string','Slope ROI:');

model = get(handles.boxModel,'value');

if (model == 1)

    pathOutput = [pathImage, '/Patlak/'];
    set(handles.programType,'string','Patlak');

    [meanSlopesROI, chiSquareROIs ] = Patlak(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
    meanSlopeROI = meanSlopesROI(1);
    chiSquareROI = chiSquareROIs(1);

    set(handles.slope,'string',meanSlopeROI);
    set(handles.outputFolder,'string',pathOutput);
    set(handles.pathOutput,'string',pathOutput);
    set(handles.chiSquare,'string',chiSquareROI);
    set(handles.textK2,'string','');
    set(handles.averageK,'string','');
    
elseif (model == 2)
    pathOutput = [pathImage, '/Logan/'];
    set(handles.programType,'string','Logan');

    [ meanSlopesROI, chiSquareROIs ] = Logan(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
    meanSlopeROI = meanSlopesROI(1);
    chiSquareROI = chiSquareROIs(1);

    set(handles.slope,'string',meanSlopeROI);
    set(handles.outputFolder,'string',pathOutput);
    set(handles.pathOutput,'string',pathOutput);
    set(handles.chiSquare,'string',chiSquareROI);
    set(handles.textK2,'string','');
    set(handles.averageK,'string','');
    
elseif (model == 3)
    pathOutput = [pathImage, '/LoganK2/'];
    set(handles.programType,'string','LoganK2');
    
    [ meanSlopesROI, chiSquareROIs ] = LoganK2(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
    meanSlopeROI = meanSlopesROI(1);
    chiSquareROI = chiSquareROIs(1);

    set(handles.slope,'string',meanSlopeROI);
    set(handles.outputFolder,'string',pathOutput);
    set(handles.pathOutput,'string',pathOutput);
    set(handles.chiSquare,'string',chiSquareROI);
    set(handles.textK2,'string','');
    set(handles.averageK,'string','');

elseif (model == 5)
    pathOutput = [pathImage, '/MRTM/'];
    set(handles.programType,'string','MRTM');
    
    [meanSlopesROI,chiSquaresROI,averageK2Primes] = MRTM(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
    chiSquareROI = chiSquaresROI(1);
    meanSlopeROI = meanSlopesROI(1);
    averageK2Prime = averageK2Primes(1);
    
    set(handles.slope,'string',meanSlopeROI);
    set(handles.outputFolder,'string',pathOutput);
    set(handles.pathOutput,'string',pathOutput);
    set(handles.chiSquare,'string',chiSquareROI);
    set(handles.textK2,'string','average k2Prime:');
    set(handles.averageK,'string',averageK2Prime);

elseif (model == 4)
    pathOutput = [pathImage, '/SRTM/'];
    set(handles.programType,'string','SRTM');
    
    [meanSlopesROI, chiSquaresROI, averageK2s] = SRTM(pathImage,pathRef,ROI,sizeROI,startframe,lengthFrame,numberOfFrames);
    averageK2 = averageK2s(1);
    chiSquareROI = chiSquaresROI(1);
    meanSlopeROI = meanSlopesROI(1);

    set(handles.slope,'string',meanSlopeROI);
    set(handles.outputFolder,'string',pathOutput);
    set(handles.pathOutput,'string',pathOutput);
    set(handles.chiSquare,'string',chiSquareROI);
    set(handles.textK2,'string','average k2:');
    set(handles.averageK,'string',averageK2);
end
