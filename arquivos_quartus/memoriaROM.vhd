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
  
  
  
  constant R0  : std_logic_vector(2 downto 0) 	:= R0; --R0
  constant R1  : std_logic_vector(2 downto 0) 	:= R1; --R1
  constant R2  : std_logic_vector(2 downto 0) 	:= R2; --R2
  constant R3  : std_logic_vector(2 downto 0) 	:= R3; --R3
  constant R4  : std_logic_vector(2 downto 0) 	:= R4; --R4
  constant R5  : std_logic_vector(2 downto 0) 	:= R5; --R5
  constant R6  : std_logic_vector(2 downto 0) 	:= R6; --R6
  constant R7  : std_logic_vector(2 downto 0) 	:= R7; --R7
  
  
  
  
  
  
  

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
  
  
  
  
 -- ================================== raiz n-ésima (x^(1/n)) por Newton–Raphson ============================  
 
 -- ==================================================
-- LOG_B(X) = ln(x) / ln(b)  (usa série atanh: ln(z) = 2*(y + y^3/3 + y^5/5 + y^7/7 + y^9/9))
-- Entrada: M[1]=x, M[2]=b  (floats)
-- Saída:   M[0x3F] = log_b(x) (float)
-- Registradores:
--  R1 = x/b loader
--  R2 = b loader
--  R3 = y
--  R4 = y^2
--  R5 = term
--  R6 = sum
--  R7 = temp / constants / result
-- ==================================================

-- -------- compute ln(x) --------
tmp(0)  := LDM  & R1 & R0 & R0 & x"3F800000"; -- R1 = M[1]  (load x; addr field = 1.0)
tmp(1)  := LDI  & R7 & R0 & R0 & x"3F800000"; -- R7 = 1.0

tmp(2)  := SUB  & "003" & R1 & R7 & x"00000000"; -- R3 = R1 - R7   (x - 1)
tmp(3)  := ADD  & "004" & R1 & R7 & x"00000000"; -- R4 = R1 + R7   (x + 1)
tmp(4)  := DIV  & "003" & "003" & "004" & x"00000000"; -- R3 = R3 / R4   (y = (x-1)/(x+1))

tmp(5)  := MUL  & "004" & "003" & "003" & x"00000000"; -- R4 = R3 * R3   (y^2)

tmp(6)  := MOV  & "006" & R0 & "003" & x"00000000"; -- R6 = R3        (sum := y)
tmp(7)  := MOV  & "005" & R0 & "003" & x"00000000"; -- R5 = R3        (term := y)

-- term k=3: term *= y^2 => y^3
tmp(8)  := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^3)
tmp(9)  := LDI  & "007" & R0 & R0 & x"40400000"; -- R7 = 3.0
tmp(10) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7  (y^3/3)
tmp(11) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5  (sum += y^3/3)

-- term k=5: term *= y^2 => y^5
tmp(12) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^5)
tmp(13) := LDI  & "007" & R0 & R0 & x"40A00000"; -- R7 = 5.0
tmp(14) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7  (y^5/5)
tmp(15) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5  (sum += y^5/5)

-- term k=7: term *= y^2 => y^7
tmp(16) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^7)
tmp(17) := LDI  & "007" & R0 & R0 & x"40E00000"; -- R7 = 7.0
tmp(18) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7  (y^7/7)
tmp(19) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5  (sum += y^7/7)

-- term k=9: term *= y^2 => y^9
tmp(20) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^9)
tmp(21) := LDI  & "007" & R0 & R0 & x"41100000"; -- R7 = 9.0
tmp(22) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7  (y^9/9)
tmp(23) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5  (sum += y^9/9)

-- ln(x) = 2 * sum
tmp(24) := LDI  & "007" & R0 & R0 & x"40000000"; -- R7 = 2.0
tmp(25) := MUL  & "006" & "006" & "007" & x"00000000"; -- R6 = R6 * R7  (ln_x in R6)

tmp(26) := STM  & R0 & "006" & R0 & x"40C00000"; -- M[6] = R6   (store ln(x) at addr 6.0)

-- -------- compute ln(b) --------
tmp(27) := LDM  & R1 & R0 & R0 & x"40000000"; -- R1 = M[2]  (load b; addr field = 2.0)
tmp(28) := LDI  & R7 & R0 & R0 & x"3F800000"; -- R7 = 1.0

