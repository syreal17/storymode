with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with dungeon; use dungeon;
with world; use world;
with camera; use camera;
with debug; use debug;
with level; use level;
with identifier; use identifier;
with screen; use screen;
with player; use player;
with interpreter; use interpreter;


procedure Main is

   procedure Load_Dungeon ( D : dungeon.Dungeon; L : in out level.Level ) is
      I : identifier.Identifier;
      P : player.Player;
      S : screen.Screen;
      new_R : Dungeon_Room;
      J : Positive := 1;
   begin
      L.Current_Dungeon := D;
      L.Current_Dungeon.Board := transpose(L.Current_Dungeon.Board);
      for X in 1 .. L.Current_Dungeon.X_Length loop
         for Y in 1 .. L.Current_Dungeon.Y_Length loop
               I := L.Current_Dungeon.Board (X, Y);
               if I = PLAYER_a then
                  P :=
                    (X_Position => X,
                     Y_Position => Y);
                  L.Current_Player := P;
               elsif I = SCREEN_a then
                  S :=
                    (X_Position => X,
                     Y_Position => Y,
                     X_Length   => Screen_X_Length,
                     Y_Length   => Screen_Y_Length);
                  L.Current_Screen := S;
               elsif identifier.Identifier'Pos(I) <= identifier.Identifier'Pos(RM100001) then
                  for R of all_rooms loop
                     if R.ID = I then
                        --Put_Line("loading room");
                        new_R := R;
                        new_R.X_Position := X;
                        new_R.Y_Position := Y;
                        new_R.Board := transpose(R.Board);
                        L.Current_Rooms (J) := new_R;
                        L.Current_Rooms_Count := J;
                        J := J + 1;
                     end if;
                  end loop;
               end if;
         end loop;
      end loop;
   end;

   L      : level.Level;
   S      : String (1 .. Screen_X_Length) := (NUL, others=>NUL);
   N      : Natural;
   S_last : String (1 .. Screen_X_Length) := (NUL, others=>NUL);
begin
   Load_Dungeon(entry_level, L);

   --put_line(Boolean'Image(Is_Room(L, 35, 3)));
   --Put_Line(Positive'Image(L.Current_Rooms_Count));

   loop
      --Put_Line(Positive'Image(L.Current_Player.X_Position));
      Render(L);
      Get_Line(S, N);
      --Put_Line(Natural'Image(N));
      if N = 0 then
         S := S_last;
      end if;
      Interpret(L, S);
      if N = 1 then
         S_last := S;
      end if;
   end loop;
end Main;
