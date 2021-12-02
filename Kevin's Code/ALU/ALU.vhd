library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity ALUsixteen is
Port (
SorA: in std_logic_vector(14 downto 0);
SorB: in std_logic_vector(13 downto 0);
AluCntrl: in std_logic_vector(2 downto 0);
AluOutput: out std_logic_vector(31 downto 0)
);
end ALUsixteen;

architecture Behavioral of ALUsixteen is

begin

process(AluCntrl, SorA, SorB)
--temporary signals
variable Reg3 : std_logic_vector(31 downto 0);
begin
Reg3 := "00000000000000000000000000000000";
    case AluCntrl is
        when "000" => Reg3 := "00000000000000000" & (SorA) + ('0' & SorB);
        when "001" => Reg3 := "00000000000000000" & (SorA OR ('0' & SorB));
        when "010" => Reg3 := "00000000000000000" & (SorA AND ('0' & SorB));
        when "011" => Reg3 := "00000000000000000" & (SorA AND NOT ('0' & SorB));
        when "100" => Reg3 := "00000000000000000" & (SorA OR NOT ('0' & SorB));
        when "101" => Reg3 := "00000000000000000" & (SorA NOR ('0' & SorB));
        when "110" => Reg3 := "00000000000000000" & (SorA - ('0' & SorB));
        when "111" => 
            if(SorA > SorB) then
                Reg3 := "00000000000000000000000000000001";
            else
                Reg3 := Reg3;
            end if;
        when others => NULL;
    end case;
    
AluOutput <= Reg3(31 downto 0);

end process;
          
end Behavioral;

--fixing the code to show