# 04 - Dialogs as Components
## 10 - Modifying Components at Runtime

![image.png](image.png)

This example shows how to modify components at runtime.

A button is used, whose label increments with each click.

---
**Unit with the new dialog.**

<br>
The dialog with the counter button.

```pascal
unit MyDialog;

```

To modify a component at runtime, you must declare it; otherwise, you can no longer access it.

Using **Insert(New(...)** directly no longer works.

```pascal
type
PMyDialog = ^TMyDialog;

TMyDialog = object(TDialog)
CounterButton: PButton; // Button with counter.

constructor Init;

procedure HandleEvent(var Event: TEvent); virtual;

end;

```

In the constructor, you can see that the workaround is via the **CounterButton**.

**CounterButton** is needed for the modification.

```pascal
const
cmCounter = 1003; // Used locally for the counter button.

constructor TMyDialog.Init;

var
R: TRect;

begin

R.Assign(0, 0, 42, 11);

R.Move(23, 3);

inherited Init(R, 'My Dialog');

/ StaticText
R.Assign(5, 2, 41, 8);

Insert(new(PStaticText, Init(R, 'Right Button z' + #132 + 'increments counter')));

// Button that changes the title.

R.Assign(19, 8, 32, 10);

CounterButton := new(PButton, Init(R, ' ', cmCounter, bfNormal));

CounterButton^.Title^ := '1';

Insert(CounterButton);

// OK button

R.Assign(7, 8, 17, 10);

Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

end;

```

In the event handle, the number on the button is incremented when pressed.

This shows why the **CounterButton** is needed; without it, there would be no access to the **Title**.

Important if When you change a component, you must redraw it using **Draw**; otherwise, the changed value won't be visible.

```pascal

procedure TMyDialog.HandleEvent(var Event: TEvent);

var
Counter: integer;

begin

inherited HandleEvent(Event);

case Event.What of

evCommand: begin

case Event.Command of
cmCounter: begin

Counter := StrToInt(CounterButton^.Title^); // Read the button's title.

Inc(Counter); // Increment the counter.

if Counter > 9999 then begin // Check for overflow, as only 4 characters are available.

Counter := 9999;

end;

CounterButton^.Title^ := IntToStr(Counter); // Assign the new title to the button.

CounterButton^.Draw; // Redraw the button.

ClearEvent(Event); // End the event.

end;

end;

end;

end;


end;


```
