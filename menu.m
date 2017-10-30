%--------MENU.M---------------------------------------
%--------ENTREGA 2 PDI-------------------------------------------
%--------POR: DAVID CAGUA y JUAN CARLOS MAYA SANCHEZ-------------
%--------C.C.: 1152213450 y 1017131966---------------------------
%--------Telefono: 3012905481------------------------------------
%--------Curso de Procesamiento Digital de Imagenes--------------
%--------v1.0 Entrega: OCTUBRE 27 -------------------------------



function varargout = menu(varargin)
%%Funcion que se encarga de implementar la funcion mascaracircular en un entorno grafico
%_______________________________________________________________________________________


% MENU MATLAB code for menu.fig
%      MENU, by itself, creates a new MENU or raises the existing
%      singleton*.
%
%      H = MENU returns the handle to a new MENU or the handle to
%      the existing singleton*.
%
%      MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU.M with the given input arguments.
%
%      MENU('Property','Value',...) creates a new MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help menu

% Last Modified by GUIDE v2.5 26-Oct-2017 16:43:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @menu_OpeningFcn, ...
                   'gui_OutputFcn',  @menu_OutputFcn, ...
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


% --- Executes just before menu is made visible.
function menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to menu (see VARARGIN)

% Choose default command line output for menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bprocesar.

% Boton bprocesar: boton que cuando se presiona, llama a la funcion mascara circular
% y redirige las salidas de esta hacia los objetos axes y los textos.______________________
function bprocesar_Callback(hObject, eventdata, handles)
% hObject    handle to bprocesar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%se inicializan los textos para evitar errores por contaminacion con posibles ejecuciones
%anteriores________________________________________________________________________________
set(handles.tCantidad,'string','Colonias de Bacterias: ');
set(handles.tArea,'string','Area Promedio: ');
%__________________________________________________________________________________________

%se adquiere el nombre de archivo obtenido a partir del boton bBuscar, el cual se encuentra 
%almacenado en el objeto tArchivo__________________________________________________________

a=get(handles.tArchivo,'string');
%__________________________________________________________________________________________

%Se transfiere el control de la ventana al axe aCargar, para que sea el quien muestre la foto
axes(handles.aCargar);
b=imread(a);
imshow(b);
hold on;
%___________________________________________________________________________________________

%se calculan los centroides, las areas y la cantidad de colonias de bacterias en la foto
[cen,ar,can]=mascaracircular(a);
%___________________________________________________________________________________________

%se imprimen los centroides de las colonias encontradas en la foto__________________________
plot(cen(:,1),cen(:,2),'r+');
%___________________________________________________________________________________________

%se calcula el histograma, y se muestra en el axe aProcesar_________________________________
axes(handles.aProcesar);
hist(ar);
%___________________________________________________________________________________________



%se calcula el promedio de las areas de las colonias, y se imprimen en pantalla tanto el 
%promedio como la cantidad de colonias de bacterias ________________________________________
promedioArea=median(ar);
text=get(handles.tCantidad,'string');
text=strcat(text,int2str(can(1,1)));
set(handles.tCantidad,'string',text);

text=get(handles.tArea,'string');
text=strcat(text,int2str(promedioArea));
set(handles.tArea,'string',text);
%___________________________________________________________________________________________



function tArchivo_Callback(hObject, eventdata, handles)
% hObject    handle to tArchivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tArchivo as text
%        str2double(get(hObject,'String')) returns contents of tArchivo as a double


% --- Executes during object creation, after setting all properties.
function tArchivo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tArchivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bBuscar.
%Boton que se encarga de la seleccion del archivo en el cual se encuentra la fotografia con 
%las colonias de bacterias_________________________________________________________________
function bBuscar_Callback(hObject, eventdata, handles)
% hObject    handle to bBuscar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% usamos uigetfile para que windows nos traiga al retorno el archivo con la foto. Se le debe
%especificar que tipo de archivo de foto puede tolerar para evitar errores. El nombre del 
%archivo y la ruta se guardan inicialemnte en archivos distintos, pero se concatenan y se guardan
% en la caja de texto tArchivo___________________________________________________________________
[archivo, ruta] = uigetfile({'*.jpg';'*.png';'*.tiff';'*.bmp'},'Seleccione la Imagen');
set(handles.tArchivo,'string',strcat(ruta,archivo));
%________________________________________________________________________________________________


%se utiliza el axe aCargar para hacer una carga inicial de la foto_______________________________
axes(handles.aCargar);
a=get(handles.tArchivo,'string');
b=imread(a);
imshow(b);
hold on;
%_________________________________________________________________________________________________

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
