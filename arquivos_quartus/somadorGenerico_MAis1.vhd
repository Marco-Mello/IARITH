library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity somadorGenerico_Mais1 is
     port
    (
        entrada : in STD_LOGIC_VECTOR(9 downto 0);
        saida :  out STD_LOGIC_VECTOR(9 downto 0)
    );
end entity;

architecture comportamento of somadorGenerico_Mais1 is

    begin
	 
       saida <= std_logic_vector(unsigned(entrada) + to_unsigned(1, entrada'length));
		  
end architecture;