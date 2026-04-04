#03 - Dialogues
## 05 - First dialogue

![image.png](image.png)

Processing the events, the status line and the menu.

---
For dialogs you still have to insert the **Dialogs** unit.

```pascal
uses 
App, // TApplication 
Objects, // Window area (TRect) 
Drivers, // Hotkey 
Views, // event (cmQuit) 
Menus, // status line 
dialogue; // Dialogues
```

Another command to open the dialog.

```pascal
const 
cmAbout = 1001; // Show About 
cmList = 1002; // file list 
cmPara = 1003; // Parameters
```

New features are also coming to the class.
Here is a dialog for parameter entry.

```pascal
type.type 
TMyApp = object(TApplication) 
procedure InitStatusLine; virtual; // Status line 
procedure InitMenuBar; virtual; // Menu 
procedure HandleEvent(var Event: TEvent); virtual; // event handler 

procedure MyParameter; // new function for a dialog. 
end;
```

The menu is expanded to include parameters and close.

```pascal 
procedure TMyApp.InitMenuBar; 
var 
R: TRect; // Rectangle for the menu line position. 

M: PMenu; // Entire menu 
SM0, SM1, // Submenu 
M0_0, M0_1, M0_2, M0_3, M0_4, M0_5, 
M1_0: PMenuItem; // Simple menu items 

begin 
GetExtent(R); 
R.B.Y := R.A.Y + 1; 

M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil); 
SM1 := NewSubMenu('~Help', hcNoContext, NewMenu(M1_0), nil); 

M0_5 := NewItem('~B~end', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil); 
M0_4 := NewLine(M0_5); 
M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4); 
M0_2 := NewLine(M0_3); 
M0_1 := NewItem('~Parameter...', '', kbF2, cmPara, hcNoContext, M0_2); 
M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1); 
SM0 := NewSubMenu('~File', hcNoContext, NewMenu(M0_0), SM1); 

M := NewMenu(SM0); 

MenuBar := New(PMenuBar, Init(R, M)); 
end;
```

Here a dialog is opened with the command **cmPara**.

```pascal 
procedure TMyApp.HandleEvent(var Event: TEvent); 
begin 
inherited HandleEvent(Event); 

if Event.What = evCommand then begin 
case Event.Command of 
cmAbout: begin 
end; 
cmList: begin 
end; 
cmPara: begin // Open parameter dialog. 
MyParameters; 
end; 
else begin 
exit; 
end; 
end; 
end; 
ClearEvent(Event); 
end;
```

Building an empty dialog.
**TRect** is also used for the size.
This is needed for all components, whether buttons, etc.

```pascal 
procedure TMyApp.MyParameter; 
var 
Dlg: PDialog; 
R: TRect; 
begin 
R.Assign(0, 0, 35, 15); // Size of the dialog. 
R.Move(23, 3); // Position of the dialog. 
Dlg := New(PDialog, Init(R, 'Parameter')); // Create dialog. 
Desktop^.Insert(Dlg); // Assign dialog to the app. 
end;
```
