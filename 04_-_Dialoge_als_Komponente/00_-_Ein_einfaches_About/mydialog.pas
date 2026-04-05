//head+
unit MyDialog;

/head-

//interface+
interface

uses
App, Objects, Drivers, Views, Dialogs;

type
PMyAbout = ^TMyAbout;

TMyAbout = object(TDialog)

constructor Init; // New constructor that builds the dialog with the components.

end;

//interface-

//implementation+
implementation

constructor TMyAbout.Init;

var
R: TRect;

begin

R.Assign(0, 0, 42, 11);

R.Move(23, 3);

inherited Init(R, 'About'); // Create a dialog of a defined size.

// StaticText

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
//implementation-

end.
