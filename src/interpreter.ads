with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO; use Ada.Text_IO;

with dungeon; use dungeon;
with screen; use screen;
with level; use level;
with debug; use debug;
with camera; use camera;
with world; use world;

package interpreter is
   
   com_a : String(1 .. Screen_X_Length) :=
     (LC_A, others=>NUL);
   com_d : String(1 .. Screen_X_Length) :=
     (LC_D, others=>NUL);
   com_w : String(1 .. Screen_X_Length) :=
     (LC_W, others=>NUL);
   com_s : String(1 .. Screen_X_Length) :=
     (LC_S, others=>NUL);  
  
   procedure Interpret (L : in out level.Level; S : String);
  
   procedure Move_Up(L : in out level.Level);
   procedure Move_Down(L : in out level.Level);
   procedure Move_Left(L : in out level.Level);
   procedure Move_Right(L : in out level.Level);

end interpreter;
