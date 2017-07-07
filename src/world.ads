with level; use level;
with dungeon; use dungeon;

package world is

   function Is_Player (L : level.Level; X : Positive; Y : Positive) return Boolean;
   function Is_Room (L : level.Level; X : Positive; Y : Positive) return Boolean;
   function Get_Room(L : level.Level; X : Positive; Y : Positive) return Dungeon_Room;

end world;
