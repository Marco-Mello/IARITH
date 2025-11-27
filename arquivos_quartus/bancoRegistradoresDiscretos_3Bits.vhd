library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Baseado no apêndice C (Register Files) do COD (Patterson & Hennessy).

-- Entidade que define um banco de registradores com leitura de 2 registradores e escrita em 1 registrador simultaneamente.
entity bancoRegistradoresDiscretos_3Bits is
    generic
    (
        larguraDados        : natural := 32;  -- Largura dos dados (em bits).
        larguraEndBancoRegs : natural := 5    -- Largura do endereço (2^5 = 32 posições).
    );
    port
    (
        clk        : in std_logic;  -- Sinal de clock.
        
        -- Entradas de endereços para os registradores de leitura (A e B) e de escrita (C).
        enderecoA  : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoB  : in std_logic_vector((larguraEndBancoRegs-1) downto 0);
        enderecoD  : in std_logic_vector((larguraEndBancoRegs-1) downto 0);

        -- Dado de escrita para o registrador C.
        dadoEscritaD : in std_logic_vector((larguraDados-1) downto 0);

        -- Sinal de controle de escrita. Se for '1', escreve no registrador C.
        escreveD  : in std_logic := '0';

        -- Saídas dos dados lidos dos registradores A e B.
        saidaA    : out std_logic_vector((larguraDados -1) downto 0);
        saidaB    : out std_logic_vector((larguraDados -1) downto 0)
    );
end entity bancoRegistradoresDiscretos_3Bits;

-- Arquitetura comportamental do banco de registradores.
architecture comportamento of bancoRegistradoresDiscretos_3Bits is

    -- Sinais auxiliares para lógica de bypass e seleção.
    signal bypassA, bypassB, zeroA, zeroB : std_logic;
    signal selectA, selectB : std_logic_vector(1 downto 0);
    
    -- Constante para representar o valor zero.
    constant zero : std_logic_vector(larguraDados-1 downto 0) := (others => '0');

    -- Sinais para armazenar os valores dos registradores.
    signal saidaReg0  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg1  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg2  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg3  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg4  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg5  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg6  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg7  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg8  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg9  : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg10 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg11 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg12 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg13 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg14 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg15 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg16 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg17 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg18 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg19 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg20 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg21 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg22 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg23 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg24 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg25 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg26 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg27 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg28 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg29 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg30 : std_logic_vector(larguraDados-1 downto 0);
    signal saidaReg31 : std_logic_vector(larguraDados-1 downto 0);

    -- Sinais auxiliares para a lógica ENABLE de escrita.
    signal enableReg0  : std_logic;
    signal enableReg1  : std_logic;
    signal enableReg2  : std_logic;
    signal enableReg3  : std_logic;
    signal enableReg4  : std_logic;
    signal enableReg5  : std_logic;
    signal enableReg6  : std_logic;
    signal enableReg7  : std_logic;
    signal enableReg8  : std_logic;
    signal enableReg9  : std_logic;
    signal enableReg10 : std_logic;
    signal enableReg11 : std_logic;
    signal enableReg12 : std_logic;
    signal enableReg13 : std_logic;
    signal enableReg14 : std_logic;
    signal enableReg15 : std_logic;
    signal enableReg16 : std_logic;
    signal enableReg17 : std_logic;
    signal enableReg18 : std_logic;
    signal enableReg19 : std_logic;
    signal enableReg20 : std_logic;
    signal enableReg21 : std_logic;
    signal enableReg22 : std_logic;
    signal enableReg23 : std_logic;
    signal enableReg24 : std_logic;
    signal enableReg25 : std_logic;
    signal enableReg26 : std_logic;
    signal enableReg27 : std_logic;
    signal enableReg28 : std_logic;
    signal enableReg29 : std_logic;
    signal enableReg30 : std_logic;
    signal enableReg31 : std_logic;

    -- Saídas dos multiplexadores de seleção de registradores A e B.
    signal saida_mux32to1_A, saida_mux32to1_B : std_logic_vector(larguraDados-1 downto 0);
    
    -- Sinais para o resultado da operação XOR entre o endereço C e A/B.
    signal saida_muxEndC_XOR_EndA, saida_muxEndC_XOR_EndB : std_logic_vector(larguraDados-1 downto 0);
    
    -- Sinais para armazenar o resultado da operação XOR bit a bit entre C e A/B.
    signal xnorC_A : std_logic;
    signal xnorC_B : std_logic;

    -- Sinais para verificar se o endereço A ou B é zero.
    signal checa_Se_End_A_zero : std_logic;
    signal checa_Se_End_B_zero : std_logic;