tmp(29) := SUB  & "003" & R1 & R7 & x"00000000"; -- R3 = R1 - R7   (b - 1)
tmp(30) := ADD  & "004" & R1 & R7 & x"00000000"; -- R4 = R1 + R7   (b + 1)
tmp(31) := DIV  & "003" & "003" & "004" & x"00000000"; -- R3 = R3 / R4   (y_b)

tmp(32) := MUL  & "004" & "003" & "003" & x"00000000"; -- R4 = R3 * R3   (y_b^2)
tmp(33) := MOV  & "006" & R0 & "003" & x"00000000"; -- R6 = R3        (sum_b := y_b)
tmp(34) := MOV  & "005" & R0 & "003" & x"00000000"; -- R5 = R3        (term_b := y_b)

-- term k=3 (b)
tmp(35) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^3)
tmp(36) := LDI  & "007" & R0 & R0 & x"40400000"; -- R7 = 3.0
tmp(37) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7
tmp(38) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5

-- term k=5 (b)
tmp(39) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^5)
tmp(40) := LDI  & "007" & R0 & R0 & x"40A00000"; -- R7 = 5.0
tmp(41) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7
tmp(42) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5

-- term k=7 (b)
tmp(43) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^7)
tmp(44) := LDI  & "007" & R0 & R0 & x"40E00000"; -- R7 = 7.0
tmp(45) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7
tmp(46) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5

-- term k=9 (b)
tmp(47) := MUL  & "005" & "005" & "004" & x"00000000"; -- R5 = R5 * R4   (y^9)
tmp(48) := LDI  & "007" & R0 & R0 & x"41100000"; -- R7 = 9.0
tmp(49) := DIV  & "005" & "005" & "007" & x"00000000"; -- R5 = R5 / R7
tmp(50) := ADD  & "006" & "006" & "005" & x"00000000"; -- R6 = R6 + R5

-- ln(b) = 2 * sum_b
tmp(51) := LDI  & "007" & R0 & R0 & x"40000000"; -- R7 = 2.0
tmp(52) := MUL  & "006" & "006" & "007" & x"00000000"; -- R6 = R6 * R7   (ln_b in R6)

-- load ln_x from memory and compute result
tmp(53) := LDM  & "005" & R0 & R0 & x"40C00000"; -- R5 = M[6]  (ln_x)
tmp(54) := DIV  & "007" & "005" & "006" & x"00000000"; -- R7 = R5 / R6  (result = ln_x / ln_b)

-- store result to LED (M[0x3F])
tmp(55) := STM  & R0 & "007" & R0 & x"427C0000"; -- M[0x3F] = R7  (LED = log_b(x))

-- HALT (jump to own line 55)
tmp(56) := JMP  & R0 & R0 & R0 & x"42440000"; -- HALT -> jump to tmp(56) (49.0 used earlier as example; here we set to 49.0 float if you prefer adjust)



-- =====================================  FIM ====================================== 
  
  
-- ================================== raiz n-ésima (x^(1/n)) por Newton–Raphson ============================  
  
-- ==================================================
-- RAIZ N-ÉSIMA: y = x^(1/n) usando Newton-Raphson
-- Entrada: M[1]=x, M[2]=n   (floats IEEE-754)
-- Saída:   M[0x3F] = y (float)
-- Regs: R1=x, R2=n, R3=y (guess), R4=y_pow, R5=tmp, R6=tmp2, R7=out
-- Mem: M[3]=iter_count, M[4]=exp_counter, M[5]=n_minus1
-- ==================================================

-- 0..5: inicializações
tmp(0)  := LDM  & R1 & R0 & R0 & x"3F800000"; -- R1 = M[1] (x)      (note: addr field stores 1.0 repr)
tmp(1)  := LDM  & R2 & R0 & R0 & x"40000000"; -- R2 = M[2] (n)      (addr field stores 2.0 repr)

-- inicial guess: y0 = x (pode-se usar 1.0 para pequenas x)
tmp(2)  := MOV  & R3 & R0 & R1 & x"00000000"; -- R3 = R1  (y = x)

