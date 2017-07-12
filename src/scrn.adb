package body scrn is

   procedure Append_Line_Message(Scrn : in out Screen; S : String) is
   begin
      for I in 1 .. Full_Screen_Amt loop
         if Scrn.Message(I) = NUL then
            Scrn.Message(I) := ' ';
            for J in 1 .. S'Length loop
               Scrn.Message(I+J) := S(J);
            end loop;
            return;
         end if;
      end loop;
   end Append_Line_Message;
   
end scrn;
