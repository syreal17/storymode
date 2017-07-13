package body camera is

   -- Render: L: the level to render. Renders a what is in the level's screen: monsters, players, dungeon tiles.
   function Render (L : in out Level) return Input_Type is
      Screen_X_min : Positive := L.Current_Screen.X_Position;
      Screen_X_max : Positive := Screen_X_min + L.Current_Screen.X_Length;
      Screen_Y_min : Positive := L.Current_Screen.Y_Position;
      Screen_Y_max : Positive := Screen_Y_min + L.Current_Screen.Y_Length;
      Screen       : String(1 .. Full_Screen_Amt ); --the single string that becomes what is output to the screen
      J            : Positive := 1; --index of string we're building for the screen's view of level
      I            : Positive := 1; --index of the message we're printing to the screen before rendering dungeon
      K            : Positive := 1; --index of the loot message we're printing to the screen before rendering dungeon
      Print_Message: Boolean := True; --assume we're printing a message, but check first thing in the loop
      Print_Loot   : Boolean := True;
   begin
   
      for Y in Screen_Y_min .. Screen_Y_max loop
         for X in Screen_X_min .. Screen_X_max loop
         --if message is NULL at I then we've printed everything we need to. Works when message is all nulls also
            if L.Current_Screen.Message(I) = NUL then
               Print_Message := False;
            end if;
            
            if L.Current_Screen.Loot(K) = NUL then
               Print_Loot := False;
            end if;
            
            if Print_Message then
               Screen(J) := L.Current_Screen.Message(I);
               I := I + 1;
            elsif Print_Loot then
               Screen(J) := L.Current_Screen.Loot(K);
               K := K + 1;
            else
               Screen(J) := display_tiles(Get_Top_Tile(L, X, Y));
            end if;
            J := J + 1;
         end loop;
         --insert a line-feed at the end of each row
         Screen(J) := LF;
         J := J + 1;
      end loop;
      --output the rendering
      Put(Screen);
      --change the prompt based on whether a message was printed or we are waiting for a dungeon action from the player
      if I >= 2 then
         Put("Continue (y/n)? ");
         return Continue_Text;
      elsif K >= 2 then
         Put("Take: ");
         return Loot_Text;
      else
         Put("Action: ");
         return Dungeon_Action;
      end if;
      
   end;
   
   -- Get_Top_tile: L: the level to get tile from. X: x position of tile. Y: y position of tile
   --               Gets top tile, player takes precedence over monsters which take precedence over dungeon tiles
   function Get_Top_Tile (L : Level; X : Positive; Y : Positive) return Tile is
      R       : Dungeon_Room;
      T       : Tile;
      R_rel_X : Positive;
      R_rel_Y : Positive;
      M_I     : Positive;
   begin
      if Is_Player(L, X, Y) then --check for player first, highest priority for displaying
         if L.Current_Player.Alive then
            return abbr_tiles(Player_Tile);
         else
            return abbr_tiles(Player_Corpse);
         end if;
      elsif Is_Visible_Monster(L, X, Y) then --check for monster next, next highest priority for displaying
         M_I := Get_Monster_Index(L, X, Y);
         if (L.Current_Monsters(M_I).Alive) then
            return abbr_tiles(Monster_Tile);
         else
            return abbr_tiles(Monster_Corpse);
         end if;
      elsif Is_Room(L, X, Y) then --finally check for brick and mortar of dungeon
         R := Get_Room(L, X, Y);
         --find room relative x and y for indexing into room board
         R_rel_X := X - (R.X_Position - 1);
         R_rel_Y := Y - (R.Y_position - 1);
         T := R.Board(R_rel_X, R_rel_Y);
         if R.Discovered then
            return T;
         else
            return abbr_tiles(Nothing);
         end if;
      end if;
      return abbr_tiles(Nothing);
   end Get_Top_Tile;
   
   -- Get_Bottom_Tile : L: the level to get tile from. X: x position of tile. Y: y position of tile
   --                   Gets dungeon tile at position
   function Get_Bottom_Tile (L : Level; X : Positive; Y : Positive) return Tile is
      R       : Dungeon_Room;
      T       : Tile;
      R_rel_X : Positive;
      R_rel_Y : Positive;
   begin
      if Is_Room(L, X, Y) then
         R := Get_Room(L, X, Y);
         --find room relative X and Y for indexing into the room board
         R_rel_X := X - (R.X_Position - 1);
         R_rel_Y := Y - (R.Y_position - 1);
         T := R.Board(R_rel_X, R_rel_Y);
         if R.Discovered then
            return T;
         else --player hasn't discovered room yet, so return nothing
            return abbr_tiles(Nothing);
         end if;
      end if;
      return abbr_tiles(Nothing);
   end Get_Bottom_Tile;
   
end camera;
