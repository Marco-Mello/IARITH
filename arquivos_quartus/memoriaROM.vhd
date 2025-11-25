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
  
  
  
  
  

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
  
        -- Inicializa os endereços:
		 tmp(0)  := LDI  & "000" & "000" & "000" & x"00000000"; -- 0
		 tmp(1)  := STM  & "000" & "000" & "000" & x"00000000"; -- fib: 0 -> @0

		 tmp(2)  := LDI  & "000" & "000" & "000" & x"00000000"; -- 0
		 tmp(3)  := STM  & "000" & "000" & "000" & x"00000001"; -- anterior: 0 -> @1

		 tmp(4)  := LDI  & "000" & "000" & "000" & x"00000001"; -- 1
		 tmp(5)  := STM  & "000" & "000" & "000" & x"00000002"; -- atual: 1 -> @2

		 tmp(6)  := LDI  & "000" & "000" & "000" & x"00000000"; -- 0
		 tmp(7)  := STM  & "000" & "000" & "000" & x"00000003"; -- prox: 0 -> @3

		 tmp(8)  := LDI  & "000" & "000" & "000" & x"0000000F"; -- 15
		 tmp(9)  := STM  & "000" & "000" & "000" & x"0000000A"; -- total: 15 -> @10


		 tmp(10) := LDM  & "000" & "000" & "000" & x"00000001"; -- carrega anterior
		 tmp(11) := ADD  &  "000"  & "000" & "000" & x"00000002"; -- ADD atual
		 tmp(12) := STM  & "000" & "000" & "000" & x"00000003"; -- salva prox

		 tmp(13) := LDM  & "000" & "000" & "000" & x"00000002"; -- carrega atual
		 tmp(14) := STM  & "000" & "000" & "000" & x"00000001"; -- salva anterior

		 tmp(15) := LDM  & "000" & "000" & "000" & x"00000003"; -- carrega prox
		 tmp(16) := STM  & "000" & "000" & "000" & x"00000002"; -- salva atual
		 tmp(17) := STM  & "000" & "000" & "000" & x"00000000"; -- salva valor de fib
		 tmp(18) := STM  & "000" & "000" & "000" & x"0000003F"; -- printa no LED
		 tmp(19) := JMP  & "000" & "000" & "000" & x"0000000A"; -- pula para linha 10 (carrega atual)
		  
		  
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;