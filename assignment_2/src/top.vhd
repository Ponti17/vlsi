---------------------------------------------------------------------------------------------------
--  Aarhus University (AU, Denmark)
---------------------------------------------------------------------------------------------------
--
--  File: izhikevich.vhd
--  Description: Izhikevich neuron model.
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IZH_TOP is
    port (
        sysclk      : in std_logic;
        btn_0       : in std_logic;

        jc          : out std_logic_vector(7 downto 0);
        jd          : out std_logic_vector(7 downto 0)
    );
end IZH_TOP;

architecture Behavioral of IZH_TOP is

    signal re   : std_logic;
    signal en   : std_logic;
    signal rst  : std_logic;

    signal btn_rdy : std_logic;
    signal counter : integer range 0 to 10000000;
    signal seq_en  : std_logic;
    signal spike_out : std_logic;

    signal clk : std_logic;

    signal cnt_var : integer;

begin

    clk <= sysclk;

    -- clk_out <= sysclk when (seq_en = '1') else '0';
    jc <= (sysclk & sysclk & sysclk & sysclk & sysclk & sysclk & sysclk & sysclk);
    jd <= (spike_out & spike_out & spike_out & spike_out & spike_out & spike_out & spike_out & spike_out);


    SEQUENCER : process(clk)
    begin
        if (rising_edge(clk)) then
            if (seq_en = '1') then

                if (cnt_var < 10) then
                    rst <= '1';
                    re  <= '0';
                    en  <= '0';
                elsif (cnt_var >= 10) and (cnt_var < 20) then
                    rst <= '0';
                    re  <= '1';
                    en  <= '1';
                elsif (cnt_var >= 20) and (cnt_var < 30) then
                    rst <= '0';
                    re  <= '0';
                    en  <= '1';
                elsif (cnt_var >= 30) and (cnt_var < 40) then
                    seq_en <= '0';
                end if;

                cnt_var <= cnt_var + 1;
            end if;
        end if;
    end process;

    BTN_SEQUENCER : process(clk)
    begin
        if (rising_edge(clk)) then
            if (btn_0 = '1') and (btn_rdy = '1') then
                counter <= 0;
                seq_en  <= '1';
            end if;

            if (counter < 5) then
                counter <= counter + 1;
                btn_rdy <= '0';
            else
                btn_rdy <= '1';
            end if;

        end if;
    end process;

    IZH_CORE : entity work.IZH_CORE
    generic map (
        WIDTH       => 12
    )
    port map (
        i_clk       => clk,
        i_re        => re,
        i_en        => en,
        i_rst       => rst,
        i_label     => '0',
        i_current   => to_signed(800, 13),
        o_e         => open,
        o_spike     => spike_out,
        o_voltage   => open
    );

end Behavioral;
