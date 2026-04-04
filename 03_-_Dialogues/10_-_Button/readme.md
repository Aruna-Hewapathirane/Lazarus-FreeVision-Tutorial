# 03 - Dialogues
## 10 - button

![image.png](image.png)

Add buttons to the dialog.

---
Add buttons to the dialog.
With **Insert** you add the components, in this case they are the buttons.
With bfDefault you set the default button, which is activated with **[Enter]**.
bfNormal is a normal button.
The dialog is now opened modal, so **no** further dialogs can be opened.
dummy has the value of the button that was pressed, this corresponds to the **cmxxx** value.
The height of the buttons must always be **2**, otherwise there will be an incorrect display.

```pascal 
procedure TMyApp.MyParameter; 
var 
Dlg: PDialog; 
R: TRect; 
dummy: word; 
begin 
R.Assign(0, 0, 35, 15); // Size of the dialog. 
R.Move(23, 3); // Position of the dialog. 
Dlg := New(PDialog, Init(R, 'Parameter')); // Create dialog. 
with Dlg^ do begin 

// Ok button 
R.Assign(7, 12, 17, 14); 
Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault))); 

// Close button 
R.Move(12, 0); 
Insert(new(PButton, Init(R, '~A~abort', cmCancel, bfNormal))); 
end; 
dummy := Desktop^.ExecView(Dlg); // Open dialog modal. 
Dispose(Dlg, Done); // Free up dialog and memory. 
end;
```
