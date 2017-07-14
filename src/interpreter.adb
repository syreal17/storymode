package body interpreter is
   
   --Discover_Monsters: L: current level, D: room newly discovered
   --                  Set any monsters in the newly discovered room to visible.
   --TODO: base this on room index and not a copy of Dungeon_Room
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
   
   --Discover: L: level: XY, coordinates to check if there is an undiscovered room
   --TODO: use room index instead of room ID compare.
   procedure Discover(L : in out Level; X : Positive; Y : Positive; Old_D : Dungeon_Room) is
      New_D : Dungeon_Room;
   begin
      if Is_Room(L, X, Y) then
         New_D := Get_Room(L, X, Y);
         if Old_D.ID /= New_D.ID and New_D.Discovered = False then
            New_D.Discovered := True;
            L.Current_Player.XP := L.Current_Player.XP + New_D.XP;
            --activate any monsters in this room
            Discover_Monsters(L, New_D);
            --todo: remove update and change room using indexx in level array
            Update_Room(L, New_D);
         end if;
      end if;
   end Discover;
   
   --Discovery_Probe: L: current level, XY, origin of probe
   --                 Tries to discover a new room one step in all directions from the origin of the probe.
   procedure Discovery_Probe(L : in out Level; X : Positive; Y : Positive) is
      Old_D : Dungeon_Room;
   begin
      Old_D := Get_Room(L, X, Y);

      Discover(L, X+1, Y, Old_D);
      Discover(L, X-1, Y, Old_D);
      Discover(L, X, Y+1, Old_D);
      Discover(L, X, Y-1, Old_D);
      Discover(L, X+1, Y+1, Old_D);
      Discover(L, X-1, Y-1, Old_D);
      Discover(L, X-1, Y+1, Old_D);
      Discover(L, X+1, Y-1, Old_D);
   end Discovery_Probe;
   
   --Check_Trigger: L: current level, XY: position to check for a trigger and trip if there is
   procedure Check_Trigger(L : in out Level; X : Positive; Y : Positive) is
   begin
      if L.Current_Triggers_Count > 0 then
         for T of L.Current_Triggers loop
            if T.X_Position = X and T.Y_Position = Y  and not T.Triggered then
               --currently only message triggers supported
               L.Current_Screen.Message := T.Message;
               T.Triggered := True;
            end if;
         end loop;
      end if;
   end Check_Trigger;
   
   --Open_Door: L: current level, XY: position of door open attempt
   --           Opens a door in the dungeon
   procedure Open_Door(L : in out Level; X : Positive; Y : Positive) is
      D      : Dungeon_Room;
      Room_X : Positive;
      Room_Y : Positive;
      D_I    : Positive;
   begin
      D_I := Get_Room_Index(L, X, Y);
      D := L.Current_Rooms(D_I);
      --gets room relative position so we can index the room board, not dungeon board
      Room_X := X - D.X_Position + 1;
      Room_Y := Y - D.Y_Position + 1;
      L.Current_Rooms(D_I).Board(Room_X, Room_Y) := abbr_tiles(Open_Door);
      --discovers new rooms in north, south, east, west directions
      Discovery_Probe(L, X, Y);
      Check_Trigger(L, X, Y);
   end Open_Door;
   
   --Close_Door: L: current level, XY: Position to try door close
   --            Closes a door in the dungeon.
   procedure Close_Door(L : in out Level; X : Positive; Y : Positive) is
      D      : Dungeon_Room;
      Room_X : Positive;
      Room_Y : Positive;
      D_I    : Positive;
   begin
      if Get_Bottom_Tile(L, X, Y) = abbr_tiles(Open_Door) then
         D_I := Get_Room_Index(L, X, Y);
         D   := L.Current_Rooms(D_I);
         --gets room relative position so we can index the room board, not dungeon board
         Room_X := X - D.X_Position + 1;
         Room_Y := Y - D.Y_Position + 1;
         L.Current_Rooms(D_I).Board(Room_X, Room_Y) := abbr_tiles(Closed_Door);
      else
         L.Current_Screen.Message := "There is no door where you're standing. Open doors are marked on the map by ':'" & (80 .. Full_Screen_Amt => NUL);
      end if;
   end Close_Door;
   
   --Update_screen: L: current level. Updates with player in center of screen, unless player is in
   --               top left corner of dungeon.
   procedure Update_Screen(L : in out Level) is
      new_Screen_X : Positive;
      new_Screen_Y : Positive;
   begin
      --TODO: add boundary on lower right as well...
      new_Screen_X := Integer'Max(L.Current_Player.X_Position - (Screen_X_Length/2), 1);
      new_Screen_Y := Integer'Max(L.Current_Player.Y_Position - (Screen_Y_Length/2), 1);
      L.Current_Screen.X_Position := new_Screen_X;
      L.Current_Screen.Y_Position := new_Screen_Y;
   end Update_Screen;
   
   --Player_Attack: L: current level, X: space attacking, Y: space attacking
   --               Player attempts to damage monster at X,Y
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
      else
         L.Current_Screen.Message := "You attack the " & Get_Monster_Name_Str(M) & "!" & (16 + M.Name_length + 1 .. Full_Screen_Amt => NUL);
      end if;
   end Player_Attack;
   
   procedure Loot_Monster(L : in out Level; X : Positive; Y :Positive) is
      M_I : Positive := Get_Monster_Index(L, X, Y);
      M : Monster := L.Current_Monsters(M_I);
      S : String(1 .. Full_Screen_Amt);
      N1: Positive;
      N2: positive;
      N3: positive;
      N4: positive;
      N5: positive;
      N6: positive;
   begin
      L.Current_Screen.Loot_X := X;
      L.Current_Screen.Loot_Y := Y;
      N1 := 25 + M.Name_length + 1;
      N2 := 3 + M.Inv(1).Name_length;
      N3 := 3 + M.Inv(2).Name_length;
      N4 := 3 + M.Inv(3).Name_length;
      N5 := 3 + M.Inv(4).Name_length;
      N6 := 3 + M.Inv(5).Name_length;
      S :=
       "Take what from the slain " & Get_Monster_Name_Str(M) & "?" & (N1 + 1 .. Screen_X_Length + 1 => ' ') &
       "a. " & Get_Item_Name_Str(M.Inv(1)) & ((Screen_X_Length +1) + N2 + 1 .. (Screen_X_Length +1)*2 => ' ') &
       "b. " & Get_Item_Name_Str(M.Inv(2)) & ((Screen_X_Length +1)*2 + N3 + 1 .. (Screen_X_Length +1)*3 => ' ') &
       "c. " & Get_Item_Name_Str(M.Inv(3)) & ((Screen_X_Length +1)*3 + N4 + 1 .. (Screen_X_Length +1)*4 => ' ') &
       "d. " & Get_Item_Name_Str(M.Inv(4)) & ((Screen_X_Length +1)*4 + N5 + 1 .. (Screen_X_Length +1)*5 => ' ') &
       "e. " & Get_Item_Name_Str(M.Inv(5)) & ((Screen_X_Length +1)*5 + N6 + 1 .. (Screen_X_Length +1)*6 => ' ') &
       ((Screen_X_Length+1)*6 + 1 .. Full_Screen_Amt => NUL);
       
      L.Current_Screen.Loot := S;
   end Loot_Monster;
   
   --Move: L: current level, X_Vec: X difference to apply to player position, Y_Vec: Y difference
   --      Moves player in specified direction, takes automatic action in same direction (opening doors, attacking monsters)
   procedure Move (L : in out Level; X_Vec : Integer; Y_Vec : Integer) is
      New_X : Positive := L.Current_Player.X_Position + X_Vec;
      New_Y : Positive := L.Current_Player.Y_Position + Y_Vec;
      T_New : Tile := Get_Top_Tile(L, New_X, New_Y);
   begin
      --make sure player stays within bounds of dungeon
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
         elsif T_New = abbr_tiles(Monster_Corpse) then
            Loot_Monster(L, New_X, New_Y);
         end if;
      end if;
   end Move;
   
   --Show_Stats: L:  current level. Displays all the stats of the current player.
   --            A little suboptimial right now with all the hardcoded offsets
   procedure Show_Stats(L : in out Level) is
      S : String(1 .. Full_Screen_Amt);
      N1 : Positive;
      N2 : Positive;
      N3 : Positive;
      N4 : Positive;
      N5 : Positive;
      N6 : Positive;
      N7 : Positive;
      P : Player;
   begin
      P := L.Current_Player;
      --The length of the strings
      N1 := 5 + Natural'Image(P.HP)'Length + 1 + Positive'Image(P.HP_Max)'Length;
      N2 := 5 + Positive'Image(P.XP)'Length;
      N3 := 14 + Positive'Image(P.PHYSICALITY)'Length;
      N4 := 14 + Positive'Image(P.MYSTICISM)'Length;
      N5 := 14 + Positive'Image(P.BALANCE)'Length;
      N6 := 14 + Positive'Image(P.Armor)'Length;
      N7 := 5 + Natural'Image(P.LVL)'Length;
      S :=
       --unfortunately, we can't just insert a linefeed, because thats not how the render works.
       --we must output a full line before it automatically inserts a new line feed.
       --it's confusing that the string is one-dimensional, but it is output in 2 dimensions.
       "HP : " & Natural'Image(P.HP) & "/" & Positive'Image(P.HP_Max) & (N1 + 1 .. Screen_X_Length + 1 => ' ') &
       "XP : " & Positive'Image(P.XP) & (Screen_X_Length + 1 +N2 + 1 .. (Screen_X_Length + 1)*2 => ' ') &
       "LVL: " & Natural'Image(P.LVL) & ((Screen_X_Length + 1)*2 +N7 + 1 .. (Screen_X_Length + 1)*3 => ' ') &
       "PHYSICALITY : " & Positive'Image(P.PHYSICALITY) & ((Screen_X_Length + 1)*3 +N3 + 1 .. (Screen_X_Length + 1)*4 => ' ') &
       "MYSTICISM   : " & Positive'Image(P.MYSTICISM) & ((Screen_X_Length + 1)*4 +N4 + 1 .. (Screen_X_Length + 1)*5 => ' ') &
       "BALANCE     : " & Positive'Image(P.BALANCE) & ((Screen_X_Length + 1)*5 +N5 + 1 .. (Screen_X_Length + 1)*6 => ' ') &
       "Armor       : " & Positive'Image(P.Armor) & ((Screen_X_Length + 1)*6 +N6 + 1 .. (Screen_X_Length + 1)*7 => ' ') &
       ((Screen_X_Length + 1)*7+1 .. Full_Screen_Amt => NUL);
       
      L.Current_Screen.Message := S;
   end Show_Stats;
   
   procedure Take(L : in out Level; Inv_I : Positive) is
      M_I : Positive := Get_Monster_Index(L, L.Current_Screen.Loot_X, L.Current_Screen.Loot_Y);
      M : Monster := L.Current_Monsters(M_I);
      I : Item := M.Inv(Inv_I);
      Can_Take_I : Boolean := False;
   begin
      --TODO: generalize for not just looting monsters
      for J in 1 .. 5 loop
         if L.Current_Player.Inv(J) = noitem then
            L.Current_Player.Inv(J) := I;
            L.Current_Monsters(M_I).Inv(Inv_I) := noitem;
            Can_Take_I := True;
            
            --update screen with new monster inventory
            Loot_Monster(L, L.Current_Screen.Loot_X, L.Current_Screen.Loot_Y);
            exit;
         end if;
      end loop;
      
      if not Can_Take_I then
         L.Current_Screen.Message := "Your inventory is full!" & (24 .. Full_Screen_Amt => NUL);
         L.Current_Screen.Loot    := (NUL, others=>NUL);
      end if;
   end Take;
   
   procedure Dispose(L : in out Level) is
      M_I : Positive;
   begin
      L.Current_Screen.Loot := (NUL, others=>NUL);
      M_I := Get_Monster_Index(L, L.Current_Screen.Loot_X, L.Current_Screen.Loot_Y);
      L.Current_Monsters(M_I).X_Position := 1;
      L.Current_Monsters(M_I).Y_Position := 1;
   end Dispose;
   
   --Interpret: L : current level, S : Player entered string, IT : what input interpreter should be expecting
   --           Returns whether game loop should continue or not. Inteprets player input to do an action
   function Interpret (L : in out Level; S : String; IT : Input_Type) return Boolean is
   begin
      Print_Char_Codes(S);
      if IT = Dungeon_Action then
         if L.Current_Player.Alive then
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
            elsif S = com_close then
               Close_Door(L, L.Current_Player.X_Position, L.Current_Player.Y_Position);
            elsif S = com_s then
               Show_Stats(L);
            end if;
         end if;
         if S = com_q then
            return False;
         end if;
      elsif IT = Continue_Text then
         if S = com_y or S = com_q then
            --clearing message make dungeon action happen next
            L.Current_Screen.Message := (NUL, others=>NUL);
         end if;
      elsif IT = Loot_Text then
         if S = com_q then
            L.Current_Screen.Loot := (NUL, others=>NUL);
         elsif S = com_a then
            Take(L, 1);
         elsif S = com_b then
            Take(L, 2);
         elsif S = com_c then
            Take(L, 3);
         elsif S = com_d then
            Take(L, 4);
         elsif S = com_e then
            Take(L, 5);
         elsif S = com_z then
            Dispose(L);
         end if;
      end if;
      return True;
   end;
   
   --Monster_Try_action: L: current level X_Target: intended X, Y_Target: intended Y
   --                    Will try walking or attacking the player. Reports on success or failure in order to try other options.
   function Monster_Try_Action (L : in out Level; M_I : Positive; X_Target : Positive; Y_Target : Positive) return Boolean is
      T : Tile;
      M : Monster := L.Current_Monsters(M_I);
   begin
      T := Get_Top_Tile(L, X_Target, Y_Target);
      if T = abbr_tiles(Floor) or T = abbr_tiles(Open_Door) then
         L.Current_Monsters(M_I).X_Position := X_Target;
         L.Current_Monsters(M_I).Y_Position := Y_Target;
         return True;
      elsif T = abbr_tiles(Player_Tile) then
         L.Current_Player.HP := L.Current_Player.HP - Integer'Max(M.PHYSICALITY - L.Current_Player.Armor, 0);
         if L.Current_Player.HP <= 0 then
            L.Current_Player.Alive := False;
            Append_Line_Message(L.Current_Screen, "The " & Get_Monster_Name_str(M) & " has slain you.");
         else
            Append_Line_message(L.Current_Screen, "The " & Get_Monster_Name_Str(M) & " attacks you!");
         end if;
         return True;
      end if;
      return False;
   end Monster_Try_Action;
   
   --Monster_Action_Handler: L: current level, M_I: index of monster in monster array
   --                        Primitive AI for monsters. Just moves towards player regardless of walls
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
         --find a vector towards the player by truncating the distance between -1 and 1
         X_Vec := Integer'Max(Integer'Min(L.Current_Player.X_Position - M.X_Position, 1), -1);
         Y_Vec := Integer'Max(Integer'Min(L.Current_Player.Y_Position - M.Y_Position, 1), -1);
         
         
         --now we try three different combinations of the vectors and see if any of them allows us to take and action
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
   
   --Others_Action: L : current level. Lets monsters and NPCs take an action
   procedure Others_Action (L : in out Level) is
   begin
      for M_I in 1 .. L.Current_Monsters_Count loop
         if L.Current_Monsters(M_I).Alive then
            Monster_Action_Handler(L, M_I);
         end if;
      end loop;
   end Others_Action;
   
end interpreter;
