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

use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_izhikevich is
end tb_izhikevich;

architecture behavior of tb_izhikevich is

    constant clk_period : time := 10 ns;
    constant WIDTH      : integer := 12;

    signal clk          : std_logic := '0';
    signal re           : std_logic := '0';
    signal en           : std_logic := '0';
    signal rst          : std_logic := '0';
    signal sig_label    : std_logic := '0';
    signal current      : signed(WIDTH downto 0);
    signal e            : unsigned(10 downto 0);
    signal spike        : std_logic;
    signal voltage      : signed(WIDTH downto 0);

begin

    WRITE_PROCESS : process(clk)
        file result     : text open write_mode is ("results.csv");
        variable lo     : line;
    begin
        write(lo, clk);
        write(lo, ',');
        write(lo, re);
        write(lo, ',');
        write(lo, en);
        write(lo, ',');
        write(lo, rst);
        write(lo, ',');
        write(lo, sig_label);
        write(lo, ',');
        write(lo, current);
        write(lo, ',');
        write(lo, e);
        write(lo, ',');
        write(lo, spike);
        write(lo, ',');
        write(lo, voltage);
        writeline(result, lo);
    end process;

    IZH_DUT : entity work.IZH_CORE
    generic map (
        WIDTH       => WIDTH
    )
    port map (
        i_clk       => clk,
        i_re        => re,
        i_en        => en,
        i_rst       => rst,
        i_label     => sig_label,
        i_current   => current,
        o_e         => e,
        o_spike     => spike,
        o_voltage   => voltage
    );

    clk <= not clk after clk_period / 2;

    PROC_SEQUENCER : process
    begin

        -- reset
        rst         <= '1';
        wait for 10 * clk_period;

        -- initialize inputs
        rst         <= '0';
        current     <= to_signed(800, current'length);
        re          <= '1';
        en          <= '1';
        sig_label   <= '0';
        wait for 10 * clk_period;

        -- read enable
        re          <= '0';
        en          <= '1';
        wait until rising_edge(clk);

        for i in 0 to 10000 loop
            wait until rising_edge(clk);
        end loop;

        finish;
    end process;

end behavior;