-- preparar constantes e contador de iterações (10 iters default)
tmp(3)  := LDI  & R7 & R0 & R0 & x"3F800000"; -- R7 = 1.0
tmp(4)  := LDI  & R5 & R0 & R0 & x"41200000"; -- R5 = 10.0 (iterações)
tmp(5)  := STM  & R0 & R5 & R0 & x"00000003"; -- M[3] = R5  (iter_count = 10)

-- 6..12: compute n_minus1 = n - 1  and store in M[5] and also in M[4] as exponent counter
tmp(6)  := SUB  & R6 & R2 & R7 & x"00000000"; -- R6 = R2 - R7   (n - 1)  ; R6 used as n_minus1
tmp(7)  := STM  & R0 & R6 & R0 & x"00000005"; -- M[5] = R6 (n_minus1 saved)
tmp(8)  := STM  & R0 & R6 & R0 & x"00000004"; -- M[4] = R6 (exp counter = n-1)

-- ==================================================
-- LOOP PRINCIPAL DE ITERAÇÃO (inicio_loop := 9)
-- ==================================================
-- cada iteração faz: y_pow = y^(n-1); tmp = x / y_pow; new_y = ((n-1)*y + tmp)/n

-- label loop_start at tmp(9)
tmp(9)  := LDM  & R5 & R0 & R0 & x"00000003"; -- R5 = M[3]   (iter_count)
tmp(10) := JEQ  & R0 & R5 & R7 & x"00000020"; -- if (R5 == 1.0) goto finish (line 32) - we'll stop when count == 1
                                                       -- we compare with R7 (1.0). If you prefer stop at 0, adjust accordingly.

-- ===  compute y_pow = y^(n-1)  ===
tmp(11) := LDI  & R4 & R0 & R0 & x"3F800000"; -- R4 = 1.0        (y_pow = 1.0)
tmp(12) := LDM  & R6 & R0 & R0 & x"00000004"; -- R6 = M[4]      (exp_counter)

tmp(13) := JEQ  & R0 & R6 & R7 & x"00000018"; -- if exp_counter == 1.0 goto after_pow (line 24)
                                                      -- compare R6 with R7 (1.0)

-- pow_loop_start (tmp14)
tmp(14) := MUL  & R4 & R4 & R3 & x"00000000"; -- R4 = R4 * R3   (y_pow *= y)
tmp(15) := ADDi & R6 & R6 & R0 & x"BF800000"; -- R6 = R6 + (-1.0)  (exp_counter -= 1.0)
tmp(16) := STM  & R0 & R6 & R0 & x"00000004"; -- M[4] = R6           (save exp_counter)
tmp(17) := JEQ  & R0 & R6 & R7 & x"00000018"; -- if exp_counter == 1.0 goto after_pow
tmp(18) := JMP  & R0 & R0 & R0 & x"0000000E"; -- goto pow_loop_start (tmp14)

-- after_pow (tmp19)
tmp(19) := LDM  & R5 & R0 & R0 & x"00000004"; -- R5 = M[4]   (reload exp_counter, not used further here)
tmp(20) := DIV  & R5 & R1 & R4 & x"00000000"; -- R5 = R1 / R4  (tmp = x / y_pow)

-- compute (n-1)*y
tmp(21) := LDM  & R6 & R0 & R0 & x"00000005"; -- R6 = M[5]  (n_minus1)
tmp(22) := MUL  & R6 & R6 & R3 & x"00000000"; -- R6 = R6 * R3  ((n-1)*y)

-- numerator = (n-1)*y + tmp
tmp(23) := ADD  & R6 & R6 & R5 & x"00000000"; -- R6 = R6 + R5

-- new_y = numerator / n
tmp(24) := DIV  & R3 & R6 & R2 & x"00000000"; -- R3 = R6 / R2  (R3 = new y)

-- prepare for next iteration: reset exp_counter = n_minus1 in M[4]
tmp(25) := LDM  & R6 & R0 & R0 & x"00000005"; -- R6 = M[5]   (n_minus1)
tmp(26) := STM  & R0 & R6 & R0 & x"00000004"; -- M[4] = R6   (reset exp_counter)

-- decrement iter_count M[3]
tmp(27) := LDM  & R5 & R0 & R0 & x"00000003"; -- R5 = M[3]
tmp(28) := ADDi & R5 & R5 & R0 & x"BF800000"; -- R5 = R5 - 1.0
tmp(29) := STM  & R0 & R5 & R0 & x"00000003"; -- M[3] = R5

