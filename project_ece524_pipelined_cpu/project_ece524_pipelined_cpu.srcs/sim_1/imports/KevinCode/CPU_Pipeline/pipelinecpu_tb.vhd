library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipelinecpu_tb is
--  Port ( );
end pipelinecpu_tb;

architecture Behavioral of pipelinecpu_tb is

component pipelinecpu is
Port ( 
clk: in std_logic;
data_in: in std_logic_vector(31 downto 0);
reset: in std_logic;
addrin: in std_logic_vector(2 downto 0);
Output: out std_logic_vector(31 downto 0);
Addrout: out std_logic_vector(3 downto 0)
);
end component;

signal clk_tb, reset_tb: std_logic;
signal data_in_tb: std_logic_vector(31 downto 0);
signal Output_tb: std_logic_vector(31 downto 0);

signal addrin_tb: std_logic_vector(2 downto 0);
signal Addrout_tb: std_logic_vector(3 downto 0);
constant clkperiod: time := 10ns;

begin

uut:
pipelinecpu port map(
clk => clk_tb,
reset => reset_tb,
data_in => data_in_tb,
addrin => addrin_tb,
Addrout => Addrout_tb,
Output => Output_tb
);

process
begin
data_in_tb <= "00000000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "00100000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "01000000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "01100000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "10000000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "10100000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "11000000000001001000000000001010";
wait for clkperiod;
data_in_tb <= "11100000000001001000000000001010";
wait for clkperiod;
end process;

process
begin
addrin_tb <= "000";
wait for clkperiod;
addrin_tb <= "001";
wait for clkperiod;
addrin_tb <= "010";
wait for clkperiod;
addrin_tb <= "011";
wait for clkperiod;
addrin_tb <= "100";
wait for clkperiod;
addrin_tb <= "101";
wait for clkperiod;
addrin_tb <= "110";
wait for clkperiod;
addrin_tb <= "111";
wait for clkperiod;
end process;

process
begin
clk_tb <= '0';
wait for clkperiod/2;
clk_tb <= '1';
wait for clkperiod/2;
end process;

process
begin
reset_tb <= '1';
wait for clkperiod;
reset_tb <= '0';
wait;
end process;

end Behavioral;
