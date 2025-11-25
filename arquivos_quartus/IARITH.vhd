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
		  ADDRESS : out STD_LOGIC_VECTOR(10 downto 0);
		  
		  
		  --TESTES
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out STD_LOGIC_VECTOR(6 downto 0) 
    );
	 
end entity;


architecture comportamento of IARITH is

	signal CLK_1s : std_logic;

	 signal entradaPC: std_logic_vector(9 downto 0);
	 signal saidaPC: std_logic_vector(9 downto 0);
	 signal sig_PC_Mais1: std_logic_vector(9 downto 0);
	 signal imedRET : std_logic_vector(9 downto 0);
	 
	 signal INSTRUCAO : std_logic_vector(44 downto 0);
	 
	 
	 alias OpCode : std_logic_vector(3 downto 0) is INSTRUCAO(44 downto 41);
	 alias imediato : std_logic_vector(31 downto 0) is INSTRUCAO(31 downto 0);
	 alias EndMEM : std_logic_vector(5 downto 0) is INSTRUCAO(5 downto 0);
	 alias EndPROG : std_logic_vector(9 downto 0) is INSTRUCAO(9 downto 0);
	 alias RD : std_logic_vector(2 downto 0) is INSTRUCAO(40 downto 38);
	 alias RA : std_logic_vector(2 downto 0) is INSTRUCAO(37 downto 35);
	 alias RB : std_logic_vector(2 downto 0) is INSTRUCAO(34 downto 32);
	 
	 
	 
	 signal PdC : std_logic_vector(10 downto 0);
	 
	 signal saidaDadoRAM, saidaMuxA, in_UlaA_Resultado, in_UlaB, saidaRB, saidaULA, dadoEscrita : std_logic_vector(31 downto 0);
	 
	 signal sig_flagZero, PdCIn_flagZero, sig_flagMenor, PdCIn_flagMenor : std_logic;
	 
	 
	 
	 signal sig_HEX_6CASAS : std_logic_vector(31 downto 0);

    begin
	 
	 

	 
--	 BaseTempo : entity work.divisorGenerico
--            generic map (divisor => 2000000)   -- divide por 50M.
--            port map (clk => CLOCK_50, saida_clk => CLK_1s);
	 
	 
	 	 BaseTempo : entity work.divisorGenerico
            generic map (divisor => 50000000)   -- divide por 50M.
            port map (clk => CLOCK_50, saida_clk => CLK_1s);

		  
		  Registrador_PC :  entity work.registradorGenerico
		  generic map (larguraDados => 10)
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
		  
		  mux4x1 :  entity work.mux4x1_10Bits
        port map( entradaA_MUX => sig_PC_Mais1,
                 entradaB_MUX =>  EndPROG,
					  entradaC_MUX => imedRET,
                 entradaD_MUX =>  "00" & x"0D",
                 seletor_MUX => PdC(10 downto 9),
                 saida_MUX => entradaPC
		   );
			
			
			EndREtorno :  entity work.registradorGenerico generic map (larguraDados => 10)
        port map( DIN => sig_PC_Mais1,
		            DOUT => imedRET,
						ENABLE => PdC(8),
						CLK => CLK_1s,
						RST => '0'
						); 
			
			
			
					  
		  memoriaROM : entity work.memoriaROM
		  generic map (dataWidth => 45, addrWidth => 10)
        port map (Endereco => saidaPC,
		  Dado => INSTRUCAO
		  );
		  
		  


		mux2x1_A :  entity work.mux2x1_32Bits
        port map( entradaA_MUX => saidaDadoRAM,
                 entradaB_MUX =>  imediato,
                 seletor_MUX => PdC(7),
                 saida_MUX => saidaMuxA
		   );
			
	   bancoRegistradores : entity work.bancoRegistradoresDiscretos   generic map (larguraDados => 32, larguraEndBancoRegs => 3)
          port map ( clk => CLK_1s,
              enderecoA => RA,
              enderecoB => RB,
              enderecoC => RD,
              dadoEscritaC => saidaULA,
              escreveC => PDC(6),
              saidaA => in_UlaA_Resultado,
              saidaB  => saidaRB);
				  
				  
				  mux2x1_B :  entity work.mux2x1_32Bits
        port map( entradaA_MUX => saidaMuxA,
                 entradaB_MUX =>  saidaRB,
                 seletor_MUX => PdC(5),
                 saida_MUX => in_UlaB
		   );	
				  
						
		ULA : entity work.ULA  generic map(larguraDados => 32)
          port map (entradaA => in_UlaA_Resultado,
							entradaB =>  in_UlaB,
							saida => saidaULA,
							seletor => PdC(4 downto 2),
							flagZero => sig_flagZero,
							flagMenor => sig_flagMenor
							
			 );
			 
			 
--	   flagZero :  entity work.flipFlop
--        port map( DIN => sig_flagZero,
--		            DOUT => PdCIn_flagZero,
--						ENABLE => PdC(3),
--						CLK => CLK_1s,
--						RST => '0'
--						); 
--						
						
					 
--	   flagMenor :  entity work.flipFlop
--        port map( DIN => sig_flagMenor,
--		            DOUT => PdCIn_flagMenor,
--						ENABLE => PdC(2),
--						CLK => CLK_1s,
--						RST => '0'
--						); 
						
		memRAM : entity work.memoriaRAM   generic map (dataWidth => 32, addrWidth => 6)
          port map (
						addr => EndMEM,
						we => PdC(0),
						re => PdC(1),
						habilita  => '1',
						dado_in => in_UlaA_Resultado,
						dado_out => saidaDadoRAM,
						clk => CLK_1s
						);
						
						
			 
			 
	  PontosDeControle :  entity work.UnidadeControle
	   port map( OpCode => OpCode,
		            PdCIn_flagZero => sig_flagZero,
						PdCIn_flagMenor => sig_flagMenor,
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










					  
					  
--		REG_LEDR :  entity work.registradorGenerico generic map (larguraDados => 10)
--        port map( DIN => in_UlaA_Resultado(9 downto 0),
--		            DOUT => LEDR,
--						ENABLE => PdC(0) and
--									 EndMEM(5)	and
--									 EndMEM(4)	and
--									 EndMEM(3)	and
--									 EndMEM(2)	and
--									 EndMEM(1)	and
--									 EndMEM(0),
--						CLK => CLK_1s,
--						RST => '0'
--						); 
--					  
					  
	
LEDR(9 downto 6) <= entradaPC(3 downto 0);







		REG_HEX_6CASAS :  entity work.registradorGenerico generic map (larguraDados => 32)
        port map( DIN => in_UlaA_Resultado,
		            DOUT => sig_HEX_6CASAS,
						ENABLE => PdC(0) and
									 EndMEM(5)	and
									 EndMEM(4)	and
									 EndMEM(3)	and
									 EndMEM(2)	and
									 EndMEM(1)	and
									 EndMEM(0),
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
		
		
			
		  
end architecture;