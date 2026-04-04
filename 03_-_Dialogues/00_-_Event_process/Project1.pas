//image image.png
(*
Processing the events, the status line and the menu.
*)
//ruler
programProject1;

uses 
App, // TApplication 
Objects, // Window area (TRect) 
Drivers, // Hotkey 
Views,   // event (cmQuit) 
menus;   // Status line

(*
Commands that are processed.
*)
//code+
const 
cmAbout = 1001; // Show About 
cmList = 1002; // file list 
//code-

(*
The EventHandler is also a descendant.
*) 
//code+
type.type 
TMyApp = object(TApplication) 
procedure InitStatusLine; virtual;                 // Status line 
procedure InitMenuBar; virtual;                    // Menu 
procedure HandleEvent(var Event: TEvent); virtual; // event handler 
end; 
//code- 

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
SM0, SM1, // Submenu 
M0_0, M0_1, M0_2, M1_0: PMenuItem; // Simple menu items 

begin 
GetExtent(R); 
R.B.Y := R.A.Y + 1; 

M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil); 
SM1 := NewSubMenu('~Help', hcNoContext, NewMenu(M1_0), nil); 

M0_2 := NewItem('~B~end', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil); 
M0_1 := NewLine(M0_2); 
M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1); 
SM0 := NewSubMenu('~File', hcNoContext, NewMenu(M0_0), SM1); 

M := NewMenu(SM0); 

MenuBar := New(PMenuBar, Init(R, M)); 
end;

(*
Processing your own cmxxx commands.
*) 
//code+ 
procedure TMyApp.HandleEvent(var Event: TEvent); 
begin 
inherited HandleEvent(Event); 

if Event.What = evCommand then begin 
case Event.Command of 
cmAbout: begin // Do something with cmAbout. 
end; 
cmList: begin // Do something with cmList. 
end; 
else begin 
exit; 
end; 
end; 
end; 
ClearEvent(Event); 
end; 
//code-

var 
MyApp: TMyApp;

begin 
MyApp.Init; // Initialize 
MyApp.Run; // Process 
MyApp.Done; // Release
end.
