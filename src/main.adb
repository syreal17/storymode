with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with camera; use camera;
with dngn; use dngn;
with debug; use debug;
with lvl; use lvl;
with id; use id;
with scrn; use scrn;
with plyr; use plyr;
with interpreter; use interpreter;
with trgr; use trgr;
with mnstr; use mnstr;

procedure Main is

   --Load_Dungeon: D: dungeon to load, L: level to load it into
   --              Takes all the identifiers of the dungeon board and loads their
   --              respective objects in the level singleton
   procedure Load_Dungeon ( D : Dungeon; L : in out Level ) is
      I : Identifier;
      P : Player;
      S : Screen;
      new_R : Dungeon_Room;
      new_T : Trigger;
      new_M : Monster;
      J : Positive := 1;
      K : Positive := 1;
      H : Positive := 1;
   begin
      L.Current_Dungeon := D;
      --we transpose because the underlying 2d array storage layout is opposite to what we expect.
      L.Current_Dungeon.Board := transpose(L.Current_Dungeon.Board);
      for X in 1 .. L.Current_Dungeon.X_Length loop
         for Y in 1 .. L.Current_Dungeon.Y_Length loop
               I := L.Current_Dungeon.Board (X, Y);

               --this is simply the loading of objects into the level singleton
               if I = PLAYER_a then
                  P :=
                    (X_Position => X,
                     Y_Position => Y,
                     XP         => 1,
                     HP         => 13,
                     HP_Max     => 13,
                     LVL        => 0,
                     PHYSICALITY=> 5,
                     MYSTICISM  => 1,
                     BALANCE    => 1,
                     Armor      => 0,
                     Alive      => True
                     --Melee      => 1,
                     --Manamancy  => 1,
                     --Sneak      => 1,
                     --Sprint     => 1,
                     --Search     => 1
                     );
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
               elsif Identifier'Pos(I) >= Identifier'Pos(M00001_1) and
                Identifier'Pos(I) <= Identifier'Pos(M99999_9) then
                  for M of all_monsters loop
                     if M.ID = I then
                        new_M := M;
                        new_M.X_Position := X;
                        new_M.Y_Position := Y;
                        L.Current_Monsters (H) := new_M;
                        L.Current_Monsters_Count := H;
                        H := H + 1;
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

   --intro message
   L.Current_Screen.Message := "As you step from the stairs, they seal behind you trapping you in the Pits. You hear a voice: 'Hello Sailor! Welcome to the Pits. Your Lord Baal has committed you and your mortal shell to this place for his dread amusement. You are not the first and you are not the last. Perhaps there's a way out? Maybe you can make some friends. Just pray to your gods that your death is quick, painless and unexpected. But hey, I won't leave you completely out to dry. I'll show you how to move down here. Type 'y' and then 'enter' when you understand this message. Then type 'd' and then 'enter' to move to the east.'" & (606 .. Full_Screen_Amt => NUL);
   --testing if message has right bounds:
   --Put_Line(Positive'Image(Full_Screen_Amt));
   --L.Current_Screen.Message := (1 .. Full_Screen_Amt => 'a');

   --Game loop
   while Cont loop
      S := (NUL, others=>NUL);
      --rendering returns input type based on whether there is a message to Continue from or, if we are just waiting for
      --the player to make a move
      IT := Render(L);

      --this is how the player inputs
      Get_Line(S, N);

      --if nothing was input, use the last single letter command
      if N = 0 then
         S := S_last;
      end if;

      --Cont is whether to continue game loop. The player inputting 'q' makes this False
      Cont := Interpret(L, S, IT);

      --if it's a single letter command, not equal to 'y' or 'n' then remember it as the last single letter command
      if N = 1 and S /= com_y and S /= com_n then
         S_last := S;
      end if;

      --if the player took a dungeon action then the others in the dungeon get a turn too. This avoids penalizing
      --the player for saying 'y' to a continue screen.
      if IT = Dungeon_Action then
         Others_Action(L);
      end if;
   end loop;
end Main;
