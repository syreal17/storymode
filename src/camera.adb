package body camera is

   procedure Render (L : level.Level) is
      Screen_X_min : Positive := L.Current_Screen.X_Position;
      Screen_X_max : Positive := Screen_X_min + L.Current_Screen.X_Length;
      Screen_Y_min : Positive := L.Current_Screen.Y_Position;
      Screen_Y_max : Positive := Screen_Y_min + L.Current_Screen.Y_Length;
      --Screen       : String(1 .. (L.Current_Screen.X_Length + 2)*L.Current_Screen.Y_Length);
      Screen       : String(1 .. (Screen_X_max - Screen_X_min + 1 + 1) * (Screen_Y_max - Screen_Y_min + 1) );
      J            : Positive := 1;
   begin
   
   --Put_Line(Positive'Image(Screen_X_min));
   --Put_Line(Positive'Image(Screen_X_max));
   --Put_Line(Positive'Image(Screen_Y_min));
   --Put_Line(Positive'Image(Screen_Y_max)); 
   
   
   
      for Y in Screen_Y_min .. Screen_Y_max loop
         for X in Screen_X_min .. Screen_X_max loop
            --Put(Get_Tile(L, X, Y));          
            --Put(Positive'Image(J));
            Screen(J) := Get_Tile(L, X, Y);
            J := J + 1;
         end loop;
         --Put_Line("");
         Screen(J) := LF;
         J := J + 1;
      end loop;
      Put(Screen);
   end;
   
   function Get_Tile (L : level.Level; X : Positive; Y : Positive) return Character is
      R       : Dungeon_Room;
      T       : Tile;
      R_rel_X : Positive;
      R_rel_Y : Positive;
   begin
      if Is_Player(L, X, Y) then
         return 'U';
      elsif Is_Room(L, X, Y) then
         --return '.';
         R := Get_Room(L, X, Y);
         R_rel_X := X - (R.X_Position - 1);
         R_rel_Y := Y - (R.Y_position - 1);
         T := R.Board(R_rel_X, R_rel_Y);
         --TODO: creat array indexed by Tile and containing a Character
         if R.Discovered then
            return display_tiles(T);
         else
            return ' ';
         end if;
      end if;
      return ' ';
   end Get_Tile;
   
end camera;
