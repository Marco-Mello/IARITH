# ------------------------------------------------------------
# Cálculo de sin(x) via série de Taylor (forma iterativa)
# ------------------------------------------------------------

LDI  R2, -2.5        # carrega x = 1.2
MOV  R4, R2         # termo inicial = x
MOV  R3, R2         # soma inicial = x
STM  [0], R3        # salva resultado inicial em M[0]

LDI  R5, 0.0        # k = 0
LDI  R7, 5.0        # número de iterações do loop
LDI  R0, 0.0        # R0 = zero

# ---------------------- LOOP -------------------------------

.loop_start:         # label do loop (termina com :)

JEQ  R7, R0, .end    # se R7 == 0 → fim

ADD  R6, R5, R5      # R6 = 2k
ADDi R6, R6, 2.0     # R6 = 2k + 2

MUL  R1, R6, R6      # R1 = (2k+2)²
ADD  R1, R1, R6      # R1 = (2k+2)(2k+3)

MUL  R6, R2, R2      # R6 = x²
DIV  R6, R6, R1      # R6 = x² / denom
SUB  R6, R0, R6      # R6 = -x² / denom (alterna sinal)

MUL  R6, R4, R6      # novo termo
ADD  R3, R3, R6      # soma += termo
MOV  R4, R6          # termo_anterior = termo

STM  [0], R3         # salva resultado parcial

ADDi R5, R5, 1.0     # k++
ADDi R7, R7, -1.0    # contador--

JMP  .loop_start     # volta ao início do loop

# ---------------------- FIM -------------------------------

.end:                # label final

STM  [0], R3         # grava resultado final
