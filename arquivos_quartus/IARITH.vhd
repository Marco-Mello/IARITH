library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity IARITH is

    port
    (
		  CLOCK_50 : in STD_LOGIC;
		  KEY              : in  std_logic_vector(3 downto 0);
		  LEDR             : out std_logic_vector(9 downto 0);
        --INSTRUCAO	: out STD_LOGIC_VECTOR( 12 downto 0);
        DATA_IN : out STD_LOGIC_VECTOR(31 downto 0);
		  DATA_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		  ADDRESS : out STD_LOGIC_VECTOR(7 downto 0);
		  
		  
		  --TESTES
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out STD_LOGIC_VECTOR(6 downto 0) 
    );
	 
end entity;


architecture comportamento of IARITH is

	signal CLK_1s : std_logic;

	 signal entradaPC: std_logic_vector(8 downto 0);
	 signal saidaPC: std_logic_vector(8 downto 0);
	 signal sig_PC_Mais1: std_logic_vector(8 downto 0);
	 signal imedRET : std_logic_vector(8 downto 0);
	 
	 signal INSTRUCAO : std_logic_vector(19 downto 0);
	 
	 
	 alias OpCode : std_logic_vector(3 downto 0) is INSTRUCAO(19 downto 16);
	 alias imediato : std_logic_vector(15 downto 0) is INSTRUCAO(15 downto 0);
	 alias ramADDR : std_logic_vector(7 downto 0) is INSTRUCAO(7 downto 0);
	 alias imedJMP : std_logic_vector(8 downto 0) is INSTRUCAO(8 downto 0);
	 
	 
	 signal PdC : std_logic_vector(10 downto 0);
	 
	 signal saidaDadoRAM, in_UlaA_Resultado, in_UlaB, saidaULA, dadoEscrita : std_logic_vector(15 downto 0);
	 
	 signal sig_flagZero, PdCIn_flagZero, sig_flagMenor, PdCIn_flagMenor : std_logic;
	 
	 
	 
	 signal sig_HEX_6CASAS : std_logic_vector(15 downto 0);

    begin
	 
	 

	 
	 BaseTempo : entity work.divisorGenerico
            generic map (divisor => 2000000)   -- divide por 50M.
            port map (clk => CLOCK_50, saida_clk => CLK_1s);
	 

		  
		  Registrador_PC :  entity work.registradorGenerico
		  generic map (larguraDados => 9)
        port map( DIN => entradaPC,
		            DOUT => saidaPC,
						ENABLE => '1',
						CLK => CLK_1s,
						RST => '0'
						
						);
			
        PC_Mais1 :  entity work.somadorGenerico_Mais1
        port map( entrada => saidaPC,
        saida => sig_PC_Mais1
		  );
		  
		  mux4x1 :  entity work.mux4x1_9Bits
        port map( entradaA_MUX => sig_PC_Mais1,
                 entradaB_MUX =>  imedJMP,
					  entradaC_MUX => imedRET,
                 entradaD_MUX =>  '0' & x"0D",
                 seletor_MUX => PdC(10 downto 9),
                 saida_MUX => entradaPC
		   );
			
			
			EndREtorno :  entity work.registradorGenerico generic map (larguraDados => 9)
        port map( DIN => sig_PC_Mais1,
		            DOUT => imedRET,
						ENABLE => PdC(8),
						CLK => CLK_1s,
						RST => '0'
						); 
			
			
			
					  
		  memoriaROM : entity work.memoriaROM
		  generic map (dataWidth => 20, addrWidth => 9)
        port map (Endereco => saidaPC,
		  Dado => INSTRUCAO
		  );
		  
		  


		mux2x1 :  entity work.mux2x1_16Bits
        port map( entradaA_MUX => saidaDadoRAM,
                 entradaB_MUX =>  imediato,
                 seletor_MUX => PdC(7),
                 saida_MUX => dadoEscrita
		   );
			
	   nomeComponente : entity work.bancoRegistradoresDiscretos   generic map (larguraDados => 32, larguraEndBancoRegs => 8)
          port map ( clk => CLK_1s,
              enderecoA => RA,
              enderecoB => RB,
              enderecoC => RD,
              dadoEscritaC => dadoEscrita,
              escreveC => PDC(6),
              saidaA => in_UlaA_Resultado,
              saidaB  => in_UlaB);
				  
						
		ULA : entity work.ULA  generic map(larguraDados => 16)
          port map (entradaA => in_UlaA_Resultado,
							entradaB =>  in_UlaB,
							saida => saidaULA,
							seletor => PdC(5 downto 4),
							flagZero => sig_flagZero,
							flagMenor => sig_flagMenor
							
			 );
			 
			 
	   flagZero :  entity work.flipFlop
        port map( DIN => sig_flagZero,
		            DOUT => PdCIn_flagZero,
						ENABLE => PdC(3),
						CLK => CLK_1s,
						RST => '0'
						); 
						
						
					 
	   flagMenor :  entity work.flipFlop
        port map( DIN => sig_flagMenor,
		            DOUT => PdCIn_flagMenor,
						ENABLE => PdC(2),
						CLK => CLK_1s,
						RST => '0'
						); 
						
		memRAM : entity work.memoriaRAM   generic map (dataWidth => 16, addrWidth => 8)
          port map (addr => ramADDR, we => PdC(0), re => PdC(1), habilita  => '1', dado_in => in_UlaA_Resultado, dado_out => saidaDadoRAM, clk => CLK_1s);
						
						
			 
			 
	  PontosDeControle :  entity work.UnidadeControle
	   port map( OpCode => OpCode,
		            PdCIn_flagZero => PdCIn_flagMenor,
						PdCIn_flagMenor => PdCIn_flagZero,
						pontosDeControle => PdC
						); 
						
			 
			 
