library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package matmul_xcel_addr_pkg is
  constant NUM_REGS     : integer := 17;

  constant STATUS_R     : integer := 0;
  -- STATUS_R[15:0]  Ready for new value on row corresponding to bit index
  -- STATUS_R[31:16] New, valid output on column corresponding to bit index minus 16

  constant ROW0_W       : integer := 1;
  -- constant ROW1_W       : integer := 2;
  -- constant ROW2_W       : integer := 3;
  -- constant ROW3_W       : integer := 4;
  -- ...
  -- constant ROW7_W       : integer := 8;

  constant COL0_R       : integer := 9;
  -- constant COL1_R       : integer := 10;
  -- constant COL2_R       : integer := 11;
  -- constant COL3_R       : integer := 12;
  -- ...
  -- constant COL7_R       : integer := 16;
  
end package matmul_xcel_addr_pkg;