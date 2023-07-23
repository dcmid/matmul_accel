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

  type idx_arr_t is array(natural range <>) of integer;
  function idx_arr_to_slv (
    idx_arr : in idx_arr_t )
    return std_logic_vector is
    variable slv : std_logic_vector(NUM_REGS-1 downto 0);
    variable idx : integer;
  begin
    slv := (others => '0');
    for i in idx_arr'range loop
      idx := idx_arr(i);
      slv(idx) := '1';
    end loop;
    return slv;
  end function idx_arr_to_slv;

  constant RD_ONLY_IDX  : idx_arr_t(0 to 1) := (OUT1_R, OUT2_R);
  constant RD_ONLY      : std_logic_vector(NUM_REGS-1 downto 0) := idx_arr_to_slv(RD_ONLY_IDX);

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
  
begin

  rst <= not S_AXI_ARESETN;

  gen_msg: for i in 0 to NUM_ROWS-1 generate
    msg_recv_msg((i+1)*MSG_WIDTH-1 downto i*MSG_WIDTH) <= rd_regs((ROW0_W+i)*C_S_AXI_DATA_WIDTH + MSG_WIDTH - 1 downto (ROW0_W+i)*C_S_AXI_DATA_WIDTH);
    msg_recv_val(i) <= axi_wr_pulse(ROW0_W+i);  -- TODO: probably need to latch this until we get a rdy
  end generate gen_msg;

  -- wr_regs <= (others => '0');
  -- regs_wr_val <= (others => '0');
  gen_pp_msg: for i in 0 to NUM_COLS-1 generate
    -- connect unused upper bits of reg interface to '0'
    wr_regs ((OUT0_R+i+1)*C_S_AXI_DATA_WIDTH - 1 downto (OUT0_R+i)*C_S_AXI_DATA_WIDTH + PP_MSG_WIDTH ) <= (others => '0');
    -- connect incoming message to lowest bits of reg interface
    wr_regs ((OUT0_R+i)*C_S_AXI_DATA_WIDTH + PP_MSG_WIDTH-1 downto (OUT0_R+i)*C_S_AXI_DATA_WIDTH) <= prod_send_msg((i+1)*PP_MSG_WIDTH - 1 downto i*PP_MSG_WIDTH);
    regs_wr_val(OUT0_R+i) <= prod_send_val(i);
    prod_send_rdy(i) <= regs_wr_rdy(OUT0_R+i);
  end generate gen_pp_msg;

  -- connect unused bits of wr_regs and regs_wr_val to '0'
  gen_wr_regs_nc : for i in 0 to NUM_REGS-1 generate
    gen_if_wr_reg_nc : if (i < OUT0_R or i >= OUT0_R+NUM_COLS) generate
      wr_regs((i+1)*C_S_AXI_DATA_WIDTH-1 downto i*C_S_AXI_DATA_WIDTH) <= (others => '0');
      regs_wr_val(i) <= '0'; 
    end generate gen_if_wr_reg_nc;
  end generate gen_wr_regs_nc;

  u_processing_element_array : processing_element_array
  generic map(
    NUM_ROWS => 2,
    NUM_COLS => 2,
    BIT_WIDTH => 8
  )
  port map(
    i_msg_recv_msg  => msg_recv_msg,
    i_msg_recv_val  => msg_recv_val,
    o_msg_recv_rdy  => msg_recv_rdy,  -- TODO: connect this
    o_prod_send_msg => prod_send_msg,
    o_prod_send_val => prod_send_val,
    i_prod_send_rdy => prod_send_rdy,
    i_clk           => S_AXI_ACLK,
    i_rst           => rst
  );
  
  u_axi_reg_slave : axi_reg_slave
  generic map(
    NUM_REGS => NUM_REGS,
    AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
    AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
    RD_ONLY => RD_ONLY
  )
  port map(
    o_regs          => rd_regs,
    o_regs_wr_pulse => axi_wr_pulse,
    o_regs_rd_pulse => axi_rd_pulse,  -- TODO: connect this
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