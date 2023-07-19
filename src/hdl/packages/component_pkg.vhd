library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package component_pkg is
  
  component axi_reg_slave is
    generic (
      C_S_AXI_DATA_WIDTH	: integer	:= 32;
      C_S_AXI_ADDR_WIDTH	: integer	:= 7
    );
    port (
      -- Users to add ports here
      i_input_ready		: in 	std_logic_vector(32 downto 0);
      i_output_valid  : in  std_logic_vector(32 downto 0);
      o_row1          : out std_logic_vector(32 downto 0);
      o_row2          : out std_logic_vector(32 downto 0);
      o_row3          : out std_logic_vector(32 downto 0);
      i_out1          : in  std_logic_vector(32 downto 0);
      i_out2          : in  std_logic_vector(32 downto 0);
      i_out3          : in  std_logic_vector(32 downto 0);
      -- User ports ends
      -- Do not modify the ports beyond this line

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
  end component axi_reg_slave;
  
end package component_pkg;