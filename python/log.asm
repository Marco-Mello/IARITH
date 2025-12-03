LDI R0,0.0

LDI R2,4.2
JMP ln_x

.after_ln_x:
STM [1],R4        ; M[1] = ln(4.2)

LDI R2,5.1
JMP ln_b

.after_ln_b:
STM [2],R4        ; M[2] = ln(5.1)

LDM R6,[1]        ; R6 = ln(4.2)
LDM R7,[2]        ; R7 = ln(5.1)

DIV R4,R6,R7      ; R4 = ln(4.2) / ln(5.1)
STM [0],R4
JMP .end


;=========================
;   ROTINA ln(x)
;=========================
ln_x:
LDI R4,1.4
LDI R7,8.0

.newton_x:
JEQ R7,R0,.done_x

LDI R3,1.0
LDI R6,1.0
LDI R5,1.0
LDI R1,9.0

.exp_x:
MUL R6,R6,R4
DIV R6,R6,R5
ADD R3,R3,R6
ADDi R5,R5,1.0
ADDi R1,R1,-1.0
JEQ R1,R0,.exp_done_x
JMP .exp_x

.exp_done_x:
DIV R1,R2,R3
ADD R4,R4,R1
ADDi R4,R4,-1.0
ADDi R7,R7,-1.0
JMP .newton_x

.done_x:
JMP .after_ln_x


;=========================
;   ROTINA ln(b)
;=========================
ln_b:
LDI R4,1.6
LDI R7,8.0

.newton_b:
JEQ R7,R0,.done_b

LDI R3,1.0
LDI R1,1.0
LDI R5,1.0
LDI R6,9.0

.exp_b:
MUL R1,R1,R4
DIV R1,R1,R5
ADD R3,R3,R1
ADDi R5,R5,1.0
ADDi R6,R6,-1.0
JEQ R6,R0,.exp_done_b
JMP .exp_b

.exp_done_b:
DIV R1,R2,R3
ADD R4,R4,R1
ADDi R4,R4,-1.0
ADDi R7,R7,-1.0
JMP .newton_b

.done_b:
JMP .after_ln_b


.end:
JMP .end
