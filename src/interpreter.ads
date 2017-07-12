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

package interpreter is
   
   com_a : String(1 .. Screen_X_Length) :=
      (LC_A, others=>NUL);
   com_d : String(1 .. Screen_X_Length) :=
      (LC_D, others=>NUL);
   com_w : String(1 .. Screen_X_Length) :=
      (LC_W, others=>NUL);
   com_s : String(1 .. Screen_X_Length) :=
      (LC_S, others=>NUL);
   com_q : String(1 .. Screen_X_Length) :=
      (LC_Q, others=>NUL);
   com_y : String(1 .. Screen_X_Length) :=
      (LC_Y, others=>NUL);
   com_n : String(1 .. Screen_X_Length) :=
      (LC_N, others=>NUL);
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


   function Interpret (L : in out Level; S : String; IT : Input_Type) return Boolean;
  
   procedure Others_Action (L : in out Level);

end interpreter;
