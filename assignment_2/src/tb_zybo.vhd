---------------------------------------------------------------------------------------------------
--  Aarhus University (AU, Denmark)
---------------------------------------------------------------------------------------------------
--
--  File: tb_izhikevich.vhd
--  Description: Testbench for Izhikevich neuron model.
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.finish;

entity TB_IZH_ZYBO is
end TB_IZH_ZYBO;

architecture behavior of TB_IZH_ZYBO is

    constant clk_period : time := 10 ns;
    constant WIDTH      : integer := 12;

    signal clk          : std_logic := '0';
    signal btn_0        : std_logic := '0';
    signal jc           : std_logic_vector(7 downto 0);
    signal jd           : std_logic_vector(7 downto 0 );

begin

    IZH_DUT : entity work.IZH_TOP
    port map (
        sysclk  => clk,
        btn_0   => btn_0,
        jc      => jc,
        jd      => jd
    );

    clk <= not clk after clk_period / 2;

    PROC_SEQUENCER : process
    begin

        -- reset
        btn_0 <= '0';
        wait for 10 * clk_period;

        btn_0 <= '1';
        wait for 10 * clk_period;

        btn_0 <= '0';
        wait for 10 * clk_period;

        for i in 0 to 10000 loop
            wait until rising_edge(clk);
        end loop;

        finish;
    end process;

end behavior;