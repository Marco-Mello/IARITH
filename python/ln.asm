# ------------------------------------------------------------
# Calcular ln(x) usando Newton
# x = 4.2
# y_{k+1} = y + x/exp(y) - 1
# exp(y) ~ sum t_m, com t_{m+1} = t_m * y / (m+1)
# Salva cada aproximação em M[0]
# ------------------------------------------------------------

LDI  R2, 4.2         # x = 4.2
LDI  R4, 1.4         # y = chute inicial (aprox)
STM  [0], R4         # salva y inicial

LDI  R7, 8.0         # 8 iterações de Newton
LDI  R0, 0.0         # zero constante

# ------------------------------------------------------------
# LOOP PRINCIPAL NEWTON
# ------------------------------------------------------------

.newton:

JEQ  R7, R0, .fim    # terminou?

# ------------------------------------------------------------
# Calcular exp(y) em R3
# ------------------------------------------------------------

LDI  R3, 1.0         # soma = t0 = 1
LDI  R6, 1.0         # termo t_m = 1
LDI  R5, 1.0         # m = 1

# Usaremos 10 termos no total (m=0 a m=9) → 9 iterações
LDI  R1, 9.0         # R1 = contador restante

.exp_loop:

# t_m = t_m * y / m
MUL  R6, R6, R4      # termo *= y
DIV  R6, R6, R5      # termo /= m

ADD  R3, R3, R6      # soma += termo

ADDi R5, R5, 1.0     # m++
ADDi R1, R1, -1.0    # contador--

JEQ  R1, R0, .exp_done
JMP  .exp_loop

.exp_done:

# ------------------------------------------------------------
# Newton: y = y + x/exp(y) - 1
# ------------------------------------------------------------

DIV  R1, R2, R3      # R1 = x / exp(y)
ADD  R4, R4, R1      # y += R1
ADDi R4, R4, -1.0    # y -= 1

STM  [0], R4         # salva aproximação

ADDi R7, R7, -1.0    # iterações--

JMP  .newton

# ------------------------------------------------------------
# Fim
# ------------------------------------------------------------

.fim:
STM  [0], R4         # grava último valor
