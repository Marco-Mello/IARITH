library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 8;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is



	
  constant NOP  : std_logic_vector(3 downto 0) 	:= "0000"; --NOP 
  constant LDM  	: std_logic_vector(3 downto 0) 	:= "0001"; --RD <= [M] 
  constant LDi  : std_logic_vector(3 downto 0) 	:= "0010"; --RD <= Imed.
  constant STM  : std_logic_vector(3 downto 0) 	:= "0011"; --[M] <= RA
  
  constant ADD : std_logic_vector(3 downto 0) 	:= "0100"; --RD <= RA + RB
  constant ADDi : std_logic_vector(3 downto 0) := "0101"; --RD <= RA + Imed.
  

  constant JMP : std_logic_vector(3 downto 0) 	:= "0110"; -- PC <= Imed.
  constant JEQ : std_logic_vector(3 downto 0) 	:= "0111"; -- (PC <= Imed.) if A = B
  constant JLS : std_logic_vector(3 downto 0) 	:= "1000"; -- (PC <= Imed.) if A < B
  
  constant MOV : std_logic_vector(3 downto 0) 	:= "1001"; -- RD <= RB
  
  
  
  
  

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
  
  
  
  
-- ==================================================
-- FIBONACCI COM CONTADOR (VERSÃO FINAL CORRIGIDA)
-- Registradores:
-- R1 = anterior ("001")
-- R2 = atual    ("010")
-- R3 = prox     ("011")
-- R4 = saída/LED("100")
-- R5 = contador ("101")
-- Memória: M[1]=anterior, M[2]=atual, M[3]=prox, M[4]=contador, M[0x3F]=LED
-- ==================================================

tmp(0)   := LDI  & "001" & "000" & "000" & x"00000000"; -- R1 = 0 (anterior)
tmp(1)   := STM  & "000" & "001" & "000" & x"00000001"; -- M[1] = R1

tmp(2)   := LDI  & "010" & "000" & "000" & x"00000001"; -- R2 = 1 (atual)
tmp(3)   := STM  & "000" & "010" & "000" & x"00000002"; -- M[2] = R2

tmp(4)   := LDI  & "101" & "000" & "000" & x"0000000A"; -- R5 = 10 (contador)
tmp(5)   := STM  & "000" & "101" & "000" & x"00000004"; -- M[4] = R5

-- ==================================================
-- LOOP FIBONACCI (início: linha 6)
-- ==================================================

tmp(6)   := LDM  & "001" & "000" & "000" & x"00000001"; -- R1 = M[1]
tmp(7)   := LDM  & "010" & "000" & "000" & x"00000002"; -- R2 = M[2]

tmp(8)   := ADD  & "011" & "001" & "010" & x"00000000"; -- R3 = R1 + R2
tmp(9)   := STM  & "000" & "011" & "000" & x"00000003"; -- M[3] = R3

-- atualiza anterior = atual
tmp(10)  := MOV  & "001" & "000" & "010" & x"00000000"; -- R1 = R2
tmp(11)  := STM  & "000" & "001" & "000" & x"00000001"; -- M[1] = R1

-- atualiza atual = prox
tmp(12)  := MOV  & "010" & "000" & "011" & x"00000000"; -- R2 = R3
tmp(13)  := STM  & "000" & "010" & "000" & x"00000002"; -- M[2] = R2

-- envia para LED
tmp(14)  := MOV  & "100" & "000" & "011" & x"00000000"; -- R4 = R3
tmp(15)  := STM  & "000" & "100" & "000" & x"0000003F"; -- LED = R4 (M[0x3F])

-- ==================================================
-- DECREMENTA CONTADOR
-- ==================================================

tmp(16)  := LDM  & "101" & "000" & "000" & x"00000004"; -- R5 = M[4]
tmp(17)  := ADDi & "101" & "101" & "000" & x"FFFFFFFF"; -- R5 = R5 - 1
tmp(18)  := STM  & "000" & "101" & "000" & x"00000004"; -- M[4] = R5

-- ==================================================
-- TESTE DO CONTADOR (SE R5 == 0 → FIM)
-- ==================================================

tmp(19)  := LDI  & "110" & "000" & "000" & x"00000000"; -- R6 = 0 (valor zero para comparar)
tmp(20)  := JEQ  & "000" & "101" & "110" & x"00000016"; -- se R5 == R6, pula para tmp(22) (linha 22 -> 0x16)

-- ==================================================
-- LOOP CONTINUA
-- ==================================================

tmp(21)  := JMP  & "000" & "000" & "000" & x"00000006"; -- volta ao início do loop (linha 6)

-- ==================================================
-- HALT (loop infinito aqui)
-- ==================================================

tmp(22)  := JMP  & "000" & "000" & "000" & x"00000016"; -- trava aqui (HALT) -> salta para tmp(22) (hex 0x16 = 22 decimal)



		  
		  
		  
		  
		  
--tmp(0)  	:= LDI  & "001" & "000" & "000" & x"00000001"; -- carrega $1 em R1
--tmp(1) 	:= STM  & "000" & "001" & "000" & x"00000001"; -- salva R1 em M[1]
--tmp(2) 	:= LDM  & "010" & "000" & "000" & x"00000001"; -- CARREGA M[1] em R2  
--tmp(3)   := ADD  &  "011"  & "001" & "010" & x"00000000"; -- SOMA R1 com R2 e salva em R3 (3) 
--tmp(4)   := ADDi  &  "011"  & "011" & "000" & x"00000001"; -- SOMA R3 com 1 e guarda em R3
--tmp(5)   := MOV  &  "100"  & "000" & "011" & x"00000001"; -- MOV R3 para R4
--
--tmp(6) 	:= STM  & "000" & "100" & "000" & x"0000003F"; -- printa R4 ($3)
--
--
--tmp(7) 	:= JEQ  & "000" & "100" & "100" & x"00000009"; -- compara R4 com R4 e pula se igual para linha de programa 15
--
--
--
--tmp(8) 	:= JMP  & "000" & "000" & "000" & x"00000000"; -- pula para linha 0
--
--tmp(9) 	:= JEQ  & "000" & "111" & "100" & x"0000000F"; -- compara R7 com R4 e pula se igual para linha de programa 15
--
--tmp(10) 	:= JMP  & "000" & "000" & "000" & x"00000000"; -- pula para linha 0


--tmp(15) 	:= JMP  & "000" & "000" & "000" & x"00000000"; -- pula para linha 0

			
			
		  
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;