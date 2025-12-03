# ------------------------------------------------------------
# Cálculo da raiz n-ésima de x usando o método de Newton
# Fórmula:
#   y_{k+1} = (1/n) * ( (n-1)*y_k + x / y_k^{n-1} )
# A cada iteração, salva o valor em M[0].
# ------------------------------------------------------------

LDI  R2, 1.2         # x = 1.2
LDI  R3, 3.0         # n = 3
LDI  R4, 1.0         # y = chute inicial
STM  [0], R4         # grava chute inicial

LDI  R7, 10.0        # número de iterações
LDI  R0, 0.0         # zero constante

# ------------------------------------------------------------
# Início do laço
# ------------------------------------------------------------

.inicio_laco:

JEQ  R7, R0, .fim    # se R7 == 0 → fim

MOV  R5, R3          # R5 = n
ADDi R5, R5, -1.0    # R5 = n - 1
LDI  R6, 1.0         # R6 = acumulador y^(n-1) = 1

# Se n-1 == 0, então y^(n-1) = 1 → pula multiplicações
JEQ  R5, R0, .apos_calculo_potencia

# ------------------------------------------------------------
# Loop interno para calcular y^(n-1)
# ------------------------------------------------------------

.calcula_potencia:
MUL  R6, R6, R4      # R6 *= y
ADDi R5, R5, -1.0    # R5 -= 1
JMP  .testa_potencia

.testa_potencia:
JEQ  R5, R0, .apos_calculo_potencia
JMP  .calcula_potencia

# ------------------------------------------------------------
# Após calcular y^(n-1)
# ------------------------------------------------------------

.apos_calculo_potencia:
DIV  R1, R2, R6      # R1 = x / y^(n-1)

MOV  R5, R3          # R5 = n
ADDi R5, R5, -1.0    # R5 = n - 1
MUL  R5, R5, R4      # R5 = (n-1)*y

ADD  R5, R5, R1      # R5 = (n-1)*y + x / y^(n-1)

DIV  R4, R5, R3      # y = R5 / n   (nova aproximação)
STM  [0], R4         # grava aproximação atual

ADDi R7, R7, -1.0    # decrementa contador de iterações

JEQ  R7, R0, .fim    # se acabou → fim
JMP  .inicio_laco    # senão retorna ao início

# ------------------------------------------------------------
# Fim
# ------------------------------------------------------------

.fim:
STM  [0], R4         # salva última aproximação
