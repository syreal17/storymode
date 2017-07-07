package screen is

  Screen_X_Length : Positive := 115;
  Screen_Y_Length : Positive := 28;
   
   type Screen is record
      X_Length   : Positive;
      Y_Length   : Positive;
      X_Position : Positive;
      Y_Position : Positive;
   end record; 

end screen;
