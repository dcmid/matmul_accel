module processing_element_array_tb;
  localparam period = 5ns;
  localparam BIT_WIDTH = 8;
  localparam NUM_ROWS = 2;
  localparam NUM_COLS = 2;

  typedef struct packed {
    logic                 is_weight;
    logic [BIT_WIDTH-1:0] data;
  } PEMsg;

  logic clk;
  logic rst;

  logic [BIT_WIDTH-1+1:0] msg_recv_msg [NUM_ROWS-1:0];
  logic [NUM_ROWS-1:0]    msg_recv_val;
  logic [NUM_ROWS-1:0]    msg_recv_rdy;

  logic [BIT_WIDTH-1:0] prod_send_msg [NUM_COLS-1:0];
  logic [NUM_COLS-1:0]  prod_send_val;
  logic [NUM_COLS-1:0]  prod_send_rdy;

  assign msg_recv_msg = '{default:'0};
  assign msg_recv_val = '0;
  assign prod_send_rdy = '0;

  initial
  begin
    clk <= '0;
    // rst <= '1;
    // for (int i=0; i<5; i++)
    //   @(posedge clk);
    rst <= '0;
  end

  //generate a clock
  always #period clk <= !clk;

  processing_element_array #(
    .NUM_ROWS(2),
    .NUM_COLS(2),
    .BIT_WIDTH(BIT_WIDTH)
  ) uut
  (
    .i_msg_recv_msg(msg_recv_msg),
    .i_msg_recv_val(msg_recv_val),
    .o_msg_recv_rdy(msg_recv_rdy),

    .o_prod_send_msg(prod_send_msg),
    .o_prod_send_val(prod_send_val),
    .i_prod_send_rdy(prod_send_rdy),

    .i_clk(clk),
    .i_rst(rst)
  );

endmodule