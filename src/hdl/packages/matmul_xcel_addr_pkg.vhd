library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package matmul_xcel_addr_pkg is
  constant NUM_REGS     : integer := 16;

  constant ROW0_W       : integer := 0;
  constant ROW1_W       : integer := 1;
  constant ROW2_W       : integer := 2;
  constant ROW3_W       : integer := 3;
  constant ROW4_W       : integer := 4;
  constant ROW5_W       : integer := 5;
  constant ROW6_W       : integer := 6;
  constant ROW7_W       : integer := 7;
  constant OUT0_R       : integer := 8;
  constant OUT1_R       : integer := 9;
  constant OUT2_R       : integer := 10;
  constant OUT3_R       : integer := 11;
  constant OUT4_R       : integer := 12;
  constant OUT5_R       : integer := 13;
  constant OUT6_R       : integer := 14;
  constant OUT7_R       : integer := 15;
  
end package matmul_xcel_addr_pkg;