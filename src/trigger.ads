with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with identifier; use identifier;
with screen; use screen;

package trigger is

  type Trigger is record
      ID         : identifier.Identifier;
      X_Position : Positive;
      Y_Position : Positive;
      Message    : String(1 .. Full_Screen_Amt);
  end record;

  type Triggers is array (Positive range 1 .. 500) of Trigger;
  
  blank_trigger : Trigger :=
     (ID         => TRIG9999,
     X_Position  => 1,
     Y_Position  => 1,
     Message     => (NUL, others=>NUL)
     );
  
  tutorial_1 : Trigger :=
     (ID         => TRIG0001,
     X_Position  => 1,
     Y_Position  => 1,
     Message     => "Good! Maybe you've some hope down here after all. I mean, you can walk. Press enter to repeat your last single letter command. Walk to the door to the east." & (157 .. Full_Screen_Amt => NUL)
     );
     
  all_triggers : Triggers := (tutorial_1, others=>blank_trigger);

end trigger;
