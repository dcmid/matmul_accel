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
end entity processing_element;

architecture rtl of processing_element is
  
  constant MSG_WIDTH : integer := BIT_WIDTH + 2;  -- message contains is_weight and is_flush bits
  constant PP_MSG_WIDTH : integer := BIT_WIDTH + 1;

  component fwft_fifo is
    generic (
      BIT_WIDTH : integer := 8;
      DEPTH     : integer := 2
    );
    port (
      i_wr_en   : in  std_logic;
      i_wr_data : in  std_logic_vector(BIT_WIDTH-1 downto 0);
      o_full    : out std_logic;
  
      i_rd_en   : in  std_logic;
      o_rd_data : out std_logic_vector(BIT_WIDTH-1 downto 0);
      o_empty   : out std_logic;
  
      i_clk     : in  std_logic;
      i_rst     : in  std_logic
    );
  end component fwft_fifo;

  signal part_prod_recv             : pe_part_prod(data(BIT_WIDTH-1 downto 0));
  signal part_prod_recv_val         : std_logic;
  signal part_prod_recv_rdy         : std_logic;

  signal msg_recv                   : pe_message(data(BIT_WIDTH-1 downto 0));
  signal msg_recv_val               : std_logic;
  signal msg_recv_rdy               : std_logic;

  -- fifo signals for msg_recv interface
  signal fifo_msg_recv_wr_data           : std_logic_vector(MSG_WIDTH-1 downto 0);
  signal fifo_msg_recv_empty             : std_logic;
  signal fifo_msg_recv_wr_en             : std_logic;
  signal fifo_msg_recv_rd_data           : std_logic_vector(MSG_WIDTH-1 downto 0);
  signal fifo_msg_recv_full              : std_logic;
  signal fifo_msg_recv_rd_en             : std_logic;

  -- fifo signals for part_prod_recv interface
  signal fifo_part_prod_recv_wr_data           : std_logic_vector(PP_MSG_WIDTH-1 downto 0);
  signal fifo_part_prod_recv_empty             : std_logic;
  signal fifo_part_prod_recv_wr_en             : std_logic;
  signal fifo_part_prod_recv_rd_data           : std_logic_vector(PP_MSG_WIDTH-1 downto 0);
  signal fifo_part_prod_recv_full              : std_logic;
  signal fifo_part_prod_recv_rd_en             : std_logic;

  signal msg_send                   : pe_message(data(BIT_WIDTH-1 downto 0));
  signal part_prod_send             : pe_part_prod(data(BIT_WIDTH-1 downto 0));

  signal weight                     : std_logic_vector(BIT_WIDTH-1 downto 0);
  signal weight_full                : std_logic;
  signal activation                 : std_logic_vector(BIT_WIDTH-1 downto 0);
  signal inputs_val                 : std_logic;
  signal outputs_rdy                : std_logic;
  
