with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with dngn; use dngn;
with world; use world;
with camera; use camera;
with debug; use debug;
with lvl; use lvl;
with id; use id;
with scrn; use scrn;
with plyr; use plyr;
with interpreter; use interpreter;
with trgr; use trgr;

procedure Main is

   procedure Load_Dungeon ( D : Dungeon; L : in out Level ) is
      I : Identifier;
      P : Player;
      S : Screen;
      new_R : Dungeon_Room;
      J : Positive := 1;
      K : Positive := 1;
      new_T : Trigger;
   begin
      L.Current_Dungeon := D;
      L.Current_Dungeon.Board := transpose(L.Current_Dungeon.Board);
      for X in 1 .. L.Current_Dungeon.X_Length loop
         for Y in 1 .. L.Current_Dungeon.Y_Length loop
               I := L.Current_Dungeon.Board (X, Y);
               if I = PLAYER_a then
                  P :=
                    (X_Position => X,
                     Y_Position => Y,
                     XP         => 1,
                     HP         => 13);
                  L.Current_Player := P;
               elsif I = SCREEN_a then
                  S :=
                    (X_Position => X,
                     Y_Position => Y,
                     X_Length   => Screen_X_Length,
                     Y_Length   => Screen_Y_Length,
                     Message    => (NUL, others=>NUL)
                     );
                  L.Current_Screen := S;
               elsif Identifier'Pos(I) <= Identifier'Pos(RM100001) then
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
               elsif Identifier'Pos(I) >= Identifier'Pos(TRIG0001) and
                Identifier'Pos(I) <= Identifier'Pos(TRIG9999) then
                  for T of all_triggers loop
                     if T.ID = I then
                        new_T := T;
                        new_T.X_Position := X;
                        new_T.Y_Position := Y;
                        L.Current_Triggers (K) := new_T;
                        L.Current_Triggers_Count := K;
                        K := K + 1;
                     end if;
                  end loop;
               end if;
         end loop;
      end loop;
   end;

   L      : Level;
   S      : String (1 .. Screen_X_Length) := (NUL, others=>NUL);
   N      : Natural;
   S_last : String (1 .. Screen_X_Length) := (NUL, others=>NUL);
   Cont   : Boolean := True;
   IT     : Input_Type;
begin
   Load_Dungeon(entry_level, L);

   L.Current_Screen.Message := "As you step from the stairs, they seal behind you trapping you in the Pits. You hear a voice: 'Hello Sailor! Welcome to the Pits. Your Lord Baal has committed you and your mortal shell to this place for his dread amusement. You are not the first and you are not the last. Perhaps there's a way out? Maybe you can make some friends. Just pray to your gods that your death is quick, painless and unexpected. But hey, I won't leave you completely out to dry. I'll show you how to move down here. Type 'y' and then 'enter' when you understand this message. Then type 'd' and then 'enter' to move to the east.'" & (606 .. Full_Screen_Amt => NUL);

   while Cont loop
      IT := Render(L);
      Get_Line(S, N);
      if N = 0 then
         S := S_last;
      end if;
      Cont := Interpret(L, S, IT);
      if N = 1 then
         S_last := S;
      end if;
   end loop;
end Main;
