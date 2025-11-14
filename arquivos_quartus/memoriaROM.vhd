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



	
  constant NOP  : std_logic_vector(3 downto 0) 	:= "0000";
  constant LDA  : std_logic_vector(3 downto 0) 	:= "0001";
  constant LDI  : std_logic_vector(3 downto 0) 	:= "0010";
  constant STA  : std_logic_vector(3 downto 0) 	:= "0011";
  
  constant SOMA : std_logic_vector(3 downto 0) 	:= "0100";
  constant SOMAi : std_logic_vector(3 downto 0) := "0101";
  
  constant CLS : std_logic_vector(3 downto 0) 	:= "0110";
  constant JLS : std_logic_vector(3 downto 0) 	:= "0111";
  constant CEQ : std_logic_vector(3 downto 0) 	:= "1000";
  constant JEQ : std_logic_vector(3 downto 0) 	:= "1001";
  
  constant JMP : std_logic_vector(3 downto 0) 	:= "1010";
  
  
  
  

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
        -- Inicializa os endereços:
        tmp(0) := LDI & "00000000" & "00000000"; -- 0
        tmp(1) := STA & "00000000" & "00000000"; -- fib: 0 -> @0
		  
		  tmp(2) := LDI & "00000000" & "00000000"; -- 0
        tmp(3) := STA & "00000000" & "00000001"; -- anterior: 0 -> @1
		  
        tmp(4) := LDI & "00000000" & "00000001"; -- 1
        tmp(5) := STA & "00000000" & "00000010"; -- atual: 1 -> @2
		  
        tmp(6) := LDI & "00000000" & "00000000"; -- 0
        tmp(7) := STA & "00000000" & "00000011"; -- prox: 0 -> @3
		  
        tmp(8) := LDI & "00000000" & "00001111"; -- 15
        tmp(9) := STA & "00000000" & "00001010"; -- total: 15 -> @10
		  
		  
		   
		  
		  tmp(10) := LDA & "00000000" & "00000001"; -- carrega anterior
		  tmp(11) := SOMA & "00000000" & "00000010"; -- soma atual
		  tmp(12) := STA & "00000000" & "00000011"; -- salva prox
		  
		  
		  tmp(13) := LDA & "00000000" & "00000010"; -- carrega atual
		  tmp(14) := STA & "00000000" & "00000001"; -- salva anterior
		  
		  tmp(15) := LDA & "00000000" & "00000011"; -- carrega prox
		  tmp(16) := STA & "00000000" & "00000010"; -- salva atual
        tmp(17) := STA & "00000000" & "00000000"; -- salva valor de fib
		  tmp(18) := STA & "00000000" & "11111111"; -- printa no LED
		  tmp(19) := JMP & "00000000" & "00001010"; -- pula para linha 10 (carrega atual)
		  
		  
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;