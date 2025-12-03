-- ========================== FIBONACCI ======================================= 
  
-- ==================================================
-- FIBONACCI COM CONTADOR (IMEDIATOS CORRIGIDOS + ITERAÇÃO EM R7)
-- Registradores:
-- R1 = anterior
-- R2 = atual
-- R3 = prox
-- R4 = saída/LED
-- R5 = contador
-- R6 = zero temporário para comparação
-- R7 = iteração atual (contador de iterações)
-- Memória: M[1]=anterior, M[2]=atual, M[3]=prox, M[4]=contador, M[0x3F]=LED
-- ==================================================

tmp(0)   := LDI  & R1 & R0 & R0 & x"00000000"; -- R1 = 0.0
tmp(1)   := STM  & R0 & R1 & R0 & x"00000001"; -- M[1] = R1

tmp(2)   := LDI  & R2 & R0 & R0 & x"3F800000"; -- R2 = 1.0
tmp(3)   := STM  & R0 & R2 & R0 & x"00000002"; -- M[2] = R2

tmp(4)   := LDI  & R5 & R0 & R0 & x"41200000"; -- R5 = 10.0
tmp(5)   := LDI  & R7 & R0 & R0 & x"00000000"; -- R7 = 0.0
tmp(6)   := STM  & R0 & R5 & R0 & x"00000004"; -- M[4] = R5

-- LOOP (início tmp(7))
tmp(7)   := LDM  & R1 & R0 & R0 & x"00000001"; -- R1 = M[1]
tmp(8)   := LDM  & R2 & R0 & R0 & x"00000002"; -- R2 = M[2]

tmp(9)   := ADD  & R3 & R1 & R2 & x"00000000"; -- R3 = R1 + R2
tmp(10)  := STM  & R0 & R3 & R0 & x"00000003"; -- M[3] = R3

-- <<< CORREÇÃO AQUI: usar ADDi para somar o imediato 1.0 em ponto flutuante >>>
tmp(11)  := ADDi & R7 & R7 & R0 & x"3F800000"; -- R7 = R7 + 1.0

tmp(12)  := MOV  & R1 & R0 & R2 & x"00000000"; -- R1 = R2
tmp(13)  := STM  & R0 & R1 & R0 & x"00000001"; -- M[1] = R1

tmp(14)  := MOV  & R2 & R0 & R3 & x"00000000"; -- R2 = R3
tmp(15)  := STM  & R0 & R2 & R0 & x"00000002"; -- M[2] = R2

tmp(16)  := MOV  & R4 & R0 & R3 & x"00000000"; -- R4 = R3
tmp(17)  := STM  & R0 & R4 & R0 & x"0000003F"; -- LED = R4

tmp(18)  := LDM  & R5 & R0 & R0 & x"00000004"; -- R5 = M[4]
tmp(19)  := ADDi & R5 & R5 & R0 & x"BF800000"; -- R5 = R5 + (-1.0)
tmp(20)  := STM  & R0 & R5 & R0 & x"00000004"; -- M[4] = R5

tmp(21)  := LDI  & R6 & R0 & R0 & x"00000000"; -- R6 = 0.0
tmp(22)  := JEQ  & R0 & R5 & R6 & x"00000018"; -- if R5==0 -> tmp(24)

tmp(23)  := JMP  & R0 & R0 & R0 & x"00000007"; -- back to tmp(7)

tmp(24)  := JMP  & R0 & R0 & R0 & x"00000018"; -- HALT