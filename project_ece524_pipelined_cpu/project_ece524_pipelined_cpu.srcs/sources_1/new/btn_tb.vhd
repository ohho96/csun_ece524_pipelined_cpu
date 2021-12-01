library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity btn_tb is
    Port ( sysclk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           je : out STD_LOGIC_VECTOR (7 downto 0));
end btn_tb;

architecture Behavioral of btn_tb is
    component ssd_pmod is
        Port ( clk : in STD_LOGIC;
               hex0 : in STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
               hex1 : in STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
               j : out STD_LOGIC_VECTOR (7 downto 0):= (others => '0'));
    end component;
    
    component btn_handler is
        Generic(button_length: integer := 4;
                stable_length: integer := 10);
        Port ( clk : in STD_LOGIC;
               btn_in : in STD_LOGIC_VECTOR (button_length - 1 downto 0):= (others => '0');
               btn_out : out STD_LOGIC_VECTOR (button_length - 1 downto 0));
    end component;
    
    signal count : unsigned(7 downto 0) := (others => '0');
    signal count0, count1 : std_logic_vector(3 downto 0) := (others => '0');
    signal btns : std_logic_vector(3 downto 0) := (others => '0');
begin
    uut1:
    ssd_pmod
    port map(
        clk => sysclk,
        hex0 => count0,
        hex1 => count1,
        j => je);
        
    uut0:
    btn_handler
    generic map(
        button_length => 4,
        stable_length => 10)
    port map(
        clk => sysclk,
        btn_in => btn,
        btn_out => btns);
        
    count0 <= std_logic_vector(count(3 downto 0));
    count1 <= std_logic_vector(count(7 downto 4));
    
    process(sysclk)
    begin
        if(rising_edge(sysclk))then
            if(btns(0) = '1')then
                count <= '0' & count(7 downto 1);
            elsif(btns(1) = '1')then
                count <= count + 1;
            elsif(btns(2) = '1')then
                count <= count - 1;
            elsif(btns(3) = '1')then
                count <= count(6 downto 0) & '0' ;
            end if;
        end if;
    end process;

end Behavioral;
