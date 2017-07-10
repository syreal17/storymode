package body dngn is
   
   function transpose(A: in Dungeon_Board) return Dungeon_Board  is
      B : Dungeon_Board;
   begin
      for i in A'Range(1) loop
         for j in A'Range(2) loop
            B(j,i):= A(i,j);
         end loop;
      end loop;
      return B;
   end transpose;
   
   function transpose(A: in Room_Board) return Room_Board  is
      B : Room_Board;
   begin
      for i in A'Range(1) loop
         for j in A'Range(2) loop
            B(j,i):= A(i,j);
         end loop;
      end loop;
      return B;
   end transpose;
   
end dngn;
