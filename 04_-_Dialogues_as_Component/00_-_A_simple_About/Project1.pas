//image image.png
(*
If you need the same dialogs repeatedly, it's best to put them as a component in a unit.
To do this, write a descendant of <b>TDialog</b>.
As an example, an About dialog is built here.
*)
//ruleral
program Project1;

uses
App, // TApplication
Objects, // Window area (TRect)
Drivers, // Hotkey
Views, // Events (cmQuit)
Menus, // Status bar
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
NewSubMenu('~D~atei', hcNoContext, NewMenu(
NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),

NewSubMenu('~H~ilfe', hcNoContext, NewMenu(
NewItem('~A~bout...', 'F1', kbF1, cmAbout, hcNoContext, nil)), nil)))));
end;

(*
The About dialog is loaded here and then released again when the app is closed.

*)

//code+

procedure TMyApp.HandleEvent(var Event: TEvent);

var

AboutDialog: PMyAbout;

begin

inherited HandleEvent(Event);


if Event.What = evCommand then begin

case Event.Command of

cmAbout: begin

AboutDialog := New(PMyAbout, Init); // Create a new dialog.

if ValidView(AboutDialog) <> nil then begin // Check if there is enough memory.

Desktop^.ExecView(AboutDialog); // Execute the About dialog.

Dispose(AboutDialog, Done); // Release the dialog and memory.

end;

end;

else begin

Exit;

end;

end;

end;

ClearEvent(Event);

end;

//code-

procedure TMyApp.OutOfMemory;

begin

MessageBox('Not enough memory!', nil, mfError + mfOkButton);

end;

var

MyApp: TMyApp;

begin

MyApp.Init; // Initialize
MyApp.Run; // Process
MyApp.Done; // Release
//ruler
(*
<b>Unit with the new dialog.</b>
*)

//includepascal mydialog.pas head

(*
A new constructor must be created for the dialog.
A note about StaticText: to insert a blank line, you must write <b>#13#32#13</b>. <b>#13#13</b> will only insert a simple line break.
*)
//includepascal mydialog.pas interface

(*
The dialog components are created in the constructor.
*)
//includepascal mydialog.pas implementation

end.
