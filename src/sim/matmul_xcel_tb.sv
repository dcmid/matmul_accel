module matmul_xcel_tb;
localparam NUM_ROWS = 2;
localparam NUM_COLS = 2;
localparam BIT_WIDTH = 8;
localparam C_S_AXI_ADDR_WIDTH = 7;
localparam C_S_AXI_DATA_WIDTH = 32;

logic clk = 0;
logic resetn = 0;
logic [C_S_AXI_ADDR_WIDTH-1:0] awaddr;
logic [2:0] awprot;
logic awvalid;
logic awready;
logic [C_S_AXI_DATA_WIDTH-1:0] wdata;
logic [(C_S_AXI_DATA_WIDTH/8)-1:0] wstrb;
logic wvalid;
logic wready;
logic [1:0] bresp;
logic bvalid;
logic bready;
logic [C_S_AXI_ADDR_WIDTH-1:0] araddr;
logic [2:0] arprot;
logic arvalid;
logic arready;
logic [C_S_AXI_DATA_WIDTH-1:0] rdata;
logic [1:0] rresp;
logic rvalid;
logic rready;


matmul_xcel #(
  .NUM_ROWS(NUM_ROWS),
  .NUM_COLS(NUM_COLS),
  .BIT_WIDTH(BIT_WIDTH),
  .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
  .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)
) uut
(
  .S_AXI_ACLK(clk),
  .S_AXI_ARESETN(resetn),
  .S_AXI_AWADDR(awaddr),
  .S_AXI_AWPROT(awprot),
  .S_AXI_AWVALID(awvalid),
  .S_AXI_AWREADY(awready),
  .S_AXI_WDATA(wdata),
  .S_AXI_WSTRB(wstrb),
  .S_AXI_WVALID(wvalid),
  .S_AXI_WREADY(wready),
  .S_AXI_BRESP(bresp),
  .S_AXI_BVALID(bvalid),
  .S_AXI_BREADY(bready),
  .S_AXI_ARADDR(araddr),
  .S_AXI_ARPROT(arprot),
  .S_AXI_ARVALID(arvalid),
  .S_AXI_ARREADY(arready),
  .S_AXI_RDATA(rdata),
  .S_AXI_RRESP(rresp),
  .S_AXI_RVALID(rvalid),
  .S_AXI_RREADY(rready)
);
  
endmodule