//image image.png
(*
An about dialog is created here, which shows clearly what labels can be used for.
*)
//ruler
programProject1;

uses 
SysUtils, // For file operations 
App, // TApplication 
Objects, // Window area (TRect) 
Drivers, // Hotkey 
Views, // event (cmQuit) 
Menus, // status line 
MsgBox, // message boxes 
dialogue; // Dialogues

(*
The file in which the data for the dialog is located.
*)
//code+
const 
DialogFile = 'parameter.cfg'; 
//code- 

cmAbout = 1001; // Show About 
cmList = 1002; // file list 
cmPara = 1003; // Parameters

type.type 
TParameterData = record 
pressure, 
font: longword; 
Note: string[50]; 
end;

(*
A new function <b>About</b> has been added.
*) 
//code+
type.type 
TMyApp = object(TApplication) 
ParameterData: TParameterData; // Parameters for dialog. 
fParameterData: file of TParameterData; // File hander for saving/loading the dialog data. 

constructor Init; // New constructor 

procedure InitStatusLine; virtual; // Status line 
procedure InitMenuBar; virtual; // Menu 
procedure HandleEvent(var Event: TEvent); virtual; // event handler 
procedure OutOfMemory; virtual; // Called when memory overflows. 

procedure MyParameter; // new function for a dialog. 
procedure About; // About Dialog. 
end; 
//code- 

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

procedure TMyApp.InitStatusLine; 
var 
R: TRect; // Rectangle for the status line position. 

P0: PStatusDef; // Pointer entire entry. 
P1, P2, P3: PStatusItem; // Poniter on the individual hot key. 
begin 
GetExtent(R); 
R.A.Y := R.B.Y - 1; 

P3 := NewStatusKey('~F1~ Help', kbF1, cmHelp, nil); 
P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3); 
P1 := NewStatusKey('~Alt+X~ Quit program', kbAltX, cmQuit, P2); 
P0 := NewStatusDef(0, $FFFF, P1, nil); 

StatusLine := New(PStatusLine, Init(R, P0)); 
end; 

procedure TMyApp.InitMenuBar; 
var 
R: TRect; // Rectangle for the menu line position. 

M: PMenu; // Entire menu 
SM0, SM1, SM2, // Submenu 
M0_0, M0_2, M0_3, M0_4, M0_5, 
M1_0, M2_0: PMenuItem; // Simple menu items 

begin 
GetExtent(R); 
R.B.Y := R.A.Y + 1; 

M2_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil); 
SM2 := NewSubMenu('~Help', hcNoContext, NewMenu(M2_0), nil); 

M1_0 := NewItem('~Parameter...', '', kbF2, cmPara, hcNoContext, nil); 
SM1 := NewSubMenu('~O~ption', hcNoContext, NewMenu(M1_0), SM2); 

M0_5 := NewItem('~B~end', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil); 
M0_4 := NewLine(M0_5); 
M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4); 
M0_2 := NewLine(M0_3); 
M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_2); 
SM0 := NewSubMenu('~File', hcNoContext, NewMenu(M0_0), SM1); 

M := NewMenu(SM0); 

MenuBar := New(PMenuBar, Init(R, M)); 
end;

(*
Here the About is called, which is selected in the About menu.
*) 
//code+ 
procedure TMyApp.HandleEvent(var Event: TEvent); 
begin 
inherited HandleEvent(Event); 

if Event.What = evCommand then begin 
case Event.Command of 
cmAbout: begin 
About; // Call About dialog 
end; 
cmList: begin 
end; 
cmPara: begin 
MyParameters; 
end; 
else begin 
exit; 
end; 
end; 
end; 
ClearEvent(Event); 
end; 
//code- 

procedure TMyApp.OutOfMemory; 
begin 
MessageBox('Too little memory !', nil, mfError + mfOkButton); 
end; 

procedure TMyApp.MyParameter; 
var 
Slide: PDialog; 
R: TRect; 
dummy: word; 
Ptr: PView; 
begin 
R.Assign(0, 0, 35, 15); 
R.Move(23, 3); 
Dia := New(PDialog, Init(R, 'Parameter')); 
with Dia^ do begin 

// CheckBoxes 
R.Assign(2, 3, 18, 7); 
Ptr := New(PCheckBoxes, Init(R, 
NewSItem('~File', 
NewSItem('~row~row', 
NewSItem('D~a~tum', 
NewSItem('~Time~', 
nil)))))); 
Insert(Ptr); 
// Label for CheckGroup. 
R.Assign(2, 2, 10, 3); 
Insert(New(PLabel, Init(R, 'Press', Ptr))); 

// RadioButto
