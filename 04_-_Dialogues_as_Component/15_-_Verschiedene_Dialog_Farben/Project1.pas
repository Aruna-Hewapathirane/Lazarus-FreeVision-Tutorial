//image image.png
(*
Different color schemes can be assigned to windows/dialogs.
By default, the following is used:

//code+
Editor window: Blue
Dialog: Gray
Help window: Cyan

//code-

Without any action, windows/dialogs always appear in the correct color. Modifying this is only useful in special cases.

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

R: TRect; // Rectangle for the status line position.

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

Desktop^.ExecView(MyDialog); // Execute the dialog.

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
The three buttons at the top allow you to change the dialog's color scheme.

*)
//includepascal mydialog.pas head

(*
Three event constants have been added here.

*)
//includepascal mydialog.pas type

(*
Building the dialog is nothing special.

*)
//includepascal mydialog.pas init

(*
Here, the color schemes are changed using <b>Palette := dpxxx</b>.

It's also important to call <b>Draw</b> here, this time not for a single component, but for the entire dialog.

*)
//includepascal mydialog.pas handleevent

end.
