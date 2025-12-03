# ------------------------------------------------------------
# Cálculo de cos(x) via série de Taylor (forma iterativa)
# ------------------------------------------------------------

LDI  R2, 1.2        # x = 1.2
LDI  R4, 1.0        # termo inicial = 1
LDI  R3, 1.0        # soma inicial = 1
STM  [0], R3        # grava valor inicial em M[0]

LDI  R5, 0.0        # k = 0
LDI  R7, 5.0        # número de iterações
LDI  R0, 0.0        # R0 = zero

# ---------------------- LOOP -------------------------------

.loop_start:         # label do loop

JEQ  R7, R0, .end    # se R7 == 0 → fim

ADD  R6, R5, R5      # R6 = 2k
ADDi R6, R6, 1.0     # R6 = 2k + 1

MUL  R1, R6, R6      # R1 = (2k+1)^2
ADD  R1, R1, R6      # R1 = (2k+1)*(2k+2)

MUL  R6, R2, R2      # R6 = x²
DIV  R6, R6, R1      # R6 = x² / denom
SUB  R6, R0, R6      # R6 = -x² / denom

MUL  R6, R4, R6      # novo termo
ADD  R3, R3, R6      # soma += novo termo
MOV  R4, R6          # term = novo termo

STM  [0], R3         # grava soma parcial

ADDi R5, R5, 1.0     # k++
ADDi R7, R7, -1.0    # iterações--

JMP  .loop_start     # volta ao início

# ---------------------- FIM -------------------------------

.end:
STM  [0], R3         # grava soma final
