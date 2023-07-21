library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.type_pkg.all;
use matmul.component_pkg.all;

entity matmul_xcel is
  generic (
    NUM_ROWS    : integer := 2;
    NUM_COLS    : integer := 2;
    BIT_WIDTH   : integer := 8;
    C_S_AXI_ADDR_WIDTH : integer := 7;
    C_S_AXI_DATA_WIDTH : integer := 32
  );
  port (
    -- AXI4-lite interface
    S_AXI_ACLK	: in std_logic;
    S_AXI_ARESETN	: in std_logic;
    S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
    S_AXI_AWVALID	: in std_logic;
    S_AXI_AWREADY	: out std_logic;
    S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID	: in std_logic;
    S_AXI_WREADY	: out std_logic;
    S_AXI_BRESP	: out std_logic_vector(1 downto 0);
    S_AXI_BVALID	: out std_logic;
    S_AXI_BREADY	: in std_logic;
    S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
    S_AXI_ARVALID	: in std_logic;
    S_AXI_ARREADY	: out std_logic;
    S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP	: out std_logic_vector(1 downto 0);
    S_AXI_RVALID	: out std_logic;
    S_AXI_RREADY	: in std_logic
  );
end entity matmul_xcel;

architecture rtl of matmul_xcel is
  constant NUM_REGS : integer := 32;

  signal rd_regs      : std_logic_vector(NUM_REGS*BIT_WIDTH-1 downto 0);
  signal wr_regs      : std_logic_vector(NUM_REGS*BIT_WIDTH-1 downto 0);
  signal axi_rd_pulse : std_logic_vector(NUM_REGS-1 downto 0);
  signal axi_wr_pulse : std_logic_vector(NUM_REGS-1 downto 0);

  signal rst          : std_logic;

  -- signal msg_recv_msg  : bus_array(NUM_ROWS-1 downto 0)(BIT_WIDTH-1+2);
  -- signal prod_send_msg : bus_array(NUM_COLS-1 downto 0)(BIT_WIDTH-1+1);
  
begin

  rst <= not S_AXI_ARESETN;

  u_processing_element_array : processing_element_array
  generic map(
    NUM_ROWS => 2,
    NUM_COLS => 2,
    BIT_WIDTH => 8
  )
  port map(
    i_msg_recv_msg  => (others => (others => '0')), --msg_recv_msg,
    i_msg_recv_val  => (others => '1'),
    o_msg_recv_rdy  => input_ready(1 downto 0),
    o_prod_send_msg => open, --prod_send_msg,
    o_prod_send_val => output_valid(1 downto 0),
    i_prod_send_rdy => (others => '1'),
    i_clk           => S_AXI_ACLK,
    i_rst           => rst
  );
  
  u_axi_reg_slave : axi_reg_slave
  generic map(
    C_S_AXI_DATA_WIDTH => 32,
    C_S_AXI_ADDR_WIDTH => 7
  )
  port map(
    o_regs          => rd_regs,
    o_regs_wr_pulse => axi_wr_pulse,
    o_regs_rd_pulse => axi_rd_pulse,
    i_regs          => wr_regs,
    i_regs_wr       => (others => '0'),

    S_AXI_ACLK      => S_AXI_ACLK,
    S_AXI_ARESETN   => S_AXI_ARESETN,
    S_AXI_AWADDR    => S_AXI_AWADDR,
    S_AXI_AWPROT    => S_AXI_AWPROT,
    S_AXI_AWVALID   => S_AXI_AWVALID,
    S_AXI_AWREADY   => S_AXI_AWREADY,
    S_AXI_WDATA     => S_AXI_WDATA,
    S_AXI_WSTRB     => S_AXI_WSTRB,
    S_AXI_WVALID    => S_AXI_WVALID,
    S_AXI_WREADY    => S_AXI_WREADY,
    S_AXI_BRESP     => S_AXI_BRESP,
    S_AXI_BVALID    => S_AXI_BVALID,
    S_AXI_BREADY    => S_AXI_BREADY,
    S_AXI_ARADDR    => S_AXI_ARADDR,
    S_AXI_ARPROT    => S_AXI_ARPROT,
    S_AXI_ARVALID   => S_AXI_ARVALID,
    S_AXI_ARREADY   => S_AXI_ARREADY,
    S_AXI_RDATA     => S_AXI_RDATA,
    S_AXI_RRESP     => S_AXI_RRESP,
    S_AXI_RVALID    => S_AXI_RVALID,
    S_AXI_RREADY    => S_AXI_RREADY
  );
  
  
end architecture rtl;