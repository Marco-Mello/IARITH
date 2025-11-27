library ieee;
use ieee.std_logic_1164.all;

entity mux32to1_32bits_3bits is
    generic (
        LARGURA_DADOS : natural := 32
    );
    port (
        seletor   : in  std_logic_vector(2 downto 0);
        entrada0  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada1  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada2  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada3  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada4  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada5  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada6  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        entrada7  : in  std_logic_vector(LARGURA_DADOS-1 downto 0);
        saida     : out std_logic_vector(LARGURA_DADOS-1 downto 0)
    );
end entity;

architecture concorrente of mux32to1_32bits_3bits is
begin

    saida <= entrada0  when seletor = "000" else
             entrada1  when seletor = "001" else
             entrada2  when seletor = "010" else
             entrada3  when seletor = "011" else
             entrada4  when seletor = "100" else
             entrada5  when seletor = "101" else
             entrada6  when seletor = "110" else
             entrada7  when seletor = "111" else
             (others => '0');  -- Valor padrão

end architecture;
