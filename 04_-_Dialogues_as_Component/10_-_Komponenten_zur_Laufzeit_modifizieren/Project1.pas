//image image.png
(*
This example shows how to modify components at runtime.

It uses a button whose label increments with each click.

*)

program Project1;

uses

App, // TApplication

Objects, // Window area (TRect)

Drivers, // Hotkey

Views, // Events (cmQuit)

Menu, // Status bar

MsgBox, // Message boxes

Dialogs, // Dialogs

MyDialog;

const

cmAbout = 1001; // Display About

type

TMyApp = object(TApplication)

procedure InitStatusLine; virtual; // Status bar

procedure InitMenuBar; virtual; // Menu

procedure HandleEvent(var Event: TEvent); virtual; // Event handler

procedure OutOfMemory; virtual; // Called when memory overflows.

end;

procedure TMyApp.InitStatusLine;

var
R: TRect; // Rectangle for the status bar position.

begin

GetExtent(R);

R.A.Y := R.B.Y - 1;

StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,

NewStatusKey('~Alt+X~ Exit Program', kbAltX, cmQuit,

NewStatusKey('~F10~ Menu', kbF10, cmMenu,

NewStatusKey('~F1~ About...', kbF1, cmAbout, nil))), nil)));

end;

procedure TMyApp.InitMenuBar;

var

R: TRect; // Rectangle for the menu bar position.

begin

GetExtent(R);

R.B.Y := R.A.Y + 1;

MenuBar := New(PMenuBar, Init(R, NewMenu( 
NewSubMenu('~File', hcNoContext, NewMenu( 
NewItem('~B~end', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)), 
NewSubMenu('~O~ption', hcNoContext, NewMenu( 
NewItem('Dia~l~og...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))); 
end; 

procedure TMyApp.HandleEvent(var Event: TEvent); 
var 
MyDialog: PMyDialog; 
begin 
inherited HandleEvent(Event); 

if Event.What = evCommand then begin

case Event.Command of // About Dialog

cmAbout: begin

MyDialog := New(PMyDialog, Init);

if ValidView(MyDialog) <> nil then begin // Check if there is enough memory.

Desktop^.ExecView(MyDialog); // Execute the About dialog.

Dispose(MyDialog, Done); // Release the dialog and memory.

end;

end;

else begin

Exit;

end;

end;

end;

ClearEvent(Event);

end;

procedure TMyApp.OutOfMemory;

begin

MessageBox('Not enough memory!', nil, mfError + mfOkButton);

end;

var

MyApp: TMyApp;

begin

MyApp.Init; // Initialize

MyApp.Run; // Execute

MyApp.Done; // Release

//ruler
(*
<b>Unit with the new dialog.</b>

<br>
The dialog with the counter button.

*)
//includepas mydialog.pas head

(*
If you want to modify a component at runtime, you have to declare it; otherwise, you can no longer access it. Directly using <b>Insert(New(...</b>) is no longer possible.

*)
//includepascal mydialog.pas type

(*
In the constructor, you can see that you're taking a detour via the <b>CounterButton</b>.

<b>CounterButton</b> is needed for the modification.

*)
//includepascal mydialog.pas init

(*
In the event handle, the number in the button is incremented when it's pressed. This shows why you need the <b>CounterButton</b>; without it, you wouldn't have access to <b>Title</b>

Important: When modifying a component, you must redraw it using <b>Draw</b>; otherwise, the changed value will not be visible.

*)

//includepascal mydialog.pas handleevent

end.
