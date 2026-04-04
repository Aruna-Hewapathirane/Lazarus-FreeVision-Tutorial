# 03 - Dialogues
## 00 - Process event

![image.png](image.png)

Processing the events, the status line and the menu.

---
Commands that are processed.

```pascal
const 
cmAbout = 1001; // Show About 
cmList = 1002; // file list
```

The EventHandler is also a descendant.

```pascal
type.type 
TMyApp = object(TApplication) 
procedure InitStatusLine; virtual; // Status line 
procedure InitMenuBar; virtual; // Menu 
procedure HandleEvent(var Event: TEvent); virtual; // event handler 
end;
```

Processing your own cmxxx commands.

```pascal 
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
```