--	   HEX_0 :  entity work.conversorHex7Seg
--        port map(dadoHex => in_UlaA_Resultado(3 downto 0),
--                 apaga =>  '0',
--                 negativo => '0',
--                 overFlow =>  '0',
--                 saida7seg => HEX0
--					  );
--					  
--		
--					  
--	   HEX_1 :  entity work.conversorHex7Seg
--        port map(dadoHex => in_UlaA_Resultado(3 downto 0),
--                 apaga =>  '0',
--                 negativo => '0',
--                 overFlow =>  '0',
--                 saida7seg => HEX1);










					  
					  
		REG_LEDR :  entity work.registradorGenerico generic map (larguraDados => 10)
        port map( DIN => in_UlaA_Resultado(9 downto 0),
		            DOUT => LEDR,
						ENABLE => PdC(0) and
									 ramADDR(7)	and
									 ramADDR(6)	and
									 ramADDR(5)	and
									 ramADDR(4)	and
									 ramADDR(3)	and
									 ramADDR(2)	and
									 ramADDR(1)	and
									 ramADDR(0),
						CLK => CLK_1s,
						RST => '0'
						); 
					  
					  
	








		REG_HEX_6CASAS :  entity work.registradorGenerico generic map (larguraDados => 16)
        port map( DIN => in_UlaA_Resultado,
		            DOUT => sig_HEX_6CASAS,
						ENABLE => PdC(0) and
									 ramADDR(7)	and
									 ramADDR(6)	and
									 ramADDR(5)	and
									 ramADDR(4)	and
									 ramADDR(3)	and
									 ramADDR(2)	and
									 ramADDR(1)	and
									 ramADDR(0),
						CLK => CLK_1s,
						RST => '0'
						); 

	
		
					  
			HEX_6CASAS : entity work.conversorHex7Seg_6casas
    port map(
        dadoHex        => sig_HEX_6CASAS,
        apaga          => '0',

        saida7segHEX0  => HEX0,   -- unidades
        saida7segHEX1  => HEX1,   -- dezenas
        saida7segHEX2  => HEX2,   -- centenas
        saida7segHEX3  => HEX3,   -- milhares
        saida7segHEX4  => HEX4,   -- dezenas de milhar
        saida7segHEX5  => HEX5    -- centenas de milhar
    );		  
					  

		--LEDR(0) <= CLK_1s;
		
		--LEDR(9 downto 6) <= entradaPC(3 downto 0);
			
		  
end architecture;