with dngn; use dngn;
with scrn; use scrn;
with plyr; use plyr;
with trgr; use trgr;

package lvl is

   type Level is record
      Current_Dungeon     : Dungeon;
      Current_Screen      : Screen;
      Current_Player      : Player;
      Current_Rooms       : Rooms;
      Current_Rooms_Count : Positive;
      Current_Triggers    : Triggers;
      Current_Triggers_Count: Natural;
   end record; 

end lvl;