begin

    -- Lógica para habilitar a escrita nos registradores baseados no endereço C.
    enableReg0  <= '1' when (escreveD = '1' and enderecoD = "000") else '0';
    enableReg1  <= '1' when (escreveD = '1' and enderecoD = "001") else '0';
    enableReg2  <= '1' when (escreveD = '1' and enderecoD = "010") else '0';
    enableReg3  <= '1' when (escreveD = '1' and enderecoD = "011") else '0';
    enableReg4  <= '1' when (escreveD = '1' and enderecoD = "100") else '0';
    enableReg5  <= '1' when (escreveD = '1' and enderecoD = "101") else '0';
    enableReg6  <= '1' when (escreveD = '1' and enderecoD = "110") else '0';
    enableReg7  <= '1' when (escreveD = '1' and enderecoD = "111") else '0';

    -- Instanciação dos 32 registradores genéricos (Reg0 até Reg31).
    Reg0 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg0, ENABLE => escreveD and enableReg0, CLK => clk, RST => '0');

    Reg1 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg1, ENABLE => escreveD and enableReg1, CLK => clk, RST => '0');

    Reg2 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg2, ENABLE => escreveD and enableReg2, CLK => clk, RST => '0');

    Reg3 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg3, ENABLE => escreveD and enableReg3, CLK => clk, RST => '0');

    Reg4 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg4, ENABLE => escreveD and enableReg4, CLK => clk, RST => '0');

    Reg5 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg5, ENABLE => escreveD and enableReg5, CLK => clk, RST => '0');

    Reg6 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg6, ENABLE => escreveD and enableReg6, CLK => clk, RST => '0');

    Reg7 : entity work.registradorGenerico
        generic map (larguraDados => larguraDados)
        port map (DIN => dadoEscritaD, DOUT => saidaReg7, ENABLE => escreveD and enableReg7, CLK => clk, RST => '0');

    
	 mux32to1_A : entity work.mux32to1_32bits_3bits
		 generic map (LARGURA_DADOS => 32)
		 port map (
			  seletor => enderecoA,
			  saida => saida_mux32to1_A,
			  entrada0 => saidaReg0,
			  entrada1 => saidaReg1,
			  entrada2 => saidaReg2,
			  entrada3 => saidaReg3,
			  entrada4 => saidaReg4,
			  entrada5 => saidaReg5,
			  entrada6 => saidaReg6,
			  entrada7 => saidaReg7
		 );

	 xnorC_A <= '0' when 
		 ( enderecoA(0) XNOR enderecoD(0) ) AND
		 ( enderecoA(1) XNOR enderecoD(1) ) AND
		 ( enderecoA(2) XNOR enderecoD(2) ) --AND
		 --( enderecoA(3) XNOR enderecoD(3) ) AND
		 --( enderecoA(4) XNOR enderecoD(4) )
	else '1';
	
	 muxGenerico2x1_A : entity work.muxGenerico2x1
		 generic map (larguraDados => 32)
		 port map (
			  entradaA_MUX => dadoEscritaD,
			  entradaB_MUX => saida_mux32to1_A,
			  seletor_MUX => xnorC_A,
			  saida_MUX => saida_muxEndC_XOR_EndA
		 );
	
	checa_Se_End_A_zero <= '0' when (enderecoA = "000") else '1';
	
	 mux_se_A_igual_0 : entity work.muxGenerico2x1
		 generic map (larguraDados => 32)
		 port map (
			  entradaA_MUX => x"00000000",
			  entradaB_MUX => saida_muxEndC_XOR_EndA,
			  seletor_MUX => checa_Se_End_A_zero,
			  saida_MUX => saidaA
		 );
	
	 mux32to1_B : entity work.mux32to1_32bits_3bits
		 generic map (LARGURA_DADOS => 32)
		 port map (
			  seletor => enderecoB,
			  saida => saida_mux32to1_B,
			  entrada0 => saidaReg0,
			  entrada1 => saidaReg1,
			  entrada2 => saidaReg2,
			  entrada3 => saidaReg3,
			  entrada4 => saidaReg4,
			  entrada5 => saidaReg5,
			  entrada6 => saidaReg6,
			  entrada7 => saidaReg7
		 );
	
	 xnorC_B <= '0' when 
		 ( enderecoB(0) XNOR enderecoD(0) ) AND
		 ( enderecoB(1) XNOR enderecoD(1) ) AND
		 ( enderecoB(2) XNOR enderecoD(2) ) --AND
		 --( enderecoB(3) XNOR enderecoD(3) ) AND
		 --( enderecoB(4) XNOR enderecoD(4) )
	else '1';
	
	 muxGenerico2x1_B : entity work.muxGenerico2x1
		 generic map (larguraDados => 32)
		 port map (
			  entradaA_MUX => dadoEscritaD,
			  entradaB_MUX => saida_mux32to1_B,
			  seletor_MUX => xnorC_B,
			  saida_MUX => saida_muxEndC_XOR_EndB
		 );
	
	 checa_Se_End_B_zero <= '0' when (enderecoB = "000") else '1';
	
	 mux_se_B_igual_0 : entity work.muxGenerico2x1
		 generic map (larguraDados => 32)
		 port map (
			  entradaA_MUX => x"00000000",
			  entradaB_MUX => saida_muxEndC_XOR_EndB,
			  seletor_MUX => checa_Se_End_B_zero,
			  saida_MUX => saidaB
		 );

end architecture;
