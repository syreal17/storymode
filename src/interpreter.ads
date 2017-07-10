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
  
   function Interpret (L : in out Level; S : String; IT : Input_Type) return Boolean;
  
   procedure Move_Up(L : in out Level);
   procedure Move_Down(L : in out Level);
   procedure Move_Left(L : in out Level);
   procedure Move_Right(L : in out Level);

end interpreter;
