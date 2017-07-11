package body interpreter is

   function Interpret (L : in out Level; S : String; IT : Input_Type) return Boolean is
   begin
      --Print_Char_Codes(S);
      if IT = Dungeon_Action then
         if S = com_a then
            Move_Left(L);
         elsif S = com_d then
            Move_Right(L);
         elsif S = com_w then
            Move_Up(L);
         elsif S = com_s then
            Move_Down(L);
         elsif S = com_q then
            return False;
         end if;
      elsif IT = Continue_Text then
         if S = com_y then
            L.Current_Screen.Message := (NUL, others=>NUL);
         end if;
      end if;
      return True;
   end;
   
   procedure Discover_Monsters(L : in out Level; D : Dungeon_Room) is
      I : Positive := 1;
      M : Monster;
      D_M : Dungeon_Room;
   begin
      for I in 1 .. L.Current_Monsters_Count loop
         M := L.Current_Monsters(I);
         D_M := Get_Room(L, M.X_Position, M.Y_Position);
         if D_M.ID = D.ID then
            L.Current_Monsters(I).Visible := True;
         end if;
      end loop;
   end Discover_Monsters;
   
   procedure Discover(L : in out Level; X : Positive; Y : Positive; Old_D : Dungeon_Room) is
      New_D : Dungeon_Room;
   begin
      if Is_Room(L, X, Y) then
         New_D := Get_Room(L, X, Y);
         if Old_D.ID /= New_D.ID and New_D.Discovered = False then
            New_D.Discovered := True;
            L.Current_Player.XP := L.Current_Player.XP + New_D.XP;
            Discover_Monsters(L, New_D);
            Update_Room(L, New_D);
         end if;
      end if;
   end Discover;
   
   procedure Try_Discovery_Cardinal(L : in out Level; X : Positive; Y : Positive) is
      Old_D : Dungeon_Room;
   begin
      Old_D := Get_Room(L, X, Y);
      Discover(L, X+1, Y, Old_D);
      Discover(L, X-1, Y, Old_D);
      Discover(L, X, Y+1, Old_D);
      Discover(L, X, Y-1, Old_D);
   end Try_Discovery_Cardinal;
   
   procedure Open_Door(L : in out Level; X : Positive; Y : Positive) is
      D : Dungeon_Room;
      Room_X : Positive;
      Room_Y : Positive;
   begin
   --TODO: create generic function for getting room relative x,y (screen relative too)
      D := Get_Room(L, X, Y);
      Room_X := X - D.X_Position + 1;
      Room_Y := Y - D.Y_Position + 1;
      D.Board(Room_X, Room_Y) := abbr_tiles(Open_Door);
      --Print_Board(D);
      Update_Room(L, D);
      Try_Discovery_Cardinal(L, X, Y);
   end Open_Door;
   
   procedure Check_Trigger(L : in out Level; X : Positive; Y : Positive) is
   begin
      if L.Current_Triggers_Count > 0 then
         for T of L.Current_Triggers loop
            if T.X_Position = X and T.Y_Position = Y  and not T.Triggered then
               L.Current_Screen.Message := T.Message;
               T.Triggered := True;
            end if;
         end loop;
      end if;
   end Check_Trigger;
   
   procedure Update_Screen(L : in out Level) is
      new_Screen_X : Positive;
      new_Screen_Y : Positive;
   begin
      new_Screen_X := Integer'Max(L.Current_Player.X_Position - (Screen_X_Length/2), 1);
      new_Screen_Y := Integer'Max(L.Current_Player.Y_Position - (Screen_Y_Length/2), 1);
      L.Current_Screen.X_Position := new_Screen_X;
      L.Current_Screen.Y_Position := new_Screen_Y;
   end Update_Screen;
   
   --TODO: move not based on display tile, but underlying abstract tile
   procedure Move_Up(L : in out Level) is
      Up_T : Tile := Get_Tile(L, L.Current_Player.X_Position, L.Current_Player.Y_Position - 1);
   begin
      if L.Current_Player.Y_Position > 1 then
         if Up_T = abbr_tiles(Floor) or 
          Up_T = abbr_tiles(Open_Door) then
            L.Current_Player.Y_Position := L.Current_Player.Y_Position - 1;
            Check_Trigger(L, L.Current_Player.X_Position, L.Current_Player.Y_Position);
            Update_Screen(L);
         elsif Up_T = abbr_tiles(Closed_Door) or
          Up_T = abbr_tiles(Secret_Door) then
            Open_Door(L, L.Current_Player.X_Position, L.Current_Player.Y_Position - 1);   
         end if;
      end if;
   end Move_Up;
   
   procedure Move_Down(L : in out Level) is
      Down_T : Tile := Get_Tile(L, L.Current_Player.X_Position, L.Current_Player.Y_Position + 1);
   begin
      if L.Current_Player.Y_Position < L.Current_Dungeon.Y_Length then
         if Down_T = abbr_tiles(Floor) or 
          Down_T = abbr_tiles(Open_Door) then
            L.Current_Player.Y_Position := L.Current_Player.Y_Position + 1;
            Check_Trigger(L, L.Current_Player.X_Position, L.Current_Player.Y_Position);
            Update_Screen(L);
         elsif Down_T = abbr_tiles(Closed_Door) or
          Down_T = abbr_tiles(Secret_Door) then
            Open_Door(L, L.Current_Player.X_Position, L.Current_Player.Y_Position + 1);   
         end if;
      end if;
   end Move_Down;
   
   procedure Move_Left(L : in out Level) is
      Left_T : Tile := Get_Tile(L, L.Current_Player.X_Position -1, L.Current_Player.Y_Position);
   begin
      if L.Current_Player.X_Position > 1 then
         if Left_T = abbr_tiles(Floor) or
          Left_T = abbr_tiles(Open_Door) then
            L.Current_Player.X_Position := L.Current_Player.X_Position - 1;
            Check_Trigger(L, L.Current_Player.X_Position, L.Current_Player.Y_Position);
            Update_Screen(L);
         elsif Left_T = abbr_tiles(Closed_Door) or
          Left_T = abbr_tiles(Secret_Door) then
            Open_Door(L, L.Current_Player.X_Position - 1, L.Current_Player.Y_Position);
         end if;
         --Put_Line("move left");
      end if;
   end Move_Left;
   
   procedure Move_Right(L : in out Level) is
      Right_T : Tile := Get_Tile(L, L.Current_Player.X_Position + 1, L.Current_Player.Y_Position);
   begin
      if L.Current_Player.X_Position < L.Current_Dungeon.X_Length then
         if Right_T = abbr_tiles(Floor) or
          Right_T = abbr_tiles(Open_Door) then
            L.Current_Player.X_Position := L.Current_Player.X_Position + 1;
            Check_Trigger(L, L.Current_Player.X_Position, L.Current_Player.Y_Position);
            Update_Screen(L);
         elsif Right_T = abbr_tiles(Closed_Door) or
          Right_T = abbr_tiles(Secret_Door) then
            Open_Door(L, L.Current_Player.X_Position + 1, L.Current_Player.Y_Position);
         end if;
      end if;
   end Move_Right;
   
end interpreter;