-- loop back
tmp(30) := JMP  & R0 & R0 & R0 & x"00000009"; -- goto loop_start (tmp9)

-- ==================================================
-- finish: write result and HALT (tmp32..)
-- ==================================================
tmp(31) := MOV  & R7 & R0 & R3 & x"00000000"; -- R7 = R3
tmp(32) := STM  & R0 & R7 & R0 & x"427C0000"; -- M[0x3F] = R7  (LED = result)
tmp(33) := JMP  & R0 & R0 & R0 & x"00000021"; -- HALT: jump to tmp(33) (0x21=33 decimal)

-- ================================== FIM =============================================


  
  
  
 -- ========================== COSX) =======================================    
  
 -- ==================================================
-- COSSENO(x) por série de Taylor (até x^6)
-- Entrada: M[1] (valor de x em IEEE-754)
-- Saída:   M[0x3F] (LED) recebe resultado (IEEE-754)
-- Registradores: R1..R7 conforme descrito acima
-- ==================================================

tmp(0)  := LDM  & R1 & R0 & R0 & x"3F800000"; -- R1 = M[1] (carrega x)         (addr 1 -> 1.0 repr)
tmp(1)  := LDI  & R3 & R0 & R0 & x"3F800000"; -- R3 = 1.0  (inicializa soma = 1)

-- calcula x^2
tmp(2)  := MUL  & R2 & R1 & R1 & x"00000000"; -- R2 = R1 * R1   (x^2)

-- term1 = x^2 / 2
tmp(3)  := LDI  & R6 & R0 & R0 & x"40000000"; -- R6 = 2.0
tmp(4)  := DIV  & R5 & R2 & R6 & x"00000000"; -- R5 = R2 / R6   (x^2/2)
tmp(5)  := SUB  & R3 & R3 & R5 & x"00000000"; -- R3 = R3 - R5   (sum = 1 - x^2/2)

-- calcula x^4 = x^2 * x^2
tmp(6)  := MUL  & R4 & R2 & R2 & x"00000000"; -- R4 = R2 * R2   (x^4)

-- term2 = x^4 / 24
tmp(7)  := LDI  & R6 & R0 & R0 & x"41C00000"; -- R6 = 24.0
tmp(8)  := DIV  & R5 & R4 & R6 & x"00000000"; -- R5 = R4 / R6   (x^4/24)
tmp(9)  := ADD  & R3 & R3 & R5 & x"00000000"; -- R3 = R3 + R5   (sum += x^4/24)

-- calcula x^6 = x^4 * x^2
tmp(10) := MUL  & R4 & R4 & R2 & x"00000000"; -- R4 = R4 * R2   (x^6)

-- term3 = x^6 / 720
tmp(11) := LDI  & R6 & R0 & R0 & x"44340000"; -- R6 = 720.0
tmp(12) := DIV  & R5 & R4 & R6 & x"00000000"; -- R5 = R4 / R6   (x^6/720)
tmp(13) := SUB  & R3 & R3 & R5 & x"00000000"; -- R3 = R3 - R5   (sum -= x^6/720)

-- escreve o resultado no LED
tmp(14) := MOV  & R7 & R0 & R3 & x"00000000"; -- R7 = R3   (move resultado para R7)
tmp(15) := STM  & R0 & R7 & R0 & x"427C0000"; -- M[0x3F] = R7  (LED = result; addr 63.0 -> 0x427C0000)

-- HALT (loop aqui)
tmp(16) := JMP  & R0 & R0 & R0 & x"41800000"; -- salta para linha 16 (16.0 => 0x41800000) -> HALT
 
  
  
-- ========================================== FIM ========================================  
  
  


-- ========================== SIN(X) =======================================   
 
 -- ==================================================
-- SENO(x) por série de Taylor (até x^7)
-- Entrada: M[1] (valor de x em IEEE-754)
-- Saída:   M[0x3F] (LED) recebe resultado (IEEE-754)
-- Registradores: R1..R7 conforme descrito acima
-- ==================================================

