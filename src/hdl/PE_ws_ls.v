//=========================================================================
// Processing Element (weight stationary, latency sensitive)
//=========================================================================

`ifndef MATMUL_XCEL_PE_WS_LS_V
`define MATMUL_XCEL_PE_WS_LS_V

module matmul_xcel_PE_ws_ls
#(
  parameter BIT_WIDTH=8
)(
  input  logic                 clk,
  input  logic                 reset,

  // inputs from adjacent PEs
  input  logic [BIT_WIDTH-1:0] i_part_prod,     // above
  input  logic [BIT_WIDTH-1:0] i_data,          // left
  input  logic                 i_wr_weight_ena, // left

  // outputs to adjacent PEs
  output logic [BIT_WIDTH-1:0] o_part_prod,     // below
  output logic [BIT_WIDTH-1:0] o_data,          // right
  output logic                 o_wr_weight_ena  // right
);

  logic [BIT_WIDTH-1:0] weight;
  logic                 weight_full;
  logic [BIT_WIDTH-1:0] activation;

  logic [BIT_WIDTH-1:0] part_prod;
  logic                 wr_weight_ena;
  logic [BIT_WIDTH-1:0] data;

  always_ff @(posedge clk) begin
    if (reset) begin
      weight        <= '0;
      weight_full   <= '0;
      activation    <= '0;
      part_prod     <= '0;
      wr_weight_ena <= '0;
      data          <= '0;
    end
    else begin
      wr_weight_ena <= '0;
      // write weight or activation
      if ( i_wr_weight_ena ) begin
        if( !weight_full ) begin  // if not full, load weight
          weight      <= i_data;
          weight_full <= '1;
        end else begin  // if already full, pass on weight
          wr_weight_ena <= '1;
        end
      end else begin
        activation  <= i_data;
      end
      part_prod     <= i_part_prod;
      data          <= i_data;
    end
  end

  always_comb begin
    o_part_prod     = activation*weight + part_prod;
    o_data          = data;
    o_wr_weight_ena = wr_weight_ena;
  end

endmodule

`endif

