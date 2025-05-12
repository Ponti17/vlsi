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

    signal btn_rdy  : std_logic := '1';
    signal counter  : integer range 0 to 10000000 := 0;
    signal seq_en   : std_logic := '0';
    signal seq_start: std_logic := '0';
    signal spike_out: std_logic;

    signal clk      : std_logic;
    signal cnt_var  : integer := 0; 
    signal clk_cnt  : integer range 0 to 100;

begin

    -- CLK_DIVIDER : process(sysclk)
    -- begin
    --     if rising_edge(sysclk) then
    --         if (clk_cnt < 100) then
    --             clk_cnt <= clk_cnt + 1;
    --             clk     <= '1';
    --         elsif (clk_cnt < 200) then
    --             clk_cnt <= clk_cnt + 1;
    --             clk     <= '0';
    --         else
    --             clk_cnt <= 0;
    --         end if;
    --     end if;
    -- end process;
    clk <= sysclk;

    jc <= (others => clk);
    jd <= (others => spike_out);

    -- Sequencer for reset, re, en signals
    SEQUENCER : process(clk)
    begin
        if rising_edge(clk) then
            if seq_start = '1' then
                cnt_var <= 0;
                seq_en  <= '1';
            elsif seq_en = '1' then
                if cnt_var < 10 then
                    rst <= '1';
                    re  <= '0';
                    en  <= '0';
                elsif cnt_var >= 10 and cnt_var < 20 then
                    rst <= '0';
                    re  <= '1';
                    en  <= '1';
                elsif cnt_var >= 20 and cnt_var < 30 then
                    rst <= '0';
                    re  <= '0';
                    en  <= '1';
                elsif cnt_var >= 30 and cnt_var < 40 then
                    seq_en <= '0';
                end if;

                cnt_var <= cnt_var + 1;
            end if;
        end if;
    end process;

    -- Button debounce and sequencer start pulse
    BTN_SEQUENCER : process(clk)
    begin
        if rising_edge(clk) then
            seq_start <= '0'; -- Default no pulse

            if btn_0 = '1' then
                if btn_rdy = '1' then
                    seq_start <= '1'; -- Pulse to start sequence
                    btn_rdy   <= '0';
                    counter   <= 0;
                end if;
            else
                -- Button released, debounce timer
                if btn_rdy = '0' then
                    if counter < 10000000 then
                        counter <= counter + 1;
                    else
                        btn_rdy <= '1';  -- Debounce done
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Izhikevich neuron core instantiation
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