begin

  proc_ff : process(i_clk)
    variable product : std_logic_vector(2*BIT_WIDTH-1 downto 0);
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        weight                    <= (others => '0');
        weight_full               <= '0';
        activation                <= (others => '0');
        o_msg_send.is_flush       <= '0';
        o_msg_send.is_weight      <= '0';
        o_msg_send.data           <= (others => '0');
        o_msg_send_val            <= '0';
        o_part_prod_send.is_flush <= '0';
        o_part_prod_send.data     <= (others => '0');
        o_part_prod_send_val      <= '0';
      else
        activation                <= (others => '0');
        o_msg_send.is_flush       <= '0';
        o_msg_send.is_weight      <= '0';
        o_msg_send.data           <= (others => '0');
        o_msg_send_val            <= '0';
        o_part_prod_send.is_flush <= '0';
        o_part_prod_send.data     <= (others => '0');
        o_part_prod_send_val      <= '0';
        
        if (msg_recv_val = '1' and msg_recv_rdy = '1') then
          if (msg_recv.is_flush = '1') then
            o_part_prod_send.is_flush <= '1';
            o_part_prod_send.data     <= (others => '0');
            o_part_prod_send_val      <= '1';

            o_msg_send.is_flush       <= '1';
            o_msg_send.is_weight      <= '0';
            o_msg_send.data           <= (others => '0');
            o_msg_send_val            <= '1';
          elsif (msg_recv.is_weight = '1') then
            if (weight_full = '0') then
              weight      <= msg_recv.data;
              weight_full <= '1';
            else
              o_msg_send      <= msg_recv;
              o_msg_send_val  <= '1';
            end if;
          else
            product                   := std_logic_vector(unsigned(weight) * unsigned(msg_recv.data) + unsigned(part_prod_recv.data));
            o_part_prod_send.data     <= product(BIT_WIDTH-1 downto 0);
            o_part_prod_send.is_flush <= '0';
            o_part_prod_send_val      <= '1';
            activation                <= msg_recv.data;
            o_msg_send                <= msg_recv;
            o_msg_send_val            <= '1';
          end if;
        end if;
      end if;
    end if;
  end process proc_ff;

  inputs_val          <= part_prod_recv_val and msg_recv_val;
  outputs_rdy         <= i_part_prod_send_rdy and i_msg_send_rdy;
  part_prod_recv_rdy  <= outputs_rdy and msg_recv_val and (not msg_recv.is_weight);
  msg_recv_rdy        <= outputs_rdy and (part_prod_recv_val or msg_recv.is_weight);



  -- Connect msg_recv interface to FIFO
  fifo_msg_recv_wr_en   <= i_msg_recv_val;
  fifo_msg_recv_wr_data <= i_msg_recv.is_flush & i_msg_recv.is_weight & i_msg_recv.data;
  o_msg_recv_rdy        <= not fifo_msg_recv_full;
  fifo_msg_recv_rd_en   <= msg_recv_rdy;
  msg_recv.is_flush     <= fifo_msg_recv_rd_data(MSG_WIDTH-1);
  msg_recv.is_weight    <= fifo_msg_recv_rd_data(MSG_WIDTH-2);
  msg_recv.data         <= fifo_msg_recv_rd_data(BIT_WIDTH-1 downto 0);
  msg_recv_val          <= not fifo_msg_recv_empty;
  msg_recv_fifo : fwft_fifo
    generic map(
      BIT_WIDTH => MSG_WIDTH,
      DEPTH     => 2
    )
    port map(
      i_wr_en                         => fifo_msg_recv_wr_en,
      i_wr_data                       => fifo_msg_recv_wr_data,
      o_full                          => fifo_msg_recv_full,

      i_rd_en                         => fifo_msg_recv_rd_en,
      o_rd_data                       => fifo_msg_recv_rd_data,
      o_empty                         => fifo_msg_recv_empty,

      i_clk                           => i_clk,
      i_rst                           => i_rst
    );

    -- Connect part_prod_recv interface to FIFO
    fifo_part_prod_recv_wr_en   <= i_part_prod_recv_val;
    fifo_part_prod_recv_wr_data <= i_part_prod_recv.is_flush & i_part_prod_recv.data;
    o_part_prod_recv_rdy        <= not fifo_part_prod_recv_full;
    fifo_part_prod_recv_rd_en   <= part_prod_recv_rdy;
    part_prod_recv.is_flush     <= fifo_part_prod_recv_rd_data(PP_MSG_WIDTH-1);
    part_prod_recv.data         <= fifo_part_prod_recv_rd_data(BIT_WIDTH-1 downto 0);
    part_prod_recv_val          <= not fifo_part_prod_recv_empty;
    part_prod_recv_fifo : fwft_fifo
      generic map(
        BIT_WIDTH => PP_MSG_WIDTH,
        DEPTH     => 2
      )
      port map(
        i_wr_en                         => fifo_part_prod_recv_wr_en,
        i_wr_data                       => fifo_part_prod_recv_wr_data,
        o_full                          => fifo_part_prod_recv_full,
  
        i_rd_en                         => fifo_part_prod_recv_rd_en,
        o_rd_data                       => fifo_part_prod_recv_rd_data,
        o_empty                         => fifo_part_prod_recv_empty,
  
        i_clk                           => i_clk,
        i_rst                           => i_rst
      );
  
end architecture rtl;