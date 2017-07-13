with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package itm is

  type Item_Type is (Edible, Equipable, Decoration, Nothing);

  type Item is record
     HP          : Integer;
     PHYSICALITY : Integer;
     MYSTICISM   : Integer;
     BALANCE     : Integer;
     Armor       : Integer;
     Weapon      : Integer;
     I_Type      : Item_Type;
     Name        : String(1 .. 50);
     Name_length : Positive;
  end record;
  
  noitem: Item :=
     (HP        => 0,
     PHYSICALITY=> 0,
     MYSTICISM  => 0,
     BALANCE    => 0,
     Armor      => 0,
     Weapon     => 0,
     I_Type  => Nothing,
     Name       => "nothing" & (8 .. 50 => NUL),
     Name_length=> 7
     );
  
  rat_meat : Item :=
     (HP        => 5,
     PHYSICALITY=> 0,
     MYSTICISM  => 0,
     BALANCE    => 0,
     Armor      => 0,
     Weapon     => 0,
     I_Type  => Edible,
     Name       => "rat meat" & (9 .. 50 => NUL),
     Name_length=> 8
     );
     
  --all_items? IDs in items?
  
  type Inventory is array (Positive range 1 .. 5) of Item;
  
  function Get_Item_Name_Str(I : Item) return String;

end itm;
