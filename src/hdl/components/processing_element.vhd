-- Uses VHDL2008

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.type_pkg.all;

entity processing_element is
  generic(
    BIT_WIDTH             : integer := 8
  );
  port (
    i_part_prod_recv      : in  std_logic_vector(BIT_WIDTH-1 downto 0);
    i_part_prod_recv_val  : in  std_logic;
    o_part_prod_recv_rdy  : out std_logic;

    i_msg_recv            : in  std_logic_vector(BIT_WIDTH-1+1 downto 0);
    i_msg_recv_val        : in  std_logic;
    o_msg_recv_rdy        : out std_logic;

    o_part_prod_send      : out std_logic_vector(BIT_WIDTH-1 downto 0);
    o_part_prod_send_val  : out std_logic;
    i_part_prod_send_rdy  : in  std_logic;

    o_msg_send            : out std_logic_vector(BIT_WIDTH-1+1 downto 0);
    o_msg_send_val        : out std_logic;
    i_msg_send_rdy        : in  std_logic;

    i_clk                 : in std_logic;
    i_rst                 : in std_logic
  );
end entity processing_element;

architecture rtl of processing_element is
  signal part_prod_recv           : std_logic_vector(BIT_WIDTH-1 downto 0);
  signal part_prod_recv_val       : std_logic;
  signal part_prod_recv_rdy       : std_logic;

  signal msg_recv                 : pe_message(data(BIT_WIDTH-1 downto 0));
  signal msg_recv_val             : std_logic;
  signal msg_recv_rdy             : std_logic;

  signal msg_send                 : pe_message(data(BIT_WIDTH-1 downto 0));

  signal weight                   : std_logic_vector(BIT_WIDTH-1 downto 0);
  signal weight_full              : std_logic;
  signal activation               : std_logic_vector(BIT_WIDTH-1 downto 0);
  signal inputs_val               : std_logic;
  signal outputs_rdy              : std_logic;
  
begin
  part_prod_recv        <= i_part_prod_recv;
  part_prod_recv_val    <= i_part_prod_recv_val;
  o_part_prod_recv_rdy  <= part_prod_recv_rdy ;

  msg_recv.is_weight  <= i_msg_recv(BIT_WIDTH-1+1);
  msg_recv.data       <= i_msg_recv(BIT_WIDTH-1 downto 0);
  msg_recv_val        <= i_msg_recv_val;
  o_msg_recv_rdy      <= msg_recv_rdy;

  proc_ff : process(i_clk)
    variable product : std_logic_vector(2*BIT_WIDTH-1 downto 0);
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        weight                <= (others => '0');
        weight_full           <= '0';
        activation            <= (others => '0');
        o_msg_send                 <= (others => '0');
        o_msg_send_val        <= '0';
        o_part_prod_send      <= (others => '0');
        o_part_prod_send_val  <= '0';
      else
        activation            <= (others => '0');
        o_msg_send            <= (others => '0');
        o_msg_send_val        <= '0';
        o_part_prod_send      <= (others => '0');
        o_part_prod_send_val  <= '0';
        
        if (msg_recv_val = '1' and msg_recv_rdy = '1') then
          if (msg_recv.is_weight = '1') then
            if (weight_full = '0') then
              weight      <= msg_recv.data;
              weight_full <= '1';
            else
              o_msg_send      <= msg_recv.is_weight & msg_recv.data;
              o_msg_send_val  <= '1';
            end if;
          else
            product               := std_logic_vector(unsigned(weight) * unsigned(msg_recv.data) + unsigned(part_prod_recv));
            o_part_prod_send      <= product(BIT_WIDTH-1 downto 0);
            o_part_prod_send_val  <= '1';
            activation            <= msg_recv.data;
            o_msg_send            <= msg_recv.is_weight & msg_recv.data;
            o_msg_send_val        <= '1';
          end if;
        end if;
      end if;
    end if;
  end process proc_ff;

  inputs_val          <= part_prod_recv_val and msg_recv_val;
  outputs_rdy         <= i_part_prod_send_rdy and i_msg_send_rdy;
  part_prod_recv_rdy  <= outputs_rdy and msg_recv_val and (not msg_recv.is_weight);
  msg_recv_rdy        <= outputs_rdy and (part_prod_recv_val or msg_recv.is_weight);
  
end architecture rtl;