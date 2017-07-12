with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with lvl; use lvl;
with dngn; use dngn;
with world; use world;
with scrn; use scrn;
with id; use id;

package camera is
   
   -- Render: L: the level to render. Renders a what is in the level's screen: monsters, players, dungeon tiles.
   function Render (L : in out Level) return Input_Type;
   
   -- Get_Top_tile: L: the level to get tile from. X: x position of tile. Y: y position of tile
   --               Gets top tile, player takes precedence over monsters which take precedence over dungeon tiles
   function Get_Top_Tile (L : Level; X : Positive; Y : Positive) return Tile;
   
   -- Get_Bottom_Tile : L: the level to get tile from. X: x position of tile. Y: y position of tile
   --                   Gets dungeon tile at position
   function Get_Bottom_Tile (L : Level; X : Positive; Y : Positive) return Tile;

end camera;
