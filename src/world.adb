package body world is

   function Is_Player (L : Level; X : Positive; Y : Positive) return Boolean is
   begin
      if L.Current_Player.X_Position = X and L.Current_Player.Y_Position = Y then
         return True;
      else
         return False;
      end if;
   end Is_Player;
   
   function Is_Monster (L : Level; X : Positive; Y : Positive) return Boolean is
      I : Positive := 1;
      M : Monster;
   begin
      for I in 1 .. L.Current_Monsters_Count loop
         M := L.Current_Monsters (I);
         if M.X_Position = X and M.Y_Position = Y then
            return True;
         end if;
      end loop;
      return False;
   end Is_Monster;
   
   function Is_Visible_Monster (L : Level; X : Positive; Y : Positive) return Boolean is
      I : Positive := 1;
      M : Monster;
   begin
      for I in 1 .. L.Current_Monsters_Count loop
         M := L.Current_Monsters (I);
         if M.X_Position = X and M.Y_Position = Y and M.Visible then
            return True;
         end if;
      end loop;
      return False;
   end Is_Visible_Monster;
   
   --Get_monster_index: L : current level, XY, position of monster
   function Get_Monster_Index (L : Level; X : Positive; Y : Positive) return Positive is
      M : Monster;
   begin
      for I in 1 .. L.Current_Monsters_Count loop
         M := L.Current_Monsters (I);
         if M.X_Position = X and M.Y_Position = Y then
            return I;
         end if;
      end loop;
      return Positive'Last;
   end Get_Monster_Index;

   --Is_Room: L: currnet level, XY position of the room?
   --         Returns true if a room contains a point in the dungeon
   function Is_Room (L : Level; X : Positive; Y : Positive) return Boolean is
      R : Dungeon_Room;
      R_X_min : Positive;
      R_X_max : Positive;
      R_Y_min : Positive;
      R_Y_max : Positive;
   begin
      for J in 1 .. L.Current_Rooms_Count loop
         --Put_Line(Integer'Image(J));
         R := L.Current_Rooms (J);
         R_X_min := R.X_Position;
         R_X_max := R_X_min + R.X_Length;
         R_Y_min := R.Y_Position;
         R_Y_max := R_Y_min + R.Y_Length;
         if X >= R_X_min and X < R_X_max and Y >= R_Y_min and Y < R_Y_max then
            return True;
         end if;
      end loop;

      return False;
   end Is_Room;

   --Get_Room: L: current level, XY: position of the room
   --          Gets a copy of the room at the specified position otherwise a blank room
   function Get_Room(L : Level; X : Positive; Y : Positive) return Dungeon_Room is
      R : Dungeon_Room;
      R_X_min : Positive;
      R_X_max : Positive;
      R_Y_min : Positive;
      R_Y_max : Positive;
   begin
      for J in 1 .. L.Current_Rooms_Count loop
         R := L.Current_Rooms (J);
         R_X_min := R.X_Position;
         R_X_max := R_X_min + R.X_Length;
         R_Y_min := R.Y_Position;
         R_Y_max := R_Y_min + R.Y_Length;
         if X >= R_X_min and X < R_X_max and Y >= R_Y_min and Y < R_Y_max then        
            return R;
         end if;
      end loop;

      return blank_room;
   end Get_Room;
   
   --Get_Room_Index: L: current level, XY, position in dungeon to get room from
   --                returns the index to the room in the level singleton array of rooms
   function Get_Room_Index(L : Level; X : Positive; Y : Positive) return Positive is
      R : Dungeon_Room;
      R_X_min : Positive;
      R_X_max : Positive;
      R_Y_min : Positive;
      R_Y_max : Positive;
   begin
      for J in 1 .. L.Current_Rooms_Count loop
         R := L.Current_Rooms (J);
         R_X_min := R.X_Position;
         R_X_max := R_X_min + R.X_Length;
         R_Y_min := R.Y_Position;
         R_Y_max := R_Y_min + R.Y_Length;
         if X >= R_X_min and X < R_X_max and Y >= R_Y_min and Y < R_Y_max then        
            return J;
         end if;
      end loop;

      return Positive'Last;
   end Get_Room_Index;
   
   --Update_Room: L: current level; D : room to update
   --             Updates room in level singleton with copy, but relies on ID to be unique...
   procedure Update_Room(L : in out Level; D : Dungeon_Room) is
   begin
      for J in 1 .. L.Current_Rooms_Count loop
         if L.Current_Rooms(J).ID = D.ID then
            L.Current_Rooms(J) := D;
            exit;
         end if;
      end loop;
   end Update_Room;
   
end world;
