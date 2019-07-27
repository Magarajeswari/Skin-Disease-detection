function varargout = GUIAdmin(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIAdmin_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIAdmin_OutputFcn, ...
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

function GUIAdmin_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);
handles.training_algo = 'Scaled Conjugate Gradient';
guidata(hObject, handles);

function varargout = GUIAdmin_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
    
if strcmp(handles.training_algo, 'Scaled Conjugate Gradient')
    algo = 'trainscg';
elseif strcmp(handles.training_algo, 'Levenberg-Marquardt')
    algo = 'trainlm';
elseif strcmp(handles.training_algo, 'Bayesian Regularisation')
    algo = 'trainbr';
end

[t, y, tr] = neuralnet(algo);

tTrn = t(:,tr.trainInd);
yTrn = y(:, tr.trainInd);

[~, cm, ~, per] = confusion(tTrn, yTrn);

TP = zeros(1,6);
FP = zeros(1,6);
TPR = zeros(1,6);
TNR = zeros(1,6);
FN = zeros(1,6);
TN = zeros(1,6);

prec = zeros(1,6);

for i=1:6
    TPR(i) = per(i, 3);
    TNR(i) = per(i, 4);
end

for i=1:6
    for j=1:6
        if (i~=j)
            FP(i) = FP(i) + cm(i, j);
            FN(i) = FN(i) + cm(j, i);
        end
    end
end

for i=1:6
    TP(i) = cm(i, i);
    TN(i) = 463 - (FP(i) + FN(i) + TP(i));
end

for i=1:6
    prec(i) = (TP(i)) / (TP(i) + FP(i));
    if isnan(prec(i))
        prec(i) = 0;
    end
end

sens = sum(TPR) / 6;
spec = sum(TNR) / 6;
acc = sum(TP) / 369;
pre = sum(prec) / 6;


set(handles.result_text, 'Visible', 'on');
set(handles.result_TPR, 'Visible', 'on');
set(handles.result_TNR, 'Visible', 'on');
set(handles.result_prec, 'Visible', 'on');
set(handles.result_acc, 'Visible', 'on');
set(handles.tpr, 'Visible', 'on');
set(handles.tnr, 'Visible', 'on');
set(handles.pushbutton3, 'Enable', 'on');

res_tpr = [num2str(sens * 100), '%'];
res_tnr = [num2str(spec * 100), '%'];
res_prec = [num2str(pre * 100), '%'];
res_acc = [num2str(acc * 100), '%'];

set(handles.tpr, 'String', res_tpr);
set(handles.tnr, 'String', res_tnr);
set(handles.prec, 'String', res_prec);
set(handles.acc, 'String', res_acc);

handles.t = t;
handles.y = y;
handles.tr = tr;
guidata(hObject, handles);

function pushbutton3_Callback(hObject, eventdata, handles)

t = handles.t;
y = handles.y;
tr = handles.tr;

tTst = t(:,tr.testInd);
yTst = y(:, tr.testInd);

[~, cm, ~, per] = confusion(tTst, yTst);

TP = zeros(1,6);
FP = zeros(1,6);
TPR = zeros(1,6);
TNR = zeros(1,6);
FN = zeros(1,6);
TN = zeros(1,6);

prec = zeros(1,6);

for i=1:6
    TPR(i) = per(i, 3);
    TNR(i) = per(i, 4);
end

for i=1:6
    for j=1:6
        if (i~=j)
            FP(i) = FP(i) + cm(i, j);
            FN(i) = FN(i) + cm(j, i);
        end
    end
end

for i=1:6
    TP(i) = cm(i, i);
    TN(i) = 463 - (FP(i) + FN(i) + TP(i));
end

for i=1:6
    prec(i) = (TP(i)) / (TP(i) + FP(i));
    if isnan(prec(i))
        prec(i) = 0;
    end
end

sens = sum(TPR) / 6;
spec = sum(TNR) / 6;
acc = sum(TP) / 46;
pre = sum(prec) / 6;

res_tpr = [num2str(sens * 100), '%'];
res_tnr = [num2str(spec * 100), '%'];
res_prec = [num2str(pre * 100), '%'];
res_acc = [num2str(acc * 100), '%'];

set(handles.tpr, 'String', res_tpr);
set(handles.tnr, 'String', res_tnr);
set(handles.prec, 'String', res_prec);
set(handles.acc, 'String', res_acc);

function pushbutton2_Callback(hObject, eventdata, handles)

clc;
close (GUIAdmin);
[main] = GUIMain();

function training_group_SelectionChangedFcn(hObject, eventdata, handles)

training_algo = get(hObject, 'String');
handles.training_algo = training_algo;
set(handles.pushbutton1,'Enable','on');
guidata(hObject, handles);
