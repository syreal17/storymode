with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with id; use id;
with scrn; use scrn;

package trgr is

  type Trigger is record
      ID         : Identifier;
      X_Position : Positive;
      Y_Position : Positive;
      Triggered  : Boolean;
      Message    : String(1 .. Full_Screen_Amt);
  end record;

  type Triggers is array (Positive range 1 .. 500) of Trigger;
  
  blank_trigger : Trigger :=
     (ID         => TRIG9999,
     X_Position  => 1,
     Y_Position  => 1,
     Triggered   => False,
     Message     => (NUL, others=>NUL)
     );
  
  tutorial_1 : Trigger :=
     (ID         => TRIG0001,
     X_Position  => 1,
     Y_Position  => 1,
     Triggered   => False,
     Message     => "'Good! Maybe you've some hope down here after all. I mean, you can walk. Press enter to repeat your last single letter command. Walk to the door to the east.'" & (159 .. Full_Screen_Amt => NUL)
     );
     
  tutorial_2 : Trigger :=
     (ID         => TRIG0002,
     X_Position  => 1,
     Y_Position  => 1,
     Triggered   => False,
     Message     => "'Enter 'a' to move to the west.'" & (33 .. Full_Screen_Amt => NUL)
     );
     
  tutorial_3 : Trigger :=
     (ID         => TRIG0003,
     X_Position  => 1,
     Y_Position  => 1,
     Triggered   => False,
     Message     => "'Enter 's' to move to the south.'" & (34 .. Full_Screen_Amt => NUL)
     );
     
  tutorial_4 : Trigger :=
     (ID         => TRIG0004,
     X_Position  => 1,
     Y_Position  => 1,
     Triggered   => False,
     Message     => "'Enter 'w' to move to the north.'" & (34 .. Full_Screen_Amt => NUL)
     );

   tutorial_5 : Trigger :=
     (ID         => TRIG0005,
     X_Position  => 1,
     Y_Position  => 1,
     Triggered   => False,
     Message     => "'Enter 'a' to check the west wall for a secret door.'" & (54 .. Full_Screen_Amt => NUL)
     );

  all_triggers : Triggers := (tutorial_1, tutorial_2, tutorial_3, tutorial_4, tutorial_5, others=>blank_trigger);

end trgr;
