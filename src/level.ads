with dungeon; use dungeon;
with screen; use screen;
with player; use player;

package level is

   type Level is record
      Current_Dungeon     : dungeon.Dungeon;
      Current_Screen      : screen.Screen;
      Current_Player      : player.Player;
      Current_Rooms       : Rooms;
      Current_Rooms_Count : Positive;
   end record; 

end level;
