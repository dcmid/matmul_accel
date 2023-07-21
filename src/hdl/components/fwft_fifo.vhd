-- Uses VHDL2008

-- First word fall through FIFO pure VHDL implementation
--   Not protected against writing full or reading empty, so don't do it!

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fwft_fifo is
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
end entity fwft_fifo;

architecture rtl of fwft_fifo is

  type fifo_array_type is array (0 to DEPTH-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
  signal fifo_array : fifo_array_type;

  signal wr_idx : integer range 0 to DEPTH-1;
  signal rd_idx : integer range 0 to DEPTH-1;
  
  signal data_count : integer range 0 to DEPTH;
  signal full       : boolean;
  signal empty      : boolean;
begin
  
  o_rd_data <= fifo_array(rd_idx);

  full  <= data_count = DEPTH;
  empty <= data_count = 0;

  proc_ff: process(i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        fifo_array <= (others => (others => '0'));
        wr_idx <= 0;
        rd_idx <= 0;

        o_empty <= '1';
        o_full  <= '0';
        data_count <= 0;
      else
        -- write
        if (i_wr_en = '1') then
          if (not full) then  -- protect against writing when full
            fifo_array(wr_idx) <= i_wr_data;
            if (wr_idx = DEPTH-1) then
              wr_idx <= 0;
            else
              wr_idx <= wr_idx + 1;
            end if;
          end if;
        end if;

        -- read
        if (i_rd_en = '1') then
          if (not empty) then  -- protect against reading when empty
            if (rd_idx = DEPTH-1) then
              rd_idx <= 0;
            else
              rd_idx <= rd_idx + 1;
            end if;
          end if;
        end if;

        -- count data stored
        if (i_wr_en = '1' and i_rd_en = '0') then
          o_empty <= '0';
          if (full) then
            o_full <= '1';
          elsif (data_count = DEPTH - 1) then
            data_count <= data_count + 1;
            o_full <= '1';
          else
            data_count <= data_count + 1;
            o_full <= '0';
          end if;
        elsif (i_wr_en = '0' and i_rd_en = '1') then
          o_full <= '0';
          if (empty) then
            o_empty <= '1';
          elsif (data_count = 1) then
            data_count <= data_count - 1;
            o_empty <= '1';
          else
            data_count <= data_count - 1;
            o_empty <= '0';
          end if;
        elsif (i_wr_en = '1' and i_rd_en = '1') then
          if (empty) then
            data_count <= data_count + 1;
            o_empty <= '0';
          elsif (full) then
            data_count <= data_count - 1;
            o_full <= '0';
          end if;
        end if;
      end if;
    end if;
  end process proc_ff;
  
  
end architecture rtl;