with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with id; use id;
with drctn; use drctn;
with itm; use itm;

package mnstr is

   type Monster_Name is new String(Positive range 1 .. 50);

   type Monster is record
      ID         : Identifier;
      X_Position : Positive;
      Y_Position : Positive;
      Visible    : Boolean;
      HP         : Integer;
      Facing     : Cardinal_Direction;
      XP_Reward  : Positive;
      PHYSICALITY: Positive;
      MYSTICISM  : Positive;
      BALANCE    : Positive;
      Name       : Monster_Name;
      Name_length: Positive;
      Armor      : Natural;
      Alive      : Boolean;
      Inv        : Inventory;
      --Armor      : Armor_Item;
   end record;
   
   type Monsters is array (Positive range 1 .. 500) of Monster;
   
   large_rat : Monster :=
      (ID        => M00001_1,
      X_Position => 1,
      Y_Position => 1,
      Visible    => False,
      HP         => 8,
      Facing     => East,
      XP_Reward  => 100,
      PHYSICALITY=> 3,
      MYSTICISM  => 1,
      BALANCE    => 1,
      Name       => "large rat" & (10 .. 50 => NUL),
      Name_length=> 9,
      Armor      => 0,
      Alive      => True,
      Inv        => (rat_meat, others=>noitem)
      );
      
   blank_monster : Monster :=
      (ID        => M99999_9,
      X_Position => 1,
      Y_Position => 1,
      Visible    => False,
      HP         => 1,
      Facing     => North,
      XP_Reward  => 1,
      PHYSICALITY=> 1,
      MYSTICISM  => 1,
      BALANCE    => 1,
      Name       => "blank monster" & (14 .. 50 => NUL),
      Name_length=> 13,
      Armor      => 0,
      Alive      => False,
      Inv        => (noitem, others=>noitem)
      );
      
   all_monsters : Monsters := (large_rat, others=>blank_monster);
   
   --Get_Monstger_Name_Str: M: monster to get name
   --                       Returns unbounded string from monster record
   function Get_Monster_Name_Str(M : Monster) return String;

end mnstr;
