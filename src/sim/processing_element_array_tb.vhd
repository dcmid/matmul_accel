-- Uses VHDL2008

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.type_pkg.all;

entity processing_element_array_tb is
end entity processing_element_array_tb;

architecture test of processing_element_array_tb is
  
  component processing_element_array is
    generic (
      NUM_ROWS    : integer := 2;
      NUM_COLS    : integer := 2;
      BIT_WIDTH   : integer := 8
    );
    port (
      i_msg_recv_msg    : in  bus_array(NUM_ROWS-1 downto 0)(BIT_WIDTH-1+1 downto 0);
      i_msg_recv_val    : in  std_logic_vector(NUM_ROWS-1 downto 0);
      o_msg_recv_rdy    : out std_logic_vector(NUM_ROWS-1 downto 0);
      
      o_prod_send_msg    : out bus_array(NUM_ROWS-1 downto 0)(BIT_WIDTH-1 downto 0);
      o_prod_send_val    : out std_logic_vector(NUM_ROWS-1 downto 0);
      i_prod_send_rdy    : in  std_logic_vector(NUM_ROWS-1 downto 0);

      i_clk              : in  std_logic;
      i_rst              : in  std_logic
    );
  end component processing_element_array;

begin
  
  uut : processing_element_array
  generic map(
    NUM_ROWS  => 4,
    NUM_COLS  => 4,
    BIT_WIDTH => 10
  )
  port map(
    i_msg_recv_msg  => (others => (others => '0')),
    i_msg_recv_val  => (others => '0'),
    o_msg_recv_rdy  => open,

    o_prod_send_msg => open,
    o_prod_send_val => open,
    i_prod_send_rdy => (others => '0'),

    i_clk           => '0',
    i_rst           => '0'
  );
  
end architecture test;