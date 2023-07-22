library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.type_pkg.all;

package component_pkg is

  component processing_element_array is
    generic (
      NUM_ROWS    : integer := 2;
      NUM_COLS    : integer := 2;
      BIT_WIDTH   : integer := 8
    );
    port (
      i_msg_recv_msg    : in  std_logic_vector(NUM_ROWS*(BIT_WIDTH+2)-1 downto 0);
      i_msg_recv_val    : in  std_logic_vector(NUM_ROWS-1 downto 0);
      o_msg_recv_rdy    : out std_logic_vector(NUM_ROWS-1 downto 0);
     
      o_prod_send_msg    : out std_logic_vector(NUM_COLS*(BIT_WIDTH+1)-1 downto 0);
      o_prod_send_val    : out std_logic_vector(NUM_COLS-1 downto 0);
      i_prod_send_rdy    : in  std_logic_vector(NUM_COLS-1 downto 0);
  
      i_clk              : in  std_logic;
      i_rst              : in  std_logic
    );
  end component processing_element_array;
  
  component axi_reg_slave is
    generic (
      NUM_REGS        : integer := 32;
      AXI_DATA_WIDTH	: integer	:= 32;
      AXI_ADDR_WIDTH	: integer	:= 7;
      -- TODO: Fix this generic length
      RD_ONLY         : std_logic_vector(32-1 downto 0) := (others => '0') -- place '1' in bit corresponding to read only addresses
    );
    port (
      -- register data
      o_regs          : out std_logic_vector(NUM_REGS*AXI_DATA_WIDTH-1 downto 0);
      o_regs_wr_pulse : out std_logic_vector(NUM_REGS-1 downto 0);
      o_regs_rd_pulse : out std_logic_vector(NUM_REGS-1 downto 0);
      i_regs          : in  std_logic_vector(NUM_REGS*AXI_DATA_WIDTH-1 downto 0);
      i_regs_wr_val   : in  std_logic_vector(NUM_REGS-1 downto 0);
      o_regs_wr_rdy   : out std_logic_vector(NUM_REGS-1 downto 0);
  
      -- AXI bus
      S_AXI_ACLK	: in std_logic;
      S_AXI_ARESETN	: in std_logic;
      S_AXI_AWADDR	: in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
      S_AXI_AWVALID	: in std_logic;
      S_AXI_AWREADY	: out std_logic;
      S_AXI_WDATA	: in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB	: in std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WVALID	: in std_logic;
      S_AXI_WREADY	: out std_logic;
      S_AXI_BRESP	: out std_logic_vector(1 downto 0);
      S_AXI_BVALID	: out std_logic;
      S_AXI_BREADY	: in std_logic;
      S_AXI_ARADDR	: in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
      S_AXI_ARVALID	: in std_logic;
      S_AXI_ARREADY	: out std_logic;
      S_AXI_RDATA	: out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP	: out std_logic_vector(1 downto 0);
      S_AXI_RVALID	: out std_logic;
      S_AXI_RREADY	: in std_logic
    );
  end component axi_reg_slave;
  
end package component_pkg;