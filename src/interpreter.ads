with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO; use Ada.Text_IO;

with dngn; use dngn;
with scrn; use scrn;
with lvl; use lvl;
with debug; use debug;
with camera; use camera;
with world; use world;
with id; use id;
with trgr; use trgr;
with mnstr; use mnstr;
with plyr; use plyr;
with itm; use itm;

package interpreter is
   
   --commands. What is entered by the player to take actions or acknowledge messages
   com_a : String(1 .. Screen_X_Length) :=
      (LC_A, others=>NUL);
   com_b : String(1 .. Screen_X_Length) :=
      (LC_B, others=>NUL);
   com_c : String(1 .. Screen_X_Length) :=
      (LC_C, others=>NUL);
   com_d : String(1 .. Screen_X_Length) :=
      (LC_D, others=>NUL);
   com_e : String(1 .. Screen_X_Length) :=
      (LC_E, others=>NUL);
   com_s : String(1 .. Screen_X_Length) :=
      (LC_S, others=>NUL);
   com_q : String(1 .. Screen_X_Length) :=
      (LC_Q, others=>NUL);
   com_y : String(1 .. Screen_X_Length) :=
      (LC_Y, others=>NUL);
   com_n : String(1 .. Screen_X_Length) :=
      (LC_N, others=>NUL);
   com_z : String(1 .. Screen_X_Length) :=
      (LC_Z, others=>NUL);
   com_8 : String(1 .. Screen_X_Length) :=
      ('8', others=>NUL);
   com_2 : String(1 .. Screen_X_Length) :=
      ('2', others=>NUL);
   com_4 : String(1 .. Screen_X_Length) :=
      ('4', others=>NUL);
   com_6 : String(1 .. Screen_X_Length) :=
      ('6', others=>NUL);
   com_7 : String(1 .. Screen_X_Length) :=
      ('7', others=>NUL);
   com_9 : String(1 .. Screen_X_Length) :=
      ('9', others=>NUL);
   com_1 : String(1 .. Screen_X_Length) :=
      ('1', others=>NUL);
   com_3 : String(1 .. Screen_X_Length) :=
      ('3', others=>NUL);
   com_close : String(1 .. Screen_X_Length) :=
      ('c','l','o','s','e', others=>NUL);


   --Interpret: L : current level, S : Player entered string, IT : what input interpreter should be expecting
   --           Intrepts player input to do an action
   function Interpret (L : in out Level; S : String; IT : Input_Type) return Boolean;
  
   --Others_Action: L : current level. Lets monsters and NPCs take an action
   procedure Others_Action (L : in out Level);

end interpreter;