tmp(0)  := LDM  & R1 & R0 & R0 & x"3F800000"; -- R1 = M[1] (carrega x)    (addr 1 -> 1.0 repr)
tmp(1)  := MOV  & R3 & R0 & R1 & x"00000000"; -- R3 = R1   (soma := x)

-- calcula x^2
tmp(2)  := MUL  & R2 & R1 & R1 & x"00000000"; -- R2 = R1 * R1   (x2)

-- calcula x^3 = x2 * x
tmp(3)  := MUL  & R4 & R2 & R1 & x"00000000"; -- R4 = R2 * R1   (x3)

-- term1 = x^3 / 6
tmp(4)  := LDI  & R6 & R0 & R0 & x"40C00000"; -- R6 = 6.0
tmp(5)  := DIV  & R5 & R4 & R6 & x"00000000"; -- R5 = R4 / R6   (x3/6)
tmp(6)  := SUB  & R3 & R3 & R5 & x"00000000"; -- R3 = R3 - R5   (sum -= x3/6)

-- calcula x^5 = x^3 * x^2
tmp(7)  := MUL  & R4 & R4 & R2 & x"00000000"; -- R4 = R4 * R2   (now R4 = x5)

-- term2 = x^5 / 120
tmp(8)  := LDI  & R6 & R0 & R0 & x"42F00000"; -- R6 = 120.0
tmp(9)  := DIV  & R5 & R4 & R6 & x"00000000"; -- R5 = R4 / R6   (x5/120)
tmp(10) := ADD  & R3 & R3 & R5 & x"00000000"; -- R3 = R3 + R5   (sum += x5/120)

-- calcula x^7 = x^5 * x^2
tmp(11) := MUL  & R4 & R4 & R2 & x"00000000"; -- R4 = R4 * R2   (now R4 = x7)

-- term3 = x^7 / 5040
tmp(12) := LDI  & R6 & R0 & R0 & x"459D8000"; -- R6 = 5040.0
tmp(13) := DIV  & R5 & R4 & R6 & x"00000000"; -- R5 = R4 / R6   (x7/5040)
tmp(14) := SUB  & R3 & R3 & R5 & x"00000000"; -- R3 = R3 - R5   (sum -= x7/5040)

-- escreve o resultado no LED
tmp(15) := MOV  & R7 & R0 & R3 & x"00000000"; -- R7 = R3   (move resultado para R7)
tmp(16) := STM  & R0 & R7 & R0 & x"427C0000"; -- M[0x3F] = R7  (LED = result, addr 63.0 => 0x427C0000)

-- HALT (loop aqui)
tmp(17) := JMP  & R0 & R0 & R0 & x"41880000"; -- salta para linha 17 (17.0 => 0x41880000) -> HALT
-- ========================== FIM ======================================= 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

-- ========================== FIBONACCI ======================================= 
  
-- ========================== FIBONACCI ======================================= 
  
-- ==================================================
-- FIBONACCI COM CONTADOR (IMEDIATOS CORRIGIDOS)
-- Registradores:
-- R1 = anterior
-- R2 = atual
-- R3 = prox
-- R4 = saída/LED
-- R5 = contador
-- R6 = zero temporário para comparação
-- Memória: M[1]=anterior, M[2]=atual, M[3]=prox, M[4]=contador, M[0x3F]=LED
-- ==================================================

tmp(0)   := LDI  & R1 & R0 & R0 & x"00000000"; -- R1 = 0.0        (IEEE754 0.0)
tmp(1)   := STM  & R0 & R1 & R0 & x"00000001"; -- M[1] = R1      (addr 1, integer hex)

tmp(2)   := LDI  & R2 & R0 & R0 & x"3F800000"; -- R2 = 1.0        (IEEE754 1.0)
tmp(3)   := STM  & R0 & R2 & R0 & x"00000002"; -- M[2] = R2      (addr 2, integer hex)

tmp(4)   := LDI  & R5 & R0 & R0 & x"41200000"; -- R5 = 10.0       (IEEE754 10.0)
tmp(5)   := STM  & R0 & R5 & R0 & x"00000004"; -- M[4] = R5      (addr 4, integer hex)

-- ==================================================
-- LOOP FIBONACCI (início: linha 6)
-- ==================================================

