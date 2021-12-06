library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity ALUsixteen_tb is
--  Port ( );
end ALUsixteen_tb;

architecture Behavioral of ALUsixteen_tb is

component ALUsixteen is
Port (
SorA: in std_logic_vector(14 downto 0);
SorB: in std_logic_vector(13 downto 0);
AluCntrl: in std_logic_vector(2 downto 0);
AluOutput: out std_logic_vector(31 downto 0)
);
end component;

--Inputs
signal SorA_tb: std_logic_vector(14 downto 0) := (others => '0');
signal SorB_tb: std_logic_vector(13 downto 0) := (others => '0');
signal AluCntrl_tb: std_logic_vector(2 downto 0) := (others => '0');

--Output
signal AluOutput_tb: std_logic_vector(31 downto 0) := (others => '0');

constant clk_period: time := 10ns;

begin

uut: ALUsixteen port map(
SorA => SorA_tb,
SorB => SorB_tb,
AluCntrl => AluCntrl_tb,
AluOutput => AluOutput_tb
);

Stim_proc:
process
begin

SorA_tb <= "000000000010010";
SorB_tb <= "00000000001010";

AluCntrl_tb <= "000";
wait for clk_period;
AluCntrl_tb <= "001";
wait for clk_period;
AluCntrl_tb <= "010";
wait for clk_period;
AluCntrl_tb <= "011";
wait for clk_period;
AluCntrl_tb <= "100";
wait for clk_period;
AluCntrl_tb <= "101";
wait for clk_period;
AluCntrl_tb <= "110";
wait for clk_period;
AluCntrl_tb <= "111";
wait for clk_period;
wait;
end process;

end Behavioral;
