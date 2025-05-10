library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_module is
-- Top-level module for the Izhikevich neuron model
-- port are named using the constraints file
    Port (
        sysclk       : in std_logic;               -- system clock
        sw          : in std_logic_vector(3 downto 0);    -- switch inputs
        btn         : in std_logic_vector(3 downto 0);    -- button inputs
        led         : out std_logic_vector(3 downto 0)   -- LED outputs
    );
end top_module;

architecture Behavioral of top_module is

begin

end Behavioral;