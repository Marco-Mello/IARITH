library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conversorHex7Seg_6casas is
    port
    (
        dadoHex : in  std_logic_vector(31 downto 0);
        apaga   : in  std_logic := '0';

        saida7segHEX0 : out std_logic_vector(6 downto 0);
        saida7segHEX1 : out std_logic_vector(6 downto 0);
        saida7segHEX2 : out std_logic_vector(6 downto 0);
        saida7segHEX3 : out std_logic_vector(6 downto 0);
        saida7segHEX4 : out std_logic_vector(6 downto 0);
        saida7segHEX5 : out std_logic_vector(6 downto 0)
    );
end entity;

architecture comportamento of conversorHex7Seg_6casas is

    --------------------------------------------------------------
    -- função para converter um dígito decimal (0-9) em 7 segmentos
    --------------------------------------------------------------
    function dec_to_7seg(d : integer) return std_logic_vector is
    begin
        case d is
            when 0 => return "1000000";
            when 1 => return "1111001";
            when 2 => return "0100100";
            when 3 => return "0110000";
            when 4 => return "0011001";
            when 5 => return "0010010";
            when 6 => return "0000010";
            when 7 => return "1111000";
            when 8 => return "0000000";
            when 9 => return "0010000";
            when others =>
                return "1111111"; -- apaga
        end case;
    end function;

    signal numero : integer range 0 to 65535;

    -- dígitos individuais
    signal u, d, c, m, dm, cm : integer range 0 to 9;

begin

    -- converte dadoHex (16 bits) para inteiro
    numero <= to_integer(unsigned(dadoHex));

    process(numero)
        variable temp : integer;
    begin
        temp := numero;

        -- extração dos dígitos decimais
        u  <= temp mod 10;       temp := temp / 10;
        d  <= temp mod 10;       temp := temp / 10;
        c  <= temp mod 10;       temp := temp / 10;
        m  <= temp mod 10;       temp := temp / 10;
        dm <= temp mod 10;       temp := temp / 10;
        cm <= temp mod 10;
    end process;

    -- aplica apaga OU mostra número
    saida7segHEX0 <= "1111111" when apaga='1' else dec_to_7seg(u);
    saida7segHEX1 <= "1111111" when apaga='1' else dec_to_7seg(d);
    saida7segHEX2 <= "1111111" when apaga='1' else dec_to_7seg(c);
    saida7segHEX3 <= "1111111" when apaga='1' else dec_to_7seg(m);
    saida7segHEX4 <= "1111111" when apaga='1' else dec_to_7seg(dm);
    saida7segHEX5 <= "1111111" when apaga='1' else dec_to_7seg(cm);

end architecture;