library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FinalPipelineCPU is
    Port ( sysclk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0);
           led6_b : out std_logic;
           je : out STD_LOGIC_VECTOR (7 downto 0);
           jc : out STD_LOGIC_VECTOR (7 downto 0));
end FinalPipelineCPU;

architecture Behavioral of FinalPipelineCPU is
    
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
    
    COMPONENT blk_mem_gen_0
      PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;
    
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
    
    signal clk, done, rst, MLb: std_logic:= '0';
    signal hex0, hex1, hex2, hex3 : std_logic_vector(3 downto 0) := (others => '0');
    signal btns, addra, addrb, addrOut: std_logic_vector(3 downto 0) := (others => '0');
    signal always0, web : std_logic_vector(0 downto 0) := "0";
    signal addrCount : unsigned(2 downto 0) := "000";
    signal dina, douta, dinb, doutb : std_logic_vector( 31 downto 0) := (others => '0');
    signal addrt : unsigned(3 downto 0);
    signal count2 : unsigned(1 downto 0) := "00";
begin

    led <= sw;
    led6_b <= done;
    rst <= not sw(3);
    
    clock_control:
    process(sysclk)
        variable slow, hclk : std_logic := '0';
        variable counter : integer := 0;
        variable numCount: integer := 59999999;
    begin
        if(sw(3) = '0')then--reset
            counter := 0;
            slow := '0';
        elsif(rising_edge(sysclk))then
            if (sw(2) = '0')then --sysclock
                hclk := not hclk;
                clk <= hclk;
            else --slow clock
                if(counter = numCount)then
                    counter := 0;
                    slow := not slow;
                elsif(counter = numCount/2)then
                    slow := not slow;
                    counter := counter +1;
                else
                    counter := counter +1;
                end if;
                clk <= slow;
            end if;
        end if;
    end process;
    
    ProgramCounter:
    process(clk, sw(3))
    begin
        if(sw(3) ='0')then
            addrCount <= "000";
            done <= '0';
            count2 <= "00";
        else
            if(rising_edge(clk))then
                if(addrCount < "111")then
                    addrCount <= addrCount +1;
                elsif(addrCount = "111")then
                    if(count2 = "10")then
                        done <= '1';
                    else
                        count2 <= count2 + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    bram_cpu : 
    blk_mem_gen_0
      PORT MAP (
        clka => sysclk,
        wea => always0,
        addra => addra,
        dina => dina,
        douta => douta,
        clkb => sysclk,
        web => web,
        addrb => addrb,
        dinb => dinb,
        doutb => doutb
      );
    
    MostLessBit:
    process(btns)
    begin
        if(btns(3) = '1')then
            MLb <= '1';
        elsif(btns(0) = '1')then
            MLb <= '0';
        end if;
    end process;
    
    val_control:
    process(sysclk, btns)
    begin
        if(rising_edge(sysclk))then
            if(done = '0')then--before done
                web <= "1";
                addra <= '0' & std_logic_vector(addrCount);
                addrb <= addrOut;
                if(sw(1) = '1')then --show address
                    hex0 <= addra; --input side
                    hex1 <= "0000";
                    hex2 <= "0000";
                    hex3 <= addrb; --ouput side
                else --show value
                    if(sw(0) = '1')then--input
                        if(MLb = '0')then
                            hex0 <= douta(3 downto 0);
                            hex1 <= douta(7 downto 4);
                            hex2 <= douta(11 downto 8);
                            hex3 <= douta(15 downto 12);
                        else
                            hex0 <= douta(19 downto 16);
                            hex1 <= douta(23 downto 20);
                            hex2 <= douta(27 downto 24);
                            hex3 <= douta(31 downto 28);
                        end if;
                    else--output
                        if(MLb = '0')then
                            hex0 <= dinb(3 downto 0);
                            hex1 <= dinb(7 downto 4);
                            hex2 <= dinb(11 downto 8);
                            hex3 <= dinb(15 downto 12);
                        else
                            hex0 <= dinb(19 downto 16);
                            hex1 <= dinb(23 downto 20);
                            hex2 <= dinb(27 downto 24);
                            hex3 <= dinb(31 downto 28);
                        end if;
                    end if;
                end if;
            else--after done
                web <= "0";
                addra <= std_logic_vector(addrt);
                if(sw(1) = '1')then --show address
                    hex0 <= addra;
                    hex1 <= "0000";
                    hex2 <= "0000";
                    hex3 <= "0000";
                else --show value
                    if(MLb = '0')then
                        hex0 <= douta(3 downto 0);
                        hex1 <= douta(7 downto 4);
                        hex2 <= douta(11 downto 8);
                        hex3 <= douta(15 downto 12);
                    else
                        hex0 <= douta(19 downto 16);
                        hex1 <= douta(23 downto 20);
                        hex2 <= douta(27 downto 24);
                        hex3 <= douta(31 downto 28);
                    end if;
                end if;
            end if;
        end if;
        
    end process;
    
    process(sysclk)
    begin
        if(rising_edge(sysclk))then
            if(btns(1) = '1')then
                addrt <= addrt + 1;
            elsif(btns(2) = '1')then
                addrt <= addrt - 1;
            end if;
        end if;
    end process;
    
    main_uut:
    pipelinecpu
    port map ( 
        clk => clk,
        data_in => douta,
        reset => rst,
        addrin => addra(2 downto 0),
        Output => dinb,
        Addrout => addrOut );
    
    ssd0:    
    ssd_pmod
    port map(
        clk => sysclk,
        hex0 => hex0,
        hex1 => hex1,
        j => jc);
        
    ssd1:    
    ssd_pmod
    port map(
        clk => sysclk,
        hex0 => hex2,
        hex1 => hex3,
        j => je);
    
    btn_inout:
    btn_handler
    generic map(
        button_length => 4,
        stable_length => 10)
    port map(
        clk => sysclk,
        btn_in => btn,
        btn_out => btns);
    
end Behavioral;
