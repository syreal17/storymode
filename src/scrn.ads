with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package scrn is

  --good defaults for windows console
  Screen_X_Length : Positive := 115;
  Screen_Y_Length : Positive := 28;
  Full_Screen_Amt : Positive := (Screen_X_Length + 1 + 1) * (Screen_Y_Length + 1);
   
   type Screen is record
      X_Length   : Positive;
      Y_Length   : Positive;
      X_Position : Positive;
      Y_Position : Positive;
      Message    : String(1 .. Full_Screen_Amt );
      Loot       : String(1 .. Full_Screen_Amt);
      Loot_X     : Positive;
      Loot_Y     : Positive;
   end record; 

   --Append_Line_Message: Scrn: screen to change, S: string to append
   procedure Append_Line_Message(Scrn : in out Screen; S : String);

end scrn;
