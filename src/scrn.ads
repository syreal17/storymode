with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package scrn is

  Screen_X_Length : Positive := 115;
  Screen_Y_Length : Positive := 28;
  Full_Screen_Amt : Positive := (Screen_X_Length + 1 + 1) * (Screen_Y_Length + 1);
   
   type Screen is record
      X_Length   : Positive;
      Y_Length   : Positive;
      X_Position : Positive;
      Y_Position : Positive;
      Message    : String(1 .. Full_Screen_Amt );
   end record; 

   procedure Append_Line_Message(Scrn : in out Screen; S : String);

end scrn;
