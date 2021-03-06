package body mnstr is

   --Get_Monstger_Name_Str: M: monster to get name
   --                       Returns unbounded string from monster record
   function Get_Monster_Name_Str(M : Monster) return String is
      S : String(1 .. M.Name_length);
      MN : Monster_Name := M.Name;
   begin
   
      for I in 1 .. M.Name_length loop
         S(I) := MN(I);
      end loop;
      return S;
   end Get_Monster_Name_Str;
   
end mnstr;
