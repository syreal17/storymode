package body camera is

   function Render (L : in out Level) return Input_Type is
      Screen_X_min : Positive := L.Current_Screen.X_Position;
      Screen_X_max : Positive := Screen_X_min + L.Current_Screen.X_Length;
      Screen_Y_min : Positive := L.Current_Screen.Y_Position;
      Screen_Y_max : Positive := Screen_Y_min + L.Current_Screen.Y_Length;
      Screen       : String(1 .. Full_Screen_Amt );
      J            : Positive := 1;
      I            : Positive := 1;
      Print_Message: Boolean := True;
   begin
   
      for Y in Screen_Y_min .. Screen_Y_max loop
         for X in Screen_X_min .. Screen_X_max loop
            if L.Current_Screen.Message(I) = NUL then
               Print_Message := False;
            end if;
            
            if Print_Message then
               Screen(J) := L.Current_Screen.Message(I);
               --L.Current_Screen.Message(I) := NUL;
               I := I + 1;
            else
               Screen(J) := display_tiles(Get_Tile(L, X, Y));
            end if;
            J := J + 1;
         end loop;
         --Put_Line("");
         Screen(J) := LF;
         J := J + 1;
      end loop;
      Put(Screen);
      if I >= 2 then
         Put("Continue (y/n)? ");
         return Continue_Text;
      else
         Put("Action: ");
         return Dungeon_Action;
      end if;
      
   end;
   
   function Get_Tile (L : Level; X : Positive; Y : Positive) return Tile is
      R       : Dungeon_Room;
      T       : Tile;
      R_rel_X : Positive;
      R_rel_Y : Positive;
   begin
      if Is_Player(L, X, Y) then
         return abbr_tiles(Player_Tile);
      elsif Is_Room(L, X, Y) then
         --return '.';
         R := Get_Room(L, X, Y);
         --TODO: create function for relative X and Y (rooms and screen)
         R_rel_X := X - (R.X_Position - 1);
         R_rel_Y := Y - (R.Y_position - 1);
         T := R.Board(R_rel_X, R_rel_Y);
         --TODO: add R.Visible as well
         if R.Discovered then
            return T;
         else
            return abbr_tiles(Nothing);
         end if;
      end if;
      return abbr_tiles(Nothing);
   end Get_Tile;
   
   --function Get_Render_Message(S : String) return String(1 .. (Screen_X_Length + 1) * (Screen_Y_Length + 1) ) is
   --begin
   --   for C of S loop:
   --      
   --end Get_Render_Message;
   
end camera;
