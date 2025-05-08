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

entity IZH_CORE is
    generic (
        WIDTH : integer                           -- Bit width of signals
    );
    port (
        i_clk       : in std_logic;
        i_re        : in std_logic;               -- read enable
        i_en        : in std_logic;               -- enable
        i_label     : in std_logic;               -- ???
        i_current   : in signed(WIDTH downto 0);  -- input current
        o_e         : out unsigned(10 downto 0);  -- whaat the fuck is 'e'
        o_spike     : out std_logic;              -- output spike
        o_voltage   : out signed(WIDTH downto 0)  -- output voltage
    );
end IZH_CORE;

architecture Behavioral of IZH_CORE is

    type signed_array is array (0 to 1) of signed(WIDTH downto 0);
    type signed_array_2 is array (0 to 1) of signed(10 downto 0);

    signal c, d, th                         : signed(WIDTH downto 0);
    signal i, i_in, v_n, v_n_1, u_n, u_n_1  : signed(WIDTH downto 0)    := (others => '0'); 
    signal v, temp1, temp2, temp3, temp4    : signed(WIDTH downto 0);
    signal e_n, e_n_1                       : signed(10 downto 0)       := (others => '0');
    signal spike                            : std_logic;
    signal i_reg, v_reg, u_reg              : signed_array              := (others => (others => '0'));
    signal e_reg                            : signed_array_2            := (others => (others => '0'));

begin

    -- Constants (Modified model; values multiplied by 10 due to relative error)
    -- Example models:
    -- Regular Spiking (RS): c <= to_signed(-650, width+1); d <= to_signed(80, width+1);
    -- Chattering (CH):      c <= to_signed(-550, width+1); d <= to_signed(35, width+1);
    -- Fast Spiking (FS):    c <= to_signed(-650, width+1); d <= to_signed(20, width+1);
    c       <= to_signed(-650, WIDTH+1);
    d       <= to_signed(20, WIDTH+1);
    th      <= to_signed(300, WIDTH+1);
    i_in    <= i_current;

    -- i_current register
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_en = '1') then
                i_reg(0) <= resize(i_in, i_reg(0)'length);
                i_reg(1) <= i_reg(0);
                i        <= i_reg(1);
            end if;
        end if;
    end process;

    -- v register
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_en = '1') then
                v_reg(0) <= v_n_1;
                v_reg(1) <= v_reg(0);
                v_n      <= v_reg(1);
            end if;
        end if;
    end process;

    -- u register
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_en = '1') then
                u_reg(0) <= u_n_1;
                u_reg(1) <= u_reg(0);
                u_n      <= u_reg(1);
            end if;
        end if;
    end process;

    -- v + 1 pipeline
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_en = '1') then
                v <= resize(
                    shift_right(v_n * v_n, 8) +
                    shift_left(v_n, 2) +
                    shift_left(v_n, 1) +
                    to_signed(1400, WIDTH+1) - u_n + i,
                    v'length
                );
            end if;
        end if;
    end process;

    -- v conditions
    spike <= '1' when v > th else '0';

    v_n_1 <= c when i_re  = '1' else
             v when spike = '0' else
             c when spike = '1' else
             (others => '0');

    o_spike <= spike;

    -- u + 1 pipeline
    temp1 <= shift_right(v_n + e_n, 3) - u_n;
    temp2 <= shift_right(temp1, 3);
    temp3 <= u_n + temp2;
    temp4 <= temp3 + d;

    -- u conditions
    u_n_1 <= temp3 when i_re  = '1' else
             temp3 when spike = '0' else
             temp4 when spike = '1' else
             (others => '0');

    o_voltage <= v;

    -- e param
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_en = '1') then
                e_reg(0) <= e_n_1;
                e_reg(1) <= e_reg(0);
                e_n      <= e_reg(1);
            end if;
        end if;
    end process;

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_re = '1') then
                e_n_1 <= to_signed(0, e_n_1'length);
            elsif (i_label = '0' and spike = '1') then
                if (e_n_1 < to_signed(800, e_n_1'length)) then
                    e_n_1 <= e_n_1 + to_signed(1, e_n_1'length);
                end if;
            end if;
        end if;
    end process;

    o_e <= unsigned(e_n_1);

end Behavioral;
