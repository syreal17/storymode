with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with level; use level;
with dungeon; use dungeon;
with world; use world;
with screen; use screen;

package camera is
   
   --function Get_Render_Message(S : String) return String(1 .. (Screen_X_Length + 1) * (Screen_Y_Length + 1) );
   procedure Render (L : in out level.Level);
   function Get_Tile (L : level.Level; X : Positive; Y : Positive) return Tile;

end camera;
