# 03 - Dialogues
## 45 - Save dialog values to disk

![image.png](image.png)

To ensure that the values of the dialog are retained even after the application is closed, we save the data to the disk.
It is not checked whether it can be written, etc.
If you want this you would have to check with **IOResult**, etc.

---
**sysutils** is also added here; it is needed for **FileExits**.

```pascal
uses 
SysUtils, // For file operations
```

The file in which the data for the dialog is located.

```pascal
const 
DialogFile = 'parameter.cfg';
```

At the beginning the data, if present, is loaded from the disk, otherwise it is created.

```pascal 
constructor TMyApp.Init; 
begin 
inherited Init; 
// Check if file exists. 
if FileExists(DialogFile) then begin 
// Load data from disk. 
AssignFile(fParameterData, DialogFile); 
Reset(fParameterData); 
Read(fParameterData, ParameterData); 
CloseFile(fParameterData); 
// otherwise use default values. 
end else begin 
with ParameterData do begin 
pressure := %0101; 
font := 2; 
Note := 'Hello world !'; 
end; 
end; 
end;
```

The data will be saved to disk when **Ok** is pressed.

```pascal 
procedure TMyApp.MyParameter; 
var 
Dlg: PDialog; 
R: TRect; 
dummy: word; 
View: PView; 
begin 
R.Assign(0, 0, 35, 15); 
R.Move(23, 3); 
Dlg := New(PDialog, Init(R, 'Parameter')); 
with Dlg^ do begin 

// CheckBoxes 
R.Assign(2, 3, 18, 7); 
View := New(PCheckBoxes, Init(R, 
NewSItem('~File', 
NewSItem('~row~row', 
NewSItem('D~a~tum', 
NewSItem('~Time~', 
nil)))))); 
Insert(View); 
// Label for CheckGroup. 
R.Assign(2, 2, 10, 3); 
Insert(New(PLabel, Init(R, 'Press', View))); 

// RadioButton 
R.Assign(21, 3, 33, 6); 
View := New(PRadioButtons, Init(R, 
NewSItem('~Big~ross', 
NewSItem('~Medium', 
NewSItem('~Small', 
nile))))); 
Insert(View); 
// Label for RadioGroup. 
R.Assign(20, 2, 31, 3); 
Insert(New(PLabel, Init(R, '~Font', View))); 

// Edit line 
R.Assign(3, 10, 32, 11); 
View := New(PInputLine, Init(R, 50)); 
Insert(View); 
// Label for edit line 
R.Assign(2, 9, 10, 10); 
Insert(New(PLabel, Init(R, '~H~inweis', View))); 

// Ok button 
R.Assign(7, 12, 17, 14); 
Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault))); 

// Close button 
R.Assign(19, 12, 32, 14); 
Insert(new(PButton, Init(R, '~A~abort', cmCancel, bfNormal))); 
end; 
if ValidView(Dlg) <> nil then begin // Check whether there is enough memory. 
Dlg^.SetData(ParameterData); // Load dialog with the values. 
dummy := Desktop^.ExecView(Dlg); // Execute dialog. 
if dummy = cmOK then begin // If you end the dialog with Ok, then load data from the dialog into Record. 
Dlg^.GetData(ParameterData); 

// Save data to disk. 
AssignFile(fParameterData, DialogFile); 
Rewrite(fParameterData); 
Write(fParameterData, ParameterData); 
CloseFile(fParameterData); 
end; 

Dispose(Dlg, Done); // Free up dialog and memory. 
end; 
end;
```
