library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pipelinecpu is
Port ( 
clk: in std_logic;
data_in: in std_logic_vector(31 downto 0);
reset: in std_logic;
addrin: in std_logic_vector(2 downto 0);
Output: out std_logic_vector(31 downto 0);
Addrout: out std_logic_vector(3 downto 0)
);
end pipelinecpu;

architecture Behavioral of pipelinecpu is

component ALUsixteen is
Port (
SorA: in std_logic_vector(14 downto 0);
SorB: in std_logic_vector(13 downto 0);
AluCntrl: in std_logic_vector(2 downto 0);
AluOutput: out std_logic_vector(31 downto 0)
);
end component;

signal Ain: std_logic_vector(14 downto 0);
signal Bin: std_logic_vector(13 downto 0);
signal Cntrl: std_logic_vector(2 downto 0);
signal result: std_logic_vector(31 downto 0);
signal addrmid: std_logic_vector(2 downto 0);

begin

uut:
ALUsixteen port map(
SorA => Ain,
SorB => Bin,
AluCntrl => Cntrl,
AluOutput => result
);

pipe0:
process(clk, reset)
begin
    if(reset = '1')then
        Ain <= (others => '0');
        Bin <= (others => '0');
        cntrl <= (others => '0');
        addrmid <= (others => '0');
    elsif(rising_edge(clk))then
        Ain <= data_in(28 downto 14);
        Bin <=   data_in(13 downto 0);
        Cntrl <= data_in(31 downto 29);
        addrmid <= addrin;
    end if;
end process;

pipe1:
process(clk, reset)
begin
  if(reset = '1')then
    Addrout <= '1' & "000";
    Output <= (others => '0');
  elsif(rising_edge(clk))then
    Addrout <= '1' & addrmid;
    Output <= result;
  end if;
end process;
    
end Behavioral;