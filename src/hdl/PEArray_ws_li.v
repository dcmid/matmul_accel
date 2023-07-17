//=========================================================================
// PE Array (weight stationary, latency insensitive)
//=========================================================================

`ifndef MATMUL_XCEL_PE_ARRAY_WS_LI_V
`define MATMUL_XCEL_PE_ARRAY_WS_LI_V

`include "matmul_xcel/PE_ws_li.v"

module matmul_xcel_PEArray_ws_li
#(
  parameter NUM_ROWS  = 2,
  parameter NUM_COLS  = 2,
  parameter BIT_WIDTH = 8
)(
  input  logic                    clk,
  input  logic                    reset,

  input  logic [BIT_WIDTH-1+1:0]  msg_recv_msg  [NUM_ROWS],
  input  logic                    msg_recv_val  [NUM_ROWS],
  output logic                    msg_recv_rdy  [NUM_ROWS],

  output logic [BIT_WIDTH-1:0]    prod_send_msg [NUM_COLS],
  output logic                    prod_send_val [NUM_COLS],
  input  logic                    prod_send_rdy [NUM_COLS]
);

  // signals to interface array of PEs
  logic [BIT_WIDTH-1:0]   i_part_prod_recv      [NUM_ROWS][NUM_COLS];
  logic                   i_part_prod_recv_val  [NUM_ROWS][NUM_COLS];
  logic                   o_part_prod_recv_rdy  [NUM_ROWS][NUM_COLS];
  logic [BIT_WIDTH-1+1:0] i_msg_recv            [NUM_ROWS][NUM_COLS];
  logic                   i_msg_recv_val        [NUM_ROWS][NUM_COLS];
  logic                   o_msg_recv_rdy        [NUM_ROWS][NUM_COLS];
  logic [BIT_WIDTH-1:0]   o_part_prod_send      [NUM_ROWS][NUM_COLS];
  logic                   o_part_prod_send_val  [NUM_ROWS][NUM_COLS];
  logic                   i_part_prod_send_rdy  [NUM_ROWS][NUM_COLS];
  logic [BIT_WIDTH-1+1:0] o_msg_send            [NUM_ROWS][NUM_COLS];
  logic                   o_msg_send_val        [NUM_ROWS][NUM_COLS];
  logic                   i_msg_send_rdy        [NUM_ROWS][NUM_COLS];

  genvar i;
  genvar j;
  generate
    for (i = 0; i < NUM_ROWS; i = i + 1) begin
      for (j =0; j < NUM_COLS; j = j + 1) begin
        matmul_xcel_PE_ws_li#(BIT_WIDTH) pe_ij
        (
          .clk             (clk),
          .reset           (reset),

          // inputs from adjacent PEs
          .i_part_prod_recv               (i_part_prod_recv[i][j]),     // above
          .i_part_prod_recv_val           (i_part_prod_recv_val[i][j]),
          .o_part_prod_recv_rdy           (o_part_prod_recv_rdy[i][j]),

          .i_msg_recv                     (i_msg_recv[i][j]),          // left
          .i_msg_recv_val                 (i_msg_recv_val[i][j]),
          .o_msg_recv_rdy                 (o_msg_recv_rdy[i][j]),

          // outputs to adjacent PEs
          .o_part_prod_send               (o_part_prod_send[i][j]),     // below
          .o_part_prod_send_val           (o_part_prod_send_val[i][j]),
          .i_part_prod_send_rdy           (i_part_prod_send_rdy[i][j]),

          .o_msg_send                     (o_msg_send[i][j]),          // right
          .o_msg_send_val                 (o_msg_send_val[i][j]),
          .i_msg_send_rdy                 (i_msg_send_rdy[i][j])
        );
      end
    end

    // array interconnect
    for (i = 0; i < NUM_ROWS; i = i + 1) begin
      for (j = 0; j < NUM_COLS; j = j + 1) begin
        if (i == 0) begin                                                     // first row part_prods all 0
          assign i_part_prod_recv[i][j]       = '0;
          assign i_part_prod_recv_val[i][j]   = '1;
        end else begin                                                        // other part_prods come from above PEs
          assign i_part_prod_recv[i][j]       = o_part_prod_send[i-1][j];
          assign i_part_prod_recv_val[i][j]   = o_part_prod_send_val[i-1][j];
          assign i_part_prod_send_rdy[i-1][j] = o_part_prod_recv_rdy[i][j];
        end

        if (j == 0) begin                                                     // first column msgs come from top-level inputs
          assign i_msg_recv[i][j]             = msg_recv_msg[i];
          assign i_msg_recv_val[i][j]         = msg_recv_val[i];
          assign msg_recv_rdy[i]              = o_msg_recv_rdy[i][j];
        end else begin                                                        // rest come from PE to left
          assign i_msg_recv[i][j]             = o_msg_send[i][j-1];
          assign i_msg_recv_val[i][j]         = o_msg_send_val[i][j-1];
          assign i_msg_send_rdy[i][j-1]       = o_msg_recv_rdy[i][j];
        end

        if (i == NUM_ROWS-1) begin                                            // last row products go to top-level outputs
          assign prod_send_msg[j]             = o_part_prod_send[i][j];
          assign prod_send_val[j]             = o_part_prod_send_val[i][j];
          assign i_part_prod_send_rdy[i][j]   = prod_send_rdy[j];
        end

        if (j == NUM_COLS-1) begin                                            // last col always ready for messages
          assign i_msg_send_rdy[i][j]         = '1;                           // (they don't go anywhere)
        end
      end
    end
  endgenerate

endmodule


`endif