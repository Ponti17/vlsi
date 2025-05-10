library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_module is
    Generic (
        CLK_DIVIDER_FACTOR : integer := 1000
    );
-- Top-level module for the Izhikevich neuron model
-- port are named using the constraints file
    Port (
        sysclk : in  std_logic;                     -- system clock // check for constraints file -period 125MHz/8.00 | 100MHz/10.00
        sw     : in  std_logic_vector(3 downto 0);  -- switch inputs
        btn    : in  std_logic_vector(3 downto 0);  -- button inputs
        led    : out std_logic_vector(3 downto 0)   -- LED outputs
    );
end top_module;

architecture Behavioral of top_module is

    signal internal_clk          : std_logic;  -- internal clock signal
    signal clk_divider_counter   : integer := 0;  -- clock divider counter

    signal btn_latch : std_logic_vector(3 downto 0) := (others => '0');  -- latch for button inputs 

begin

    led <= btn_latch;  -- output the latched button states to LEDs

    button_latch : process(btn)
    begin
        if btn /= "0000" then  -- check if any button is pressed
            for i in 0 to 3 loop
                if btn(i) = '1' then
                    btn_latch(i) <= not btn_latch(i);  -- toggle the latch state
                end if;
            end loop;

        end if;
    end process button_latch;

    clock_divider : process(sysclk)
    begin
        if rising_edge(sysclk) then
            if clk_divider_counter = CLK_DIVIDER_FACTOR - 1 then
                internal_clk <= not internal_clk;  -- toggle the internal clock
                clk_divider_counter <= 0;           -- reset the counter
            else
                clk_divider_counter <= clk_divider_counter + 1;  -- increment the counter
            end if;
        end if;
    end process clock_divider;



end Behavioral;