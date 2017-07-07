package body interpreter is

   procedure Interpret (L : in out level.Level; S : String) is
   begin
      --Print_Char_Codes(S);
      if S = com_a then
         Move_Left(L);
      elsif S = com_d then
         Move_Right(L);
         --Put_line("move right");
      elsif S = com_w then
         Move_Up(L);
      elsif S = com_s then
         Move_Down(L);
      end if;
   end;
   
   procedure Open_Door(L : level.Level; X : Positive; Y : Positive) is
      D : Dungeon_Room;
      Room_X : Positive;
      Room_Y : Positive;
   begin
   --TODO: create function for getting room relative x,y
      D := Get_Room(L, X, Y);
      Room_X := X - D.X_Position + 1;
      Room_Y := Y - D.Y_Position + 1;
      D.Board(Room_X, Room_Y) := O;
      Print_Board(D);
   end Open_Door;
   
   --TODO: move not based on display tile, but underlying abstract tile
   procedure Move_Up(L : in out level.Level) is
   begin
      if L.Current_Player.Y_Position > 1 then
         if Get_Tile(L, L.Current_Player.X_Position, L.Current_Player.Y_Position - 1) = display_tiles(F) then
            L.Current_Player.X_Position := L.Current_Player.Y_Position - 1;
         end if;
      end if;
   end Move_Up;
   
   procedure Move_Down(L : in out level.Level) is
   begin
      if L.Current_Player.Y_Position < L.Current_Dungeon.Y_Length then
         if Get_Tile(L, L.Current_Player.X_Position, L.Current_Player.Y_Position + 1) = display_tiles(F) then
            L.Current_Player.X_Position := L.Current_Player.Y_Position + 1;
         end if;
      end if;
   end Move_Down;
   
   procedure Move_Left(L : in out level.Level) is
   begin
      if L.Current_Player.X_Position > 1 then
         if Get_Tile(L, L.Current_Player.X_Position -1, L.Current_Player.Y_Position) = display_tiles(F) then
            L.Current_Player.X_Position := L.Current_Player.X_Position - 1;
         end if;
         --Put_Line("move left");
      end if;
   end Move_Left;
   
   procedure Move_Right(L : in out level.Level) is
   begin
      if L.Current_Player.X_Position < L.Current_Dungeon.X_Length then
         if Get_Tile(L, L.Current_Player.X_Position + 1, L.Current_Player.Y_Position) = display_tiles(F) then
            L.Current_Player.X_Position := L.Current_Player.X_Position + 1;
         elsif Get_Tile(L, L.Current_Player.X_Position + 1, L.Current_Player.Y_Position) = display_tiles(D) then
            Put_Line("Here");
            Open_Door(L, L.Current_Player.X_Position + 1, L.Current_Player.Y_Position);
         end if;
      end if;
   end Move_Right;
   
end interpreter;
