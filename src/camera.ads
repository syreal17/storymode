with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with lvl; use lvl;
with dngn; use dngn;
with world; use world;
with scrn; use scrn;
with id; use id;

package camera is
   
   --function Get_Render_Message(S : String) return String(1 .. (Screen_X_Length + 1) * (Screen_Y_Length + 1) );
   function Render (L : in out Level) return Input_Type;
   function Get_Top_Tile (L : Level; X : Positive; Y : Positive) return Tile;
   function Get_Bottom_Tile (L : Level; X : Positive; Y : Positive) return Tile;

end camera;
