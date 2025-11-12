library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity IARITH is

    port
    (
		  CLOCK_50 : in STD_LOGIC;
        INSTRUCAO	: out STD_LOGIC_VECTOR( 12 downto 0);
        DATA_IN : out STD_LOGIC_VECTOR(7 downto 0);
		  DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0);
		  ADDRESS : out STD_LOGIC_VECTOR(7 downto 0)
    );
	 
end entity;


architecture comportamento of IARITH is

	 signal entradaPC: std_logic_vector(8 downto 0);
	 signal saidaPC: std_logic_vector(8 downto 0);
	 signal sig_PC_Mais1: std_logic_vector(8 downto 0);
	 

    begin
	 
	 
---FETCH
		  
		  Registrador_PC :  entity work.registradorGenerico
		  generic map (larguraDados => 9)
        port map( DIN => entradaPC,
		            DOUT => saidaPC,
						ENABLE => '1',
						CLK => CLOCK_50,
						RST => '0'
						
						);
			
        PC_Mais1 :  entity work.somadorGenerico_Mais1
        port map( entrada => saidaPC,
        saida => sig_PC_Mais1
		  );
					  
		  memoriaROM : entity work.memoriaROM
		  generic map (dataWidth => 13, addrWidth => 9)
        port map (Endereco => sig_PC_Mais1,
		  Dado => INSTRUCAO
		  );
		  
		  mux4x1 :  entity work.mux4x1_9Bits
        port map( entradaA_MUX => sig_PC_Mais1,
                 entradaB_MUX =>  '0' & x"0B",
					  entradaC_MUX => '0' & x"0C",
                 entradaD_MUX =>  '0' & x"0D",
                 seletor_MUX => "00",
                 saida_MUX => entradaPC
		   );
			
			
		  
end architecture;