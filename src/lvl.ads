with dngn; use dngn;
with scrn; use scrn;
with plyr; use plyr;
with trgr; use trgr;
with mnstr; use mnstr;

package lvl is

   type Level is record
      Current_Dungeon     : Dungeon;
      Current_Screen      : Screen;
      Current_Player      : Player;
      Current_Rooms       : Rooms;
      Current_Rooms_Count : Positive;
      Current_Triggers    : Triggers;
      Current_Triggers_Count: Natural;
      Current_Monsters    : Monsters;
      Current_Monsters_Count : Natural;
   end record; 

end lvl;
