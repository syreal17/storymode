package body debug is

   procedure Print_Char_Codes ( S : String ) is
   begin
      for C of S loop
         Put( Integer'Image(Character'Pos(C)) & " ");
         --Put(C);
      end loop;
      Put_Line("");
   end;
   
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
