-- Uses VHDL2008

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.type_pkg.all;

entity processing_element_array is
  generic (
    NUM_ROWS    : integer := 2;
    NUM_COLS    : integer := 2;
    BIT_WIDTH   : integer := 8
  );
  port (
    i_msg_recv_msg    : in  std_logic_vector(NUM_ROWS*(BIT_WIDTH+2)-1 downto 0);
    -- i_msg_recv_msg    : in  bus_array(NUM_ROWS-1 downto 0)(BIT_WIDTH-1+2 downto 0);
    i_msg_recv_val    : in  std_logic_vector(NUM_ROWS-1 downto 0);
    o_msg_recv_rdy    : out std_logic_vector(NUM_ROWS-1 downto 0);
   
    o_prod_send_msg    : out std_logic_vector(NUM_COLS*(BIT_WIDTH+1)-1 downto 0);
    -- o_prod_send_msg    : out bus_array(NUM_COLS-1 downto 0)(BIT_WIDTH-1+1 downto 0);
    o_prod_send_val    : out std_logic_vector(NUM_COLS-1 downto 0);
    i_prod_send_rdy    : in  std_logic_vector(NUM_COLS-1 downto 0);

    i_clk              : in  std_logic;
    i_rst              : in  std_logic
  );
end entity processing_element_array;

architecture rtl of processing_element_array is

  constant MSG_WIDTH : integer := BIT_WIDTH + 2;  -- message contains is_weight and is_flush bits
  constant PP_MSG_WIDTH : integer := BIT_WIDTH + 1;

  component processing_element is
    generic(
      BIT_WIDTH             : integer := 8
    );
    port (
      i_part_prod_recv      : in  pe_part_prod(data(BIT_WIDTH-1 downto 0));
      i_part_prod_recv_val  : in  std_logic;
      o_part_prod_recv_rdy  : out std_logic;
  
      i_msg_recv            : in  pe_message(data(BIT_WIDTH-1 downto 0));
      i_msg_recv_val        : in  std_logic;
      o_msg_recv_rdy        : out std_logic;
  
      o_part_prod_send      : out pe_part_prod(data(BIT_WIDTH-1 downto 0));
      o_part_prod_send_val  : out std_logic;
      i_part_prod_send_rdy  : in  std_logic;
  
      o_msg_send            : out pe_message(data(BIT_WIDTH-1 downto 0));
      o_msg_send_val        : out std_logic;
      i_msg_send_rdy        : in  std_logic;
  
      i_clk                 : in std_logic;
      i_rst                 : in std_logic
    );
  end component processing_element;

  signal  part_prod_recv      : array_2d_slv(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0)(PP_MSG_WIDTH-1 downto 0);
  signal  part_prod_recv_val  : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);
  signal  part_prod_recv_rdy  : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);

  signal  msg_recv            : array_2d_slv(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0)(MSG_WIDTH-1 downto 0);
  signal  msg_recv_val        : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);
  signal  msg_recv_rdy        : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);

  signal  part_prod_send      : array_2d_slv(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0)(PP_MSG_WIDTH-1 downto 0);
  signal  part_prod_send_val  : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);
  signal  part_prod_send_rdy  : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);

  signal  msg_send            : array_2d_slv(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0)(MSG_WIDTH-1 downto 0);
  signal  msg_send_val        : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);
  signal  msg_send_rdy        : array_2d_sl(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0);
  
begin
  component_gen : for i in 0 to NUM_ROWS-1 generate
    nest_component_gen : for j in 0 to NUM_COLS-1 generate
      u_processing_element_i : processing_element
        generic map(
          BIT_WIDTH     => BIT_WIDTH
        )
        port map(
          i_part_prod_recv.is_flush   =>  part_prod_recv(i,j)(PP_MSG_WIDTH-1),
          i_part_prod_recv.data       =>  part_prod_recv(i,j)(BIT_WIDTH-1 downto 0),
          i_part_prod_recv_val        =>  part_prod_recv_val(i,j),
          o_part_prod_recv_rdy        =>  part_prod_recv_rdy(i,j),

          i_msg_recv.is_flush         =>  msg_recv(i,j)(MSG_WIDTH-1),
          i_msg_recv.is_weight        =>  msg_recv(i,j)(MSG_WIDTH-2),
          i_msg_recv.data             =>  msg_recv(i,j)(BIT_WIDTH-1 downto 0),
          i_msg_recv_val              =>  msg_recv_val(i,j),
          o_msg_recv_rdy              =>  msg_recv_rdy(i,j),

          o_part_prod_send.is_flush   =>  part_prod_send(i,j)(PP_MSG_WIDTH-1),
          o_part_prod_send.data       =>  part_prod_send(i,j)(BIT_WIDTH-1 downto 0),
          o_part_prod_send_val        =>  part_prod_send_val(i,j),
          i_part_prod_send_rdy        =>  part_prod_send_rdy(i,j),

          o_msg_send.is_flush         =>  msg_send(i,j)(MSG_WIDTH-1),
          o_msg_send.is_weight        =>  msg_send(i,j)(MSG_WIDTH-2),
          o_msg_send.data             =>  msg_send(i,j)(BIT_WIDTH-1 downto 0),
          o_msg_send_val              =>  msg_send_val(i,j),
          i_msg_send_rdy              =>  msg_send_rdy(i,j),

          i_clk                       => i_clk,
          i_rst                       => i_rst
        );
      end generate nest_component_gen;
  end generate component_gen;

  array_interconnect_gen : for i in 0 to NUM_ROWS-1 generate
    nest_interconnect_gen : for j in 0 to NUM_COLS-1 generate
      -- connect partial product signals
      ppif : if (i = 0) generate
        part_prod_recv(i,j)     <= (others => '0');
        part_prod_recv_val(i,j) <= '1';
      else generate
        part_prod_recv(i,j)       <= part_prod_send(i-1,j);
        part_prod_recv_val(i,j)   <= part_prod_send_val(i-1,j);
        part_prod_send_rdy(i-1,j) <=  part_prod_recv_rdy(i,j);
      end generate ppif;
      -- connect last row to ports
      lastrow : if (i = NUM_ROWS-1) generate
        o_prod_send_msg((j+1)*PP_MSG_WIDTH-1 downto j*PP_MSG_WIDTH) <=  part_prod_send(i,j);
        o_prod_send_val(j)        <=  part_prod_send_val(i,j);
        part_prod_send_rdy(i,j)   <=  i_prod_send_rdy(j);
      end generate lastrow;

      -- connect message signals
      msgif : if (j = 0) generate
        msg_recv(i,j)     <= i_msg_recv_msg((i+1)*MSG_WIDTH-1 downto i*MSG_WIDTH);
        msg_recv_val(i,j) <= i_msg_recv_val(i);
        o_msg_recv_rdy(i) <= msg_recv_rdy(i,j);
      else generate
        msg_recv(i,j)       <= msg_send(i,j-1);
        msg_recv_val(i,j)   <= msg_send_val(i,j-1);
        msg_send_rdy(i,j-1) <= msg_recv_rdy(i,j);
      end generate msgif;
      -- tie last column rdy high to avoid waiting on non-existant processing elements
      lastcol : if (j = NUM_COLS-1) generate
        msg_send_rdy(i,j)   <= '1';
      end generate lastcol;

    end generate nest_interconnect_gen;
  end generate array_interconnect_gen;
  
  
end architecture rtl;