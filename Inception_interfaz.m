function varargout = Inception_interfaz(varargin)
% INCEPTION_INTERFAZ MATLAB code for Inception_interfaz.fig
%      INCEPTION_INTERFAZ, by itself, creates a new INCEPTION_INTERFAZ or raises the existing
%      singleton*.
%
%      H = INCEPTION_INTERFAZ returns the handle to a new INCEPTION_INTERFAZ or the handle to
%      the existing singleton*.
%
%      INCEPTION_INTERFAZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INCEPTION_INTERFAZ.M with the given input arguments.
%
%      INCEPTION_INTERFAZ('Property','Value',...) creates a new INCEPTION_INTERFAZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inception_interfaz_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inception_interfaz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inception_interfaz

% Last Modified by GUIDE v2.5 16-May-2023 22:55:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inception_interfaz_OpeningFcn, ...
                   'gui_OutputFcn',  @Inception_interfaz_OutputFcn, ...
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


% --- Executes just before Inception_interfaz is made visible.
function Inception_interfaz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inception_interfaz (see VARARGIN)

axes(handles.axes6)
imagen = imread('C:\Users\jhoni\OneDrive\Documents\MATLAB\Logo_udec11.png');
imshow(imagen)


% Choose default command line output for Inception_interfaz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inception_interfaz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inception_interfaz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
%------------LEER LA IMG-------------------------------%
axes(handles.axes1)                                             %se carga la imagen en el axes1 
[filename, pathname] = uigetfile('*.png;*.jpg','Selecciona imagen'); %cargamos la imagen con el comonado uigetfile
img = imread(filename);                                         %leemos la img
imshow(img);                                                    %mostramos la img
title('Imagen Cargada');
tam_img = size(img);                                            %obtenemos el tamaño de la img 

%enviar parametro al btn_Iniciar
handles.img = img;
guidata(hObject,handles);

strtam=string(tam_img);                                         %convertimos el caracter en string para imprimirlo en la interfaz 
set(handles.tam_img1,'string',strtam);      


% --- Executes on button press in btn_iniciar.
function btn_iniciar_Callback(hObject, eventdata, handles)

handles = guidata(hObject);                                     %creamos el obj 
img = handles.img;                                    %Llamamos la img _ filt con el handles y la guardamos en la img_filt                    

net = inceptionv3;                              %Creamos la red 

inputSize = net.Layers(1).InputSize;    % establecemos el tamaño de img que va a recibir la red 
                                        % para este caso es de 299x299x3 siendo esta es la primera capa
classNames = net.Layers(end).ClassNames; % guardamos las etiquetas de todas en classNames.             
numClasses = numel(classNames); %obtenmos las 10 clases en la ultima capa.                  
disp(classNames(randperm(numClasses,10))) % con la funcion randperm tenemos las etiquetas de forma aleatoria entre 1 hata numclasses. 
                                          % y se devuelve en un vectos
img = imresize(img,inputSize(1:2));       % redimensionamos la img para que tenga el mismo tamaño para la entrada.
tam2= size(img);

[label,scores] = classify(net,img); % se obtiene la clasificacion de la red. 
%label                              %label es la etiqueta y scores es el porcentaje
axes(handles.axes2);
imshow(img)
title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");

[~,idx] = sort(scores,'descend'); % obtiene los index de los clasificados de forma descendente.
idx = idx(5:-1:1);  % se obtiene 5 clasificados 
classNamesTop = net.Layers(end).ClassNames(idx); % se utiliza el index para encontrar los nombres de las clases correspondientes
scoresTop = scores(idx);    % utilizando el index nos indica la puntuacion.

axes(handles.axes3)
barh(scoresTop)
xlim([0 1])
title('clases')
xlabel('Probabilidad')
yticklabels(classNamesTop)


strtam2=string(tam2);                                         %convertimos el caracter en string para imprimirlo en la interfaz 
set(handles.tam_img2,'string',strtam2);    
