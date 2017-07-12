package plyr is

  type Player is record
      X_Position      : Positive;
      Y_Position      : Positive;
      XP              : Positive;
      HP              : Integer;
      LVL             : Natural;
      PHYSICALITY     : Positive;
      MYSTICISM       : Positive;
      BALANCE         : Positive;
      Armor           : Natural;
      Alive           : Boolean;
      --Melee           : Positive;
      --Manamancy       : Positive;
      --Sneak           : Positive;
      --Sprint          : Positive;
      --Search          : Positive;
  end record; 

end plyr;
