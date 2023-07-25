library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.type_pkg.all;
use matmul.component_pkg.all;
use matmul.matmul_xcel_addr_pkg.all;

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
  constant NUM_REGS     : integer := 32;
  constant MSG_WIDTH    : integer := BIT_WIDTH + 2;
  constant PP_MSG_WIDTH : integer := BIT_WIDTH + 1;

  signal rd_regs      : std_logic_vector(NUM_REGS*C_S_AXI_DATA_WIDTH-1 downto 0);
  signal wr_regs      : std_logic_vector(NUM_REGS*C_S_AXI_DATA_WIDTH-1 downto 0);
  signal axi_rd_pulse : std_logic_vector(NUM_REGS-1 downto 0);
  signal axi_wr_pulse : std_logic_vector(NUM_REGS-1 downto 0);
  signal regs_wr_val  : std_logic_vector(NUM_REGS-1 downto 0);
  signal regs_wr_rdy  : std_logic_vector(NUM_REGS-1 downto 0);

  signal rst          : std_logic;
  
  signal msg_recv_msg  : std_logic_vector(NUM_ROWS*MSG_WIDTH-1 downto 0);
  signal msg_recv_val  : std_logic_vector(NUM_ROWS-1 downto 0);
  signal msg_recv_rdy  : std_logic_vector(NUM_ROWS-1 downto 0);
  signal prod_send_msg : std_logic_vector(NUM_COLS*PP_MSG_WIDTH-1 downto 0);
  signal prod_send_val : std_logic_vector(NUM_COLS-1 downto 0);
  signal prod_send_rdy : std_logic_vector(NUM_COLS-1 downto 0);

  component ila_0 is
    port(
      probe0 : in std_logic_vector(3 downto 0);
      probe1 : in std_logic_vector(35 downto 0);

      probe2 : in std_logic_vector(31 downto 0);
      probe3 : in std_logic_vector(0 downto 0);
      probe4 : in std_logic_vector(0 downto 0);

      clk : in std_logic
    );
  end component ila_0;
  -- component ila_0 is
  --   port(
  --     probe0 : std_logic_vector(19 downto 0);
  --     probe1 : std_logic_vector(1 downto 0);
  --     probe2 : std_logic_vector(1 downto 0);
  --     probe3 : std_logic_vector(17 downto 0);
  --     probe4 : std_logic_vector(1 downto 0);
  --     probe5 : std_logic_vector(1 downto 0);
  --     probe6 : std_logic_vector(127 downto 0);
  --     probe7 : std_logic_vector(31 downto 0);

  --     clk  : std_logic
  --   );
  -- end component ila_0;
  
