package body itm is
   
   --Get_Monstger_Name_Str: M: monster to get name
   --                       Returns unbounded string from monster record
   function Get_Item_Name_Str(I : Item) return String is
      S : String(1 .. I.Name_length);
      I_Name : String(1 .. 50) := I.Name;
   begin
   
      for J in 1 .. I.Name_length loop
         S(J) := I_Name(J);
      end loop;
      return S;
   end Get_Item_Name_Str;
   
end itm;
