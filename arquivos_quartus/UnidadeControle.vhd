library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas


entity UnidadeControle is
    port
    (
      OpCode:  in STD_LOGIC_VECTOR(3 downto 0);
		PdCIn_flagZero: in std_logic;
		PdCIn_flagMenor: in std_logic;
      pontosDeControle:    out STD_LOGIC_VECTOR(10 downto 0)
      
    );
end entity;

architecture comportamento of UnidadeControle is
  --constant zero : std_logic_vector(larguraDados-1 downto 0) := (others => '0');

--   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
--   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);

	
  constant NOP  : std_logic_vector(3 downto 0) 	:= "0000"; --NOP
  constant LDM  	: std_logic_vector(3 downto 0) 	:= "0001"; --RD <= [M] 
  constant LDi  : std_logic_vector(3 downto 0) 	:= "0010"; --RD <= Imed.
  constant STM  : std_logic_vector(3 downto 0) 	:= "0011"; --[M] <= RA
  
  constant ADD : std_logic_vector(3 downto 0) 	:= "0100"; --RD <= RA + RB
  constant ADDi : std_logic_vector(3 downto 0) := "0101"; --RD <= RA + Imed.
  

  constant JMP : std_logic_vector(3 downto 0) 	:= "0110"; -- PC <= Imed.
  constant JEQ : std_logic_vector(3 downto 0) 	:= "0111"; -- (PC <= Imed.) if A = B
  constant JLS : std_logic_vector(3 downto 0) 	:= "1000"; -- (PC <= Imed.) if A < B
  
  
  
  
  
     alias habEscritaMEM :			std_logic is pontosDeControle(0);
	  
     alias habLeituraMEM :			std_logic is pontosDeControle(1);
	  
	  alias Op_ULA :					std_logic_vector(2 downto 0) is pontosDeControle(4 downto 2);
	  
	  alias Sel_RB_Imed_MEM :		std_logic is pontosDeControle(5);
	  
	  alias habilitaEscrita :		std_logic is pontosDeControle(6);
	  
	  alias Sel_Imed_MEM :			std_logic is pontosDeControle(7);
	  
	  alias habEscritaRetorno :	std_logic is pontosDeControle(8);
	  
	  alias SelJMP :					std_logic_vector(1 downto 0) is pontosDeControle(10 downto 9);
--
    begin
	 
	 
	 habEscritaMEM <= '1' when (OpCode = STM) else '0';
	 
	 habLeituraMEM <= '1' when (OpCode = LDM) else '0';
	 
	 Op_ULA <= "000" when (OpCode = ADD) or (OpCode = ADDi) else
				  "010"when (OpCode  = LDM) or (OpCode  = JEQ) or (OpCode  = JLS) else
				  "111";
				  
	 
	 Sel_RB_Imed_MEM <= '1' when (OpCode = ADD) or (OpCode = JEQ) or (OpCode = JLS)  else '0';
	 
	 habilitaEscrita <= '1' when (OpCode = LDM) or (OpCode = LDi) or (OpCode = ADD) or (OpCode = ADDi) else '0';
	 
	 
	 Sel_Imed_MEM <= '1' when (OpCode = LDi) or (OpCode = ADDi) else '0';
	 
	 habEscritaRetorno <= '0';
	  
	 SelJMP <= "01" when (OpCode = JMP) or (OpCode = JEQ and PdCIn_flagZero = '1') or (OpCode = JLS and PdCIn_flagMenor = '1') else "00"; 


end architecture;