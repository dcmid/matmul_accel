library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package matmul_xcel_addr_pkg is
  constant NUM_REGS     : integer := 16;

  constant INPUT_READY_R  : integer := 0;
  constant OUTPUT_VALID_R : integer := 1;
  constant ROW1_W         : integer := 2;
  constant ROW2_W         : integer := 3;
  constant ROW3_W         : integer := 4;
  constant OUT1_R         : integer := 5;
  constant OUT2_R         : integer := 6;
  constant OUT3_R         : integer := 7;
  
  
end package matmul_xcel_addr_pkg;