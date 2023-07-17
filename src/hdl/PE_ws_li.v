//=========================================================================
// Processing Element (weight stationary, latency insensitive)
//=========================================================================

`ifndef MATMUL_XCEL_PE_WS_LI_V
`define MATMUL_XCEL_PE_WS_LI_V

`include "vc/queues.v"

module matmul_xcel_PE_ws_li
#(
  parameter BIT_WIDTH=8
)(
  input  logic                    clk,
  input  logic                    reset,

  // inputs from adjacent PEs
  input  logic [BIT_WIDTH-1:0]    i_part_prod_recv,     // above
  input  logic                    i_part_prod_recv_val,
  output logic                    o_part_prod_recv_rdy,

  input  logic [BIT_WIDTH-1+1:0]  i_msg_recv,          // left
  input  logic                    i_msg_recv_val,
  output logic                    o_msg_recv_rdy,

  // outputs to adjacent PEs
  output logic [BIT_WIDTH-1:0]    o_part_prod_send,     // below
  output logic                    o_part_prod_send_val,
  input  logic                    i_part_prod_send_rdy,

  output logic [BIT_WIDTH-1+1:0]  o_msg_send,          // right
  output logic                    o_msg_send_val,
  input  logic                    i_msg_send_rdy
);

  // It would be way better if this were in a seperate package
  // but systemverilog doesn't support parameterized structs.
  // Maybe Dr. Batten is right. Maybe PyMTL3 is better.
  typedef struct packed {
    logic [BIT_WIDTH-1:0] data;
    logic                 is_weight;
  } PEMsg;


  logic [BIT_WIDTH-1:0] part_prod_recv_q;
  logic                 part_prod_recv_val_q;
  logic                 part_prod_recv_rdy_q;
  
  PEMsg                 msg_recv_q;
  logic                 msg_recv_val_q;
  logic                 msg_recv_rdy_q;

  PEMsg o_msg;
  assign o_msg_send[BIT_WIDTH-1+1:1]  = o_msg.data;
  assign o_msg_send[0]                = o_msg.is_weight;

  // Queue partial product inputs to avoid val/rdy combinational chain
  vc_Queue#(`VC_QUEUE_NORMAL, BIT_WIDTH, 2) part_prod_queue
  (
    .clk              (clk),
    .reset            (reset),
    .num_free_entries (),
    .recv_val         (i_part_prod_recv_val),
    .recv_rdy         (o_part_prod_recv_rdy),
    .recv_msg         (i_part_prod_recv),
    .send_val         (part_prod_recv_val_q),
    .send_rdy         (part_prod_recv_rdy_q),
    .send_msg         (part_prod_recv_q)
  );

  // Queue msg inputs to avoid val/rdy combinational chain
  vc_Queue#(`VC_QUEUE_NORMAL, $bits(PEMsg), 2) msg_queue
  (
    .clk              (clk),
    .reset            (reset),
    .num_free_entries (),
    .recv_val         (i_msg_recv_val),
    .recv_rdy         (o_msg_recv_rdy),
    .recv_msg         (i_msg_recv),
    .send_val         (msg_recv_val_q),
    .send_rdy         (msg_recv_rdy_q),
    .send_msg         (msg_recv_q)
  );

  logic [BIT_WIDTH-1:0] weight;
  logic                 weight_full;
  logic [BIT_WIDTH-1:0] activation;
  logic                 activation_full;

  logic                 wr_weight_ena;

  logic                 inputs_val;
  logic                 outputs_rdy;

  always_ff @(posedge clk) begin
    if (reset) begin
      weight          <= '0;
      weight_full     <= '0;
    end
    else begin
      if (msg_recv_val_q && msg_recv_rdy_q) begin   // if input message valid and PE is ready for it
        if (msg_recv_q.is_weight) begin             // if input message is weight
          if (!weight_full) begin                   // if PE doesn't already have a weight
            weight      <= msg_recv_q.data;         // read in weight from input message
            weight_full <= '1;                      // set weight_full
          end
        end
      end
    end
  end

  assign inputs_val           = part_prod_recv_val_q && msg_recv_val_q;
  assign outputs_rdy          = i_part_prod_send_rdy && i_msg_send_rdy;
  assign part_prod_recv_rdy_q = outputs_rdy && msg_recv_val_q && !msg_recv_q.is_weight;
  assign msg_recv_rdy_q       = outputs_rdy && (part_prod_recv_val_q || msg_recv_q.is_weight);
  always_comb begin
    o_msg = '0;
    o_msg_send_val = 0;
    o_part_prod_send = '0;
    o_part_prod_send_val = 0;
    activation = 0;


    if (msg_recv_val_q && msg_recv_rdy_q) begin
      if (weight_full) begin                        // outputs all 0 until weight is full
        if (msg_recv_q.is_weight) begin
            o_msg.data      = msg_recv_q.data;      // output weight to next PE
            o_msg.is_weight = '1;
            o_msg_send_val  = '1;                   
        end
        else begin                                  // if activation input, output partial product
          o_part_prod_send     = weight * msg_recv_q.data + part_prod_recv_q;
          o_part_prod_send_val = '1;
          activation           = msg_recv_q.data;   // read in activation from input message
          o_msg.data           = msg_recv_q.data;   // pass activation to next PE
          o_msg.is_weight      = '0;
          o_msg_send_val       = '1;
        end
      end
    end
  end

endmodule

`endif

