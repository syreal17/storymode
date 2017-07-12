with Ada.Text_IO; use Ada.Text_IO;
with dngn; use dngn;

package debug is

   --Print_Char_Codes: S: the string to print char codes. Prints numeric representation for each cahracter
   --                  for an entire string.
   procedure Print_Char_Codes ( S : String );
  
   --Print_Board: D: the room from which to print a board. Used to verify that board is what we expect
   procedure Print_Board ( D : Dungeon_Room );
  
end debug;
