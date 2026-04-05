# 04 - Dialogs as Components
## 00 - A Simple About Dialog

![image.png](image.png)

If you need the same dialogs repeatedly, it's best to put them as components in a unit.

To do this, you write a descendant of **TDialog**.

As an example, an About dialog is created here.

---
Here, the About dialog is loaded and then released again when the Close event occurs.

```pascal

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

ClearEvent(Event);

end;

```

---
**Unit with the new dialog.**

```pascal
unit MyDialog;

```

A new constructor must be created for the dialog.

A note about StaticText: to insert a blank line, you must write **#13#32#13**. **#13#13** only inserts a simple line break.

```pascal
interface

uses
App, Objects, Drivers, Views, Dialogs;

type
PMyAbout = ^TMyAbout;

TMyAbout = object(TDialog)

constructor Init; // New constructor that builds the dialog with its components.

end;

```

The dialog components are created in the constructor.

```pascal
implementation

constructor TMyAbout.Init;

var
R: TRect;

begin

R.Assign(0, 0, 42, 11);

R.Move(23, 3);

inherited Init(R, 'About'); // Create a dialog of a defined size.

/ StaticText

R.Assign(5, 2, 41, 8);

Insert(new(PStaticText, Init(R, 
'Free Vision Tutorial 1.0' + #13 + 
'2017' + #13 + 
'Written by M. Burkhard' + #13#32#13 + 
'FPC: '+ {$I %FPCVERSION%} + ' OS:'+ {$I %FPCTARGETOS%} + ' CPU:' + {$I %FPCTARGETCPU%}))); 

// Ok button 
R.Assign(27, 8, 37, 10); 
Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```
