library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ssd_pmod_tb is
    Port ( sysclk : in STD_LOGIC;
           je : out STD_LOGIC_VECTOR (7 downto 0));
end ssd_pmod_tb;

architecture Behavioral of ssd_pmod_tb is
    component ssd_pmod is
        Port ( clk : in STD_LOGIC;
               hex0 : in STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
               hex1 : in STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
               j : out STD_LOGIC_VECTOR (7 downto 0):= (others => '0'));
    end component;
    
    signal count : unsigned(7 downto 0) := (others => '0');
    signal count0, count1 : std_logic_vector(3 downto 0) := (others => '0');
begin
    uut:
    ssd_pmod
    port map(
        clk => sysclk,
        hex0 => count0,
        hex1 => count1,
        j => je);
    
    count0 <= std_logic_vector(count(3 downto 0));
    count1 <= std_logic_vector(count(7 downto 4));
    
    process(sysclk)
    variable counter : integer := 0;
    begin
        if(rising_edge(sysclk))then
            
            if(counter = 59999999)then
                counter := 0;
                count <= count +1;
            else
                counter := counter +1;
            end if;
        end if;
        
        
    end process;
end Behavioral;
