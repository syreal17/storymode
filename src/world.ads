with lvl; use lvl;
with dngn; use dngn;
with id; use id;
with mnstr; use mnstr;

package world is

   function Is_Player (L : Level; X : Positive; Y : Positive) return Boolean;
   function Is_Monster (L : Level; X : Positive; Y : Positive) return Boolean;
   function Is_Visible_Monster (L : Level; X : Positive; Y : Positive) return Boolean;
   function Get_Monster_Index(L : Level; X : Positive; Y : Positive) return Positive;
   function Is_Room (L : Level; X : Positive; Y : Positive) return Boolean;
   --TODO: if I did Get_Room_Index , I might be able to skip Update_Room step
   --      and that may let me use the same room multiple times in a dungeon
   function Get_Room(L : Level; X : Positive; Y : Positive) return Dungeon_Room;
   procedure Update_Room(L : in out Level; D : Dungeon_Room);

end world;
