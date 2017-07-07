with level; use level;
with dungeon; use dungeon;
with identifier; use identifier;

package world is

   function Is_Player (L : level.Level; X : Positive; Y : Positive) return Boolean;
   function Is_Room (L : level.Level; X : Positive; Y : Positive) return Boolean;
   function Get_Room(L : level.Level; X : Positive; Y : Positive) return Dungeon_Room;
   procedure Update_Room(L : in out level.Level; D : Dungeon_Room);

end world;
