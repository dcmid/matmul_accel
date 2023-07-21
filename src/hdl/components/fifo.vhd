entity fifo is
  generic (
    BIT_WIDTH : integer := 8;
    DEPTH     : integer := 2
  );
  port (
    i_wr_en   : in  std_logic;
    i_wr_data : in  std_logic_vector(BIT_WIDTH-1 downto 0);
    o_full    : out std_logic;

    i_rd_en   : in  std_logic;
    i_rd_data : out std_logic_vector(BIT_WIDTH-1 downto 0);
    o_empty   : out std_logic;

    i_clk     : in  std_logic;
    i_rst     : in  std_logic
  );
end entity fifo;

architecture rtl of fifo is

  type fifo_array_type is array (0 to DEPTH-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
  signal fifo_array : fifo_array_type;

  signal wr_idx : integer range 0 to DEPTH-1;
  signal rd_idx : integer range 0 to DEPTH-1;
  
  signal data_count : integer range 0 to DEPTH;
begin
  
  proc_ff: process(i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        fifo_array <= (others => (others => '0'));
        wr_idx <= 0;
        rd_idx <= 0;
      else
        if (i_wr_en = '1') then
          fifo_array(wr_idx) <= i_wr_data;
          if (wr_idx = DEPTH-1) then
            wr_idx <= 0;
          else
            wr_idx <= wr_idx + 1;
          end if;
        end if;
        if (i_rd_en = '1') then

        end if;

        if (i_wr_en = '1' and i_rd_en = '0') then
          data_count <= data_count + 1;
        elsif (i_wr_en = '0' and i_rd_en = '1') then
          data_count <= data_count - 1;
        end if;
      end if;
    end if;
  end process proc_ff;
  
  
end architecture rtl;