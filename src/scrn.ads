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

end scrn;
