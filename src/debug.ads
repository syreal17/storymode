with Ada.Text_IO; use Ada.Text_IO;
with dngn; use dngn;

package debug is

  procedure Print_Char_Codes ( S : String );
  procedure Print_Board ( D : Dungeon_Room );
  
end debug;
