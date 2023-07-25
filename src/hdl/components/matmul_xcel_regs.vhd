library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library matmul;
use matmul.matmul_xcel_addr_pkg.all;

entity matmul_xcel_regs is
	generic (
		NUM_REGS          : integer := 32;
		AXI_DATA_WIDTH	  : integer	:= 32;
		AXI_ADDR_WIDTH	  : integer	:= 7;
    MATMUL_NUM_ROWS   : integer := 2;
    MATMUL_NUM_COLS   : integer := 2;
    MATMUL_BIT_WIDTH  : integer := 8
	);
  port (
    -- axi_reg_slave interface (input regs)
    i_regs_recv     : in  std_logic_vector(NUM_REGS*AXI_DATA_WIDTH-1 downto 0);
    i_axi_wr_pulse  : in  std_logic_vector(NUM_REGS-1 downto 0);
    -- axi_reg_slave  interface (output regs)
    o_regs_send     : out std_logic_vector(NUM_REGS*AXI_DATA_WIDTH-1 downto 0);
    o_regs_send_val : out std_logic_vector(NUM_REGS - 1 downto 0);
    i_axi_rd_pulse  : in  std_logic_vector(NUM_REGS-1 downto 0);

    -- matmul_xcel row interface (output weights/activations)
    o_row_msg       : out std_logic_vector(MATMUL_NUM_ROWS*(MATMUL_BIT_WIDTH+2)-1 downto 0);
    o_row_msg_val   : out std_logic_vector(MATMUL_NUM_ROWS-1 downto 0);
    i_row_msg_rdy   : in  std_logic_vector(MATMUL_NUM_ROWS-1 downto 0);
    -- matmul_xcel col interface (input results)
    i_col_msg       : in  std_logic_vector(MATMUL_NUM_COLS*(MATMUL_BIT_WIDTH+1)-1 downto 0);
    i_col_msg_val   : in  std_logic_vector(MATMUL_NUM_COLS-1 downto 0);
    o_col_msg_rdy   : out std_logic_vector(MATMUL_NUM_COLS-1 downto 0);

    i_clk           : in  std_logic;
    i_rst           : in  std_logic
  );
end entity matmul_xcel_regs;

architecture rtl of matmul_xcel_regs is

  constant ROW_MSG_WIDTH : integer := MATMUL_BIT_WIDTH + 2;
  constant COL_MSG_WIDTH : integer := MATMUL_BIT_WIDTH + 1;

  type reg_array_t is array(NUM_REGS-1 downto 0) of std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal reg_array : reg_array_t;

  signal row_msg    : std_logic_vector(MATMUL_NUM_ROWS*(MATMUL_BIT_WIDTH+2)-1 downto 0);

  signal row_msg_recv_rdy : std_logic_vector(MATMUL_NUM_ROWS-1 downto 0);
  signal row_msg_send_val : std_logic_vector(MATMUL_NUM_ROWS-1 downto 0);
  signal col_msg_recv_rdy : std_logic_vector(MATMUL_NUM_COLS-1 downto 0);
  signal col_msg_send_val : std_logic_vector(MATMUL_NUM_COLS-1 downto 0);

begin
  
  o_row_msg <= row_msg;
  o_row_msg_val <= row_msg_send_val;
  o_col_msg_rdy <= col_msg_recv_rdy;

  proc_ff : process (i_clk)
    variable reg_addr_lsb : integer;
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        row_msg           <= (others => '0');
        row_msg_recv_rdy  <= (others => '1');
        row_msg_send_val  <= (others => '0');
        col_msg_recv_rdy  <= (others => '1');
        col_msg_send_val  <= (others => '0');
      else
        for i in 0 to MATMUL_NUM_ROWS-1 loop
          -- connect row outputs to register inputs.
          -- when row msg arrives from axi_reg_slave, 
          -- wait for matmul_xcel to consume before accepting another
          if (i_axi_wr_pulse(i) = '1' and row_msg_recv_rdy(i) = '1') then
            reg_addr_lsb := (ROW0_W + i)*AXI_DATA_WIDTH;
            row_msg_recv_rdy(i) <= '0';
            row_msg_send_val(i) <= '1';
            row_msg((i+1)*ROW_MSG_WIDTH - 1 downto i*ROW_MSG_WIDTH) <= i_regs_recv(reg_addr_lsb + ROW_MSG_WIDTH - 1 downto reg_addr_lsb);
          end if;
          
          -- when row msg is consumed by matmul_xcel,
          -- assert rdy to request new msg from axi_reg_slave
          if (row_msg_send_val(i) = '1' and i_row_msg_rdy(i) = '1') then
            row_msg_recv_rdy(i) <= '1';
            row_msg_send_val(i) <= '0';
          end if;
        end loop;

        for j in 0 to MATMUL_NUM_COLS-1 loop
          -- connect column inputs to register outputs.
          -- when col msg arrives from matmul_xcel,
          -- wait for axi_reg_slave to consume before accepting another.
          if (i_col_msg_val(j) = '1' and col_msg_recv_rdy(j) = '1') then
            reg_addr_lsb := (COL0_R + j)*AXI_DATA_WIDTH;
            col_msg_recv_rdy(j) <= '0';
            col_msg_send_val(j) <= '1';
            o_regs_send(reg_addr_lsb + COL_MSG_WIDTH - 1 downto reg_addr_lsb) <= i_col_msg((j+1)*COL_MSG_WIDTH - 1 downto j*COL_MSG_WIDTH);
          end if;

          -- when col msg is consumed by axi_reg_slave,
          -- assert rdy to request new msg from matmul_xcel
          if (col_msg_send_val(j) = '1' and i_axi_rd_pulse(j) = '1') then
            col_msg_recv_rdy <= (others => '1');
            col_msg_send_val <= (others => '0');
          end if;
        end loop;
      end if;
    end if;
  end process proc_ff;

  proc_comb : process(all)
  begin
    -- always enable write for status and column regs
    o_regs_send_val <= (others => '0');
    o_regs_send_val(STATUS_R) <= '1';
    o_regs_send_val(COL0_R + MATMUL_NUM_COLS - 1 downto COL0_R) <= (others => '1');

    -- Connect row receive ready and column send valid to status register 
    -- so the PS can read them
    o_regs_send((STATUS_R+1)*AXI_DATA_WIDTH - 1 downto STATUS_R) <= (others => '0');
    o_regs_send(STATUS_R + MATMUL_NUM_ROWS - 1 downto STATUS_R) <= row_msg_recv_rdy;
    o_regs_send(STATUS_R + 16 + MATMUL_NUM_COLS - 1 downto STATUS_R + 16) <= col_msg_send_val;
  end process proc_comb;
  
  
end architecture rtl;