tmp(6)   := LDM  & R1 & R0 & R0 & x"00000001"; -- R1 = M[1]      (load from addr 1)
tmp(7)   := LDM  & R2 & R0 & R0 & x"00000002"; -- R2 = M[2]      (load from addr 2)

tmp(8)   := ADD  & R3 & R1 & R2 & x"00000000"; -- R3 = R1 + R2
tmp(9)   := STM  & R0 & R3 & R0 & x"00000003"; -- M[3] = R3      (store to addr 3)

-- atualiza anterior = atual
tmp(10)  := MOV  & R1 & R0 & R2 & x"00000000"; -- R1 = R2
tmp(11)  := STM  & R0 & R1 & R0 & x"00000001"; -- M[1] = R1      (addr 1)

-- atualiza atual = prox
tmp(12)  := MOV  & R2 & R0 & R3 & x"00000000"; -- R2 = R3
tmp(13)  := STM  & R0 & R2 & R0 & x"00000002"; -- M[2] = R2      (addr 2)

-- envia para LED
tmp(14)  := MOV  & R4 & R0 & R3 & x"00000000"; -- R4 = R3
tmp(15)  := STM  & R0 & R4 & R0 & x"0000003F"; -- LED = R4 (addr 0x3F)

-- ==================================================
-- DECREMENTA CONTADOR
-- ==================================================

tmp(16)  := LDM  & R5 & R0 & R0 & x"00000004"; -- R5 = M[4]      (load counter from addr 4)
tmp(17)  := ADDi & R5 & R5 & R0 & x"BF800000"; -- R5 = R5 + (-1.0)  (imediato IEEE754 -1.0)
tmp(18)  := STM  & R0 & R5 & R0 & x"00000004"; -- M[4] = R5      (store counter back)

-- ==================================================
-- TESTE DO CONTADOR (SE R5 == 0 → FIM)
-- ==================================================

tmp(19)  := LDI  & R6 & R0 & R0 & x"00000000"; -- R6 = 0.0        (IEEE754 0.0)
tmp(20)  := JEQ  & R0 & R5 & R6 & x"00000016"; -- if R5 == R6 jump to tmp(22) (0x16 = 22 decimal)

-- ==================================================
-- LOOP CONTINUA
-- ==================================================

tmp(21)  := JMP  & R0 & R0 & R0 & x"00000006"; -- jump back to tmp(6) (0x06 = 6 decimal)

-- ==================================================
-- HALT (loop infinito aqui)
-- ==================================================

tmp(22)  := JMP  & R0 & R0 & R0 & x"00000016"; -- HALT (jump to itself, 0x16 = 22 decimal)

-- ========================== FIM ======================================= 


-- ========================== FIM ======================================= 

		  
		  
		  
		  
		  
--tmp(0)  	:= LDI  & R1 & R0 & R0 & x"00000001"; -- carrega $1 em R1
--tmp(1) 	:= STM  & R0 & R1 & R0 & x"00000001"; -- salva R1 em M[1]
--tmp(2) 	:= LDM  & R2 & R0 & R0 & x"00000001"; -- CARREGA M[1] em R2  
--tmp(3)   := ADD  &  R3  & R1 & R2 & x"00000000"; -- SOMA R1 com R2 e salva em R3 (3) 
--tmp(4)   := ADDi  &  R3  & R3 & R0 & x"00000001"; -- SOMA R3 com 1 e guarda em R3
--tmp(5)   := MOV  &  R4  & R0 & R3 & x"00000001"; -- MOV R3 para R4
--
--tmp(6) 	:= STM  & R0 & R4 & R0 & x"0000003F"; -- printa R4 ($3)
--
--
--tmp(7) 	:= JEQ  & R0 & R4 & R4 & x"00000009"; -- compara R4 com R4 e pula se igual para linha de programa 15
--
--
--
--tmp(8) 	:= JMP  & R0 & R0 & R0 & x"00000000"; -- pula para linha 0
--
--tmp(9) 	:= JEQ  & R0 & R7 & R4 & x"0000000F"; -- compara R7 com R4 e pula se igual para linha de programa 15
--
--tmp(10) 	:= JMP  & R0 & R0 & R0 & x"00000000"; -- pula para linha 0


--tmp(15) 	:= JMP  & R0 & R0 & R0 & x"00000000"; -- pula para linha 0

			
			
		  
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;