-- Uses VHDL2008

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package type_pkg is
  type bus_array is array(natural range <>) of std_logic_vector;
  -- type bus_array is array(1 downto 0) of std_logic_vector(7 downto 0);
  type array_2d_slv is array(natural range <>, natural range <>) of std_logic_vector;
  type array_2d_sl is array(natural range <>, natural range <>) of std_logic;
  type pe_message is record
    data      : std_logic_vector;
    is_weight : std_logic;
    is_flush  : std_logic;
  end record pe_message;

  type pe_part_prod is record
    data      : std_logic_vector;
    is_flush  : std_logic;
  end record pe_part_prod;
end package type_pkg;
