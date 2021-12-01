library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_handler is
    Generic(button_length: integer := 4;
            stable_length: integer := 10);
    Port ( clk : in STD_LOGIC;
           btn_in : in STD_LOGIC_VECTOR (button_length - 1 downto 0):= (others => '0');
           btn_out : out STD_LOGIC_VECTOR (button_length - 1 downto 0));
end btn_handler;

architecture Behavioral of btn_handler is
    type btn_stable is array (stable_length - 1 downto 0) of std_logic_vector(button_length downto 0);
    signal btns : btn_stable := (others=>(others=>'0'));
    signal btn_p0, btn_p1 : std_logic_vector (button_length-1 downto 0);
begin
    process(clk)
    begin
        if(rising_edge(clk))then
           for i in 0 to button_length - 1 loop
              btns(0)(i) <= btn_in(i);
              for j in 1 to stable_length - 1 loop
                  btns(j)(i) <= btns(j-1)(i);
               end loop;
               btn_out(i) <= (not btn_p1(i)) and btn_p0(i);
               btn_p0(i) <= btns(stable_length -1)(i) and btns(stable_length/2)(i) and btns(0)(i);
               btn_p1(i) <= btn_p0(i);
           end loop;
        end if;
    end process;
    
    

end Behavioral;
