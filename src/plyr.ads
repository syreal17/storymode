package plyr is

  type Player is record
      X_Position      : Positive;
      Y_Position      : Positive;
      XP              : Positive;
      HP              : Positive;
      LVL             : Natural;
      PHYSICALITY     : Positive;
      MYSTICISM       : Positive;
      BALANCE         : Positive;
      Melee           : Positive;
      Manamancy       : Positive;
      Sneak           : Positive;
      Sprint          : Positive;
      Search          : Positive;
  end record; 

end plyr;
