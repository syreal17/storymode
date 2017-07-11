with id; use id;
with drctn; use drctn;

package mnstr is

   type Monster is record
      ID         : Identifier;
      X_Position : Positive;
      Y_Position : Positive;
      Visible    : Boolean;
      HP         : Positive;
      Facing     : Cardinal_Direction;
      XP_Reward  : Positive;
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
      XP_Reward  => 100
      );
      
   blank_monster : Monster :=
      (ID        => M99999_9,
      X_Position => 1,
      Y_Position => 1,
      Visible    => False,
      HP         => 1,
      Facing     => North,
      XP_Reward  => 1
      );
      
   all_monsters : Monsters := (large_rat, others=>blank_monster);

end mnstr;
