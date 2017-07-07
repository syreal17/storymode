with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with level; use level;
with dungeon; use dungeon;
with world; use world;

package camera is
   
   procedure Render (L : level.Level);
   function Get_Tile (L : level.Level; X : Positive; Y : Positive) return Tile;

end camera;
