//image image.png
(*
In inherited dialogs, it's possible to include buttons that perform an action locally within the dialog.
In this example, a MessageBox is displayed.

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
NewItem('~Exit', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),

NewSubMenu('~Help', hcNoContext, NewMenu(
NewItem('~About...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));
end;


(*) Nothing changes in the main program; it doesn't care if something else is done locally.

*)

//code+

procedure TMyApp.HandleEvent(var Event: TEvent);

var

AboutDialog: PMyAbout;

begin

inherited HandleEvent(Event);


``` if Event.What = evCommand then begin

case Event.Command of // About Dialog

cmAbout: begin

AboutDialog := New(PMyAbout, Init);

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

MyApp.Run; // Processing

MyApp.Done; // Release

//ruler
(*
<b>Unit with the new dialog.</b>

<br>
You can clearly see that it has a button for local events.

It's important that the numbering doesn't overlap with another event number.

Especially if the dialog isn't opened modally.

Unless it's desired, for example, if you want to access the dialog via the menu.

*)
//includepascal mydialog.pas head

(*
A HandleEvent is added for the dialog.

*)
//includepascal mydialog.pas type

(*
In the constructor, the dialog is further enhanced with the Msg-box button, which handles the local event <b>cmMsg</b>.

*)
//includepascal mydialog.pas init

(*
In the new EventHandle, local events (cmMsg) are handled. The dialog is processed.

Other events, e.g., <b>cmOk</b>, are passed to the main program, which then closes the dialog.

*)

//includepascal mydialog.pas handleevent

end.
