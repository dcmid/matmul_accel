library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_reg_slave is
	generic (
		NUM_REGS        : integer := 32;
		AXI_DATA_WIDTH	: integer	:= 32;
		AXI_ADDR_WIDTH	: integer	:= 7;
		-- TODO: fix this generic length
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
end axi_reg_slave;

architecture arch_imp of axi_reg_slave is

	function log2( input:integer ) return integer is
		variable temp,log:integer;
	begin
		temp:=input;
		log:=0;
		while (temp > 1) loop
			temp:=temp/2;
			log:=log+1;
		end loop;
		return log;
	end function log2;

	-- local parameter for addressing 32 bit / 64 bit AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := log2(NUM_REGS);

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
	signal opt_awaddr : std_logic_vector(OPT_MEM_ADDR_BITS-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
	signal opt_araddr : std_logic_vector(OPT_MEM_ADDR_BITS-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
		-- array of all registers
	type reg_array_t is array(NUM_REGS-1 downto 0) of std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
	signal reg_array : reg_array_t;
	signal reg_array_rden	: std_logic;
	signal reg_array_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;
	signal aw_en	: std_logic;

	signal regs_wr_rdy : std_logic_vector(NUM_REGS-1 downto 0);  -- '1' when reg can be written to by PL

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	o_regs_wr_rdy <= regs_wr_rdy;
	opt_awaddr <= axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS - 1 downto ADDR_LSB);
	opt_araddr <= axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS - 1 downto ADDR_LSB);

	connect_o_regs : for i in 0 to NUM_REGS-1 generate
		o_regs((i+1)*AXI_DATA_WIDTH-1 downto i*AXI_DATA_WIDTH) <= reg_array(i);
	end generate connect_o_regs;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	           axi_awready <= '1';
	           aw_en <= '0';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	           aw_en <= '1';
	           axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	reg_array_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
				reg_array <= (others => (others => '0'));
	    else
			  -- incoming writes from AXI
	      if (reg_array_wren = '1' and RD_ONLY(to_integer(unsigned(opt_awaddr))) = '0') then
					for byte_index in 0 to (AXI_DATA_WIDTH/8-1) loop
						if ( S_AXI_WSTRB(byte_index) = '1' ) then
							reg_array(to_integer(unsigned(opt_awaddr)))(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
						end if;
					end loop;
	      end if;
				
				-- incoming writes from PL
				for i in 0 to NUM_REGS-1 loop
					if (i_regs_wr_val(i) = '1' and regs_wr_rdy(i) = '1') then
						reg_array(i) <= i_regs((i+1)*AXI_DATA_WIDTH-1 downto i*AXI_DATA_WIDTH);
					end if;
				end loop;
	    end if;
	  end if;                   
	end process; 

	gen_wr_rdy : for i in 0 to NUM_REGS-1 generate
	  -- RD_ONLY regs can always be written
	  gen_rdonly : if (RD_ONLY(i) = '1') generate
			regs_wr_rdy(i) <= '1';
		end generate gen_rdonly;

		gen_rw : if (RD_ONLY(i) = '0') generate
			process (reg_array_wren, opt_awaddr)
			begin
				-- Don't write regs while AXI is writing them
				if (reg_array_wren = '1' and to_integer(unsigned(opt_awaddr)) = i)  then
					regs_wr_rdy(i) <= '0';
				else
					regs_wr_rdy(i) <= '1';
				end if;
			end process;
		end generate gen_rw;
	end generate gen_wr_rdy;


	-- Output 1-cycle pulse corresponding to register that was written or read via AXI
	process(S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				o_regs_wr_pulse <= (others => '0');
				o_regs_rd_pulse <= (others => '0');
			else
			  o_regs_wr_pulse <= (others => '0');
				o_regs_rd_pulse <= (others => '0');
				if (reg_array_wren = '1') then
					o_regs_wr_pulse(to_integer(unsigned(opt_awaddr))) <= '1';
				end if;
				if (reg_array_rden = '1') then
					o_regs_rd_pulse(to_integer(unsigned(opt_araddr))) <= '1';
				end if;
			end if;
		end if;
	end process;


	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	reg_array_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	-- Address decoding for reading registers
	reg_data_out <= reg_array(to_integer(unsigned(opt_araddr)));

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (reg_array_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;

end arch_imp;
