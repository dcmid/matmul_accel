//=========================================================================
// PE Array (weight stationary, latency sensitive)
//=========================================================================

`ifndef MATMUL_XCEL_PE_ARRAY_WS_LS_V
`define MATMUL_XCEL_PE_ARRAY_WS_LS_V

`include "matmul_xcel/PE_ws_ls.v"

module matmul_xcel_PEArray_ws_ls
#(
  parameter NUM_ROWS  = 2,
  parameter NUM_COLS  = 2,
  parameter BIT_WIDTH = 8
)(
  input  logic                 clk,
  input  logic                 reset,

  input  logic [BIT_WIDTH-1:0] i_data           [NUM_ROWS],
  input  logic                 i_wr_weight_ena,

  output logic [BIT_WIDTH-1:0] o_products       [NUM_COLS]
);

  logic [BIT_WIDTH-1:0] part_prod_in      [NUM_ROWS][NUM_COLS];
  logic [BIT_WIDTH-1:0] data_in           [NUM_ROWS][NUM_COLS];
  logic                 wr_weight_ena_in  [NUM_ROWS][NUM_COLS];

  logic [BIT_WIDTH-1:0] part_prod_out     [NUM_ROWS][NUM_COLS];
  logic [BIT_WIDTH-1:0] data_out          [NUM_ROWS][NUM_COLS];
  logic                 wr_weight_ena_out [NUM_ROWS][NUM_COLS];

  genvar i;
  genvar j;
  generate
    for (i = 0; i < NUM_ROWS; i = i + 1) begin
      for (j =0; j < NUM_COLS; j = j + 1) begin
        matmul_xcel_PE_ws_ls#(BIT_WIDTH) pe_ij
        (
          .clk             (clk),
          .reset           (reset),

          .i_part_prod     (part_prod_in[i][j]),
          .i_data          (data_in[i][j]),
          .i_wr_weight_ena (wr_weight_ena_in[i][j]),

          .o_part_prod     (part_prod_out[i][j]),
          .o_data          (data_out[i][j]),
          .o_wr_weight_ena (wr_weight_ena_out[i][j])
        );
      end
    end

    // array interconnect
    for (i = 0; i < NUM_ROWS; i = i + 1) begin
      for (j = 0; j < NUM_COLS; j = j + 1) begin
        if (i == 0) begin  // first row part_prods all 0
          assign part_prod_in[i][j] = '0;
        end else begin  // other part_prods come from above PEs
          assign part_prod_in[i][j] = part_prod_out[i-1][j];
        end

        if (j == 0) begin  // first column data/ena inputs come from top-level inputs
          assign data_in[i][j] = i_data[i];
          assign wr_weight_ena_in[i][j] = i_wr_weight_ena;
        end else begin  // rest come from PE to left
          assign data_in[i][j] = data_out[i][j-1];
          assign wr_weight_ena_in[i][j] = wr_weight_ena_out[i][j-1];
        end

        if (i == NUM_ROWS-1) begin  // last row products go to top-level outputs
          assign o_products[j] = part_prod_out[i][j];
        end
      end
    end
  endgenerate

endmodule

`endif
