//head+
unit MyDialog;
//head-

interface

uses 
App, Objects, Drivers, Views, MsgBox, Dialogs;

//type+
type.type 
PMyAbout = ^TMyAbout; 
TMyAbout = object(TDialog) 
constructor Init; 
procedure HandleEvent(var Event: TEvent); virtual; 
end;
//type-

implementation

//init+
const 
cmMsg = 1003; // Local event

constructor TMyAbout.Init;
var 
R: TRect;
begin 
R.Assign(0, 0, 42, 11); 
R.Move(23, 3); 
inherited Init(R, 'About'); 

// StaticText 
R.Assign(5, 2, 41, 8); 
Insert(new(PStaticText, Init(R, 
'Free Vision Tutorial 1.0' + #13 + 
'2017' + #13 + 
'Written by MB'+ #13#32#13 + 
'FPC: '+ {$I %FPCVERSION%} + ' OS:'+ {$I %FPCTARGETOS%} + ' CPU:' + {$I %FPCTARGETCPU%}))); 

// MessageBox button, with local event. 
R.Assign(19, 8, 32, 10); 
Insert(new(PButton, Init(R, '~M~sg-Box', cmMsg, bfNormal))); 

// Ok button 
R.Assign(7, 8, 17, 10); 
Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyAbout.HandleEvent(var Event: TEvent);
begin 
inherited HandleEvent(Event); 

case Event.What of 
evCommand: begin 
case Event.Command of 
// Execute local event. 
cmMsg: begin 
MessageBox('I am a MessageBox !', nil, mfOKButton); 
ClearEvent(Event); // End event. 
end; 
end; 
end; 
end;

end;
//handleevent-

end.