begin

  u_ila_0 : ila_0
    port map(
      probe0 => prod_send_val,
      probe1 => prod_send_msg,
      probe2 => wr_regs(31 downto 0),
      probe3(0) => regs_wr_val(0),
      probe4(0) => rst,

      clk => S_AXI_ACLK
    );

  
  -- u_ila_0 : ila_0
  --   port map(
  --     probe0 => msg_recv_msg,
  --     probe1 => msg_recv_val,
  --     probe2 => msg_recv_rdy,
  --     probe3 => prod_send_msg,
  --     probe4 => prod_send_val,
  --     probe5 => prod_send_rdy,

  --     probe6 => rd_regs(127 downto 0),
  --     probe7 => axi_wr_pulse,

  --     clk   => S_AXI_ACLK
  --   );

  rst <= not S_AXI_ARESETN;

  -- gen_msg: for i in 0 to NUM_ROWS-1 generate
  --   msg_recv_msg((i+1)*MSG_WIDTH-1 downto i*MSG_WIDTH) <= rd_regs((ROW0_W+i)*C_S_AXI_DATA_WIDTH + MSG_WIDTH - 1 downto (ROW0_W+i)*C_S_AXI_DATA_WIDTH);
  --   msg_recv_val(i) <= axi_wr_pulse(ROW0_W+i);  -- TODO: probably need to latch this until we get a rdy
  -- end generate gen_msg;

  -- gen_pp_msg: for i in 0 to NUM_COLS-1 generate
  --   -- connect unused upper bits of reg interface to '0'
  --   wr_regs ((COL0_R+i+1)*C_S_AXI_DATA_WIDTH - 1 downto (COL0_R+i)*C_S_AXI_DATA_WIDTH + PP_MSG_WIDTH ) <= (others => '0');
  --   -- connect incoming message to lowest bits of reg interface
  --   wr_regs ((COL0_R+i)*C_S_AXI_DATA_WIDTH + PP_MSG_WIDTH-1 downto (COL0_R+i)*C_S_AXI_DATA_WIDTH) <= prod_send_msg((i+1)*PP_MSG_WIDTH - 1 downto i*PP_MSG_WIDTH);
  --   regs_wr_val(COL0_R+i) <= prod_send_val(i);
  --   prod_send_rdy(i) <= regs_wr_rdy(COL0_R+i);
  -- end generate gen_pp_msg;

  -- -- connect unused bits of wr_regs and regs_wr_val to '0'
  -- gen_wr_regs_nc : for i in 0 to NUM_REGS-1 generate
  --   gen_if_wr_reg_nc : if (i < COL0_R or i >= COL0_R+NUM_COLS) generate
  --     wr_regs((i+1)*C_S_AXI_DATA_WIDTH-1 downto i*C_S_AXI_DATA_WIDTH) <= (others => '0');
  --     regs_wr_val(i) <= '0'; 
  --   end generate gen_if_wr_reg_nc;
  -- end generate gen_wr_regs_nc;

  u_processing_element_array : processing_element_array
  generic map(
    NUM_ROWS => NUM_ROWS,
    NUM_COLS => NUM_COLS,
    BIT_WIDTH => BIT_WIDTH
  )
  port map(
    i_msg_recv_msg  => msg_recv_msg,
    i_msg_recv_val  => msg_recv_val,
    o_msg_recv_rdy  => msg_recv_rdy,
    o_prod_send_msg => prod_send_msg,
    o_prod_send_val => prod_send_val,
    i_prod_send_rdy => prod_send_rdy,
    i_clk           => S_AXI_ACLK,
    i_rst           => rst
  );

  u_matmul_xcel_regs : matmul_xcel_regs
  generic map(
    NUM_REGS          => NUM_REGS,
    AXI_DATA_WIDTH    => C_S_AXI_DATA_WIDTH,
    AXI_ADDR_WIDTH    => C_S_AXI_ADDR_WIDTH,
    MATMUL_NUM_ROWS   => NUM_ROWS,
    MATMUL_NUM_COLS   => NUM_COLS,
    MATMUL_BIT_WIDTH  => BIT_WIDTH
  )
  port map(
    i_regs_recv       => rd_regs,
    i_axi_wr_pulse    => axi_wr_pulse,

    o_regs_send       => wr_regs,
    o_regs_send_val   => regs_wr_val,
    i_axi_rd_pulse    => axi_rd_pulse,

    o_row_msg         => msg_recv_msg,
    o_row_msg_val     => msg_recv_val,
    i_row_msg_rdy     => msg_recv_rdy,

    i_col_msg         => prod_send_msg,
    i_col_msg_val     => prod_send_val,
    o_col_msg_rdy     => prod_send_rdy,

    i_clk             => S_AXI_ACLK,
    i_rst             => rst
  );
  
  u_axi_reg_slave : axi_reg_slave
  generic map(
    NUM_REGS => NUM_REGS,
    AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
    AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
  )
  port map(
    o_regs          => rd_regs,
    o_axi_wr_pulse  => axi_wr_pulse,
    o_axi_rd_pulse  => axi_rd_pulse,
    i_regs          => wr_regs,
    i_regs_wr_val   => regs_wr_val,
    o_regs_wr_rdy   => regs_wr_rdy,

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