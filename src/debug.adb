package body debug is

   --Print_Char_Codes: S: the string to print char codes. Prints numeric representation for each cahracter
   --                  for an entire string.
   procedure Print_Char_Codes ( S : String ) is
   begin
      for C of S loop
         Put( Integer'Image(Character'Pos(C)) & " ");
         --Put(C);
      end loop;
      Put_Line("");
   end;
   
   --Print_Board: D: the room from which to print a board. Used to verify that board is what we expect 
   procedure Print_Board ( D : Dungeon_Room ) is
   begin
      for Y in 1 .. D.Y_Length loop
         for X in 1 .. D.X_Length loop
            put(display_tiles(D.Board(X,Y)));
         end loop;
         put_line("");
      end loop;
   end;
   
end debug;
