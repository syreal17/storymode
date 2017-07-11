package body interpreter is
   
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
   
   procedure Player_Attack(L : in out Level; X : Positive; Y : Positive) is
      M_I : Positive;
      M : Monster;
   begin
      M_I := Get_Monster_Index(L, X, Y);
      M := L.Current_Monsters(M_I);
      L.Current_Monsters (M_I).HP := M.HP - Integer'Max(L.Current_Player.PHYSICALITY - M.Armor, 0);
      if L.Current_Monsters (M_I).HP <= 0 then
         L.Current_Screen.Message := "You slay the " & Get_Monster_Name_Str(M) & "!" & (14 + M.Name_length + 1 .. Full_Screen_Amt => NUL);
         L.Current_Monsters (M_I).Alive := False;
         L.Current_Player.XP := L.Current_Player.XP + L.Current_Monsters (M_I).XP_Reward;
      end if;
   end Player_Attack;
   
   procedure Move (L : in out Level; X_Vec : Integer; Y_Vec : Integer) is
      New_X : Positive := L.Current_Player.X_Position + X_Vec;
      New_Y : Positive := L.Current_Player.Y_Position + Y_Vec;
      T_New : Tile := Get_Tile(L, New_X, New_Y);
   begin
      if L.Current_Player.Y_Position > 1 and L.Current_Player.X_Position > 1 and
       L.Current_Player.Y_Position < L.Current_Dungeon.Y_Length and
       L.Current_Player.X_Position < L.Current_Dungeon.X_Length then
         if T_New = abbr_tiles(Floor) or 
          T_New = abbr_tiles(Open_Door) then
            L.Current_Player.Y_Position := New_Y;
            L.Current_Player.X_Position := New_X;
            Check_Trigger(L, L.Current_Player.X_Position, L.Current_Player.Y_Position);
            Update_Screen(L);
         elsif T_New = abbr_tiles(Closed_Door) or
          T_New = abbr_tiles(Secret_Door) then
            Open_Door(L, New_X, New_Y);
         elsif T_New = abbr_tiles(Monster_Tile) then
            Player_Attack(L, New_X, New_Y);
         end if;
      end if;
   end Move;
   
   function Interpret (L : in out Level; S : String; IT : Input_Type) return Boolean is
   begin
      Print_Char_Codes(S);
      if IT = Dungeon_Action then
         if S = com_4 then
            Move(L, -1, 0);
         elsif S = com_6 then
            Move(L, 1, 0);
         elsif S = com_8 then
            Move(L, 0, -1);
         elsif S = com_2 then
            Move(L, 0, 1);
         elsif S = com_7 then
            Move(L, -1, -1);
         elsif S = com_9 then
            Move(L, 1, -1);
         elsif S = com_1 then
            Move(L, -1, 1);
         elsif S = com_3 then
            Move(L, 1, 1);
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
   
   function Monster_Try_Action (L : in out Level; M_I : Positive; X_Target : Positive; Y_Target : Positive) return Boolean is
      T : Tile;
   begin
      T := Get_Tile(L, X_Target, Y_Target);
      if T = abbr_tiles(Floor) or T = abbr_tiles(Open_Door) then
         L.Current_Monsters(M_I).X_Position := X_Target;
         L.Current_Monsters(M_I).Y_Position := Y_Target;
         return True;
      elsif T = abbr_tiles(Player_Tile) then
         null;
         return True;
      end if;
      return False;
   end Monster_Try_Action;
   
   procedure Monster_Action_Handler (L : in out Level; M_I : Positive) is
      X_Vec : Integer;
      Y_Vec : Integer;
      X_Target : Positive;
      Y_Target : Positive;
      M : Monster;
      Took_Action : Boolean;
   begin
      M := L.Current_Monsters(M_I);
      if M.Visible then
         X_Vec := Integer'Max(Integer'Min(L.Current_Player.X_Position - M.X_Position, 1), -1);
         Y_Vec := Integer'Max(Integer'Min(L.Current_Player.Y_Position - M.Y_Position, 1), -1);
         
         X_Target := M.X_Position + X_Vec;
         Y_Target := M.Y_Position + Y_Vec;
         
         Took_Action := Monster_Try_Action(L, M_I, X_Target, Y_Target);
         if Took_Action then
            return;
         end if;
         
         X_Target := M.X_Position + X_Vec;
         Y_Target := M.Y_Position;
         
         Took_Action := Monster_Try_Action(L, M_I, X_Target, Y_Target);
         if Took_Action then
            return;
         end if;

         X_Target := M.X_Position;
         Y_Target := M.Y_Position + Y_Vec;
         
         Took_Action := Monster_Try_Action(L, M_I, X_Target, Y_Target);
         if Took_Action then
            return;
         end if;

      end if;
   end Monster_Action_Handler;
   
   procedure Others_Action (L : in out Level) is
   begin
      for M_I in 1 .. L.Current_Monsters_Count loop
         if L.Current_Monsters(M_I).Alive then
            Monster_Action_Handler(L, M_I);
         end if;
      end loop;
   end Others_Action;
   
end interpreter;
