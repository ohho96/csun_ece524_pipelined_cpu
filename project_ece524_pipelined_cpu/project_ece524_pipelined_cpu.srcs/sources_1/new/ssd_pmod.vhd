library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ssd_pmod is
    Port ( clk : in STD_LOGIC;
           hex0 : in STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
           hex1 : in STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
           j : out STD_LOGIC_VECTOR (7 downto 0):= (others => '0'));
end ssd_pmod;

architecture Behavioral of ssd_pmod is
    signal toSSD : std_logic_vector (3 downto 0) := (others => '0');
    signal sclk : std_logic := '0';
begin
    process(sclk)
    begin
        if (sclk = '0') then
            toSSD <= hex0;
        else 
            toSSD <= hex1;
        end if;
        j(7) <= sclk;
    end process;
    
    process(clk)
    --variable counter : unsigned(15 downto 0) := (others => '0');
    variable counter : integer := 0;
    begin
        
        if(rising_edge(clk))then
            if(counter = 99999)then
                counter := 0;
                sclk <= not sclk;
            else
                counter := counter + 1;
            end if;
        end if;--if(counter = "1111111111111111")then
        
    end process;
    
    SSD_handler:
    process(toSSD)
    begin
        case toSSD is
            when "0000" =>--0
                j(6 downto 0) <= "0111111";
            when "0001" =>--1
                j(6 downto 0) <= "0000110";
            when "0010" =>--2
                j(6 downto 0) <= "1011011";
            when "0011" =>--3
                j(6 downto 0) <= "1001111";
            when "0100" =>--4
                j(6 downto 0) <= "1100110";
            when "0101" =>--5
                j(6 downto 0) <= "1101101";
            when "0110" =>--6
                j(6 downto 0) <= "1111101";
            when "0111" =>--7
                j(6 downto 0) <= "0000111";
            when "1000" =>--8
                j(6 downto 0) <= "1111111";
            when "1001" =>--9
                j(6 downto 0) <= "1100111";
            when "1010" =>--A
                j(6 downto 0) <= "1110111";
            when "1011" =>--B
                j(6 downto 0) <= "1111100";
            when "1100" =>--C
                j(6 downto 0) <= "0111001";
            when "1101" =>--D
                j(6 downto 0) <= "1011110";
            when "1110" =>--E
                j(6 downto 0) <= "1111001";
            when others => --F = "1111"
                j(6 downto 0) <= "1110001";
        end case;
    end process;
end Behavioral;
