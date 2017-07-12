with lvl; use lvl;
with dngn; use dngn;
with id; use id;
with mnstr; use mnstr;

package world is

   function Is_Player (L : Level; X : Positive; Y : Positive) return Boolean;
   function Is_Monster (L : Level; X : Positive; Y : Positive) return Boolean;
   function Is_Visible_Monster (L : Level; X : Positive; Y : Positive) return Boolean;

   --Get_monster_index: L : current level, XY, position of monster
   function Get_Monster_Index(L : Level; X : Positive; Y : Positive) return Positive;

   --Is_Room: L: currnet level, XY position of the room?
   --         Returns true if a room contains a point in the dungeon
   function Is_Room (L : Level; X : Positive; Y : Positive) return Boolean;

   --TODO: if I did Get_Room_Index , I might be able to skip Update_Room step
   --      and that may let me use the same room multiple times in a dungeon
   --Get_Room: L: current level, XY: position of the room
   --          Gets a copy of the room at the specified position otherwise a blank room
   function Get_Room(L : Level; X : Positive; Y : Positive) return Dungeon_Room;

   --Get_Room_Index: L: current level, XY, position in dungeon to get room from
   --                returns the index to the room in the level singleton array of rooms
   function Get_Room_Index(L : Level; X : Positive; Y : Positive) return Positive;

   --Update_Room: L: current level; D : room to update
   --             Updates room in level singleton with copy, but relies on ID to be unique...
   procedure Update_Room(L : in out Level; D : Dungeon_Room);

end world;
