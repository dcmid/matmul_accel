
module processing_element_tb;

  localparam  period = 5ns;
  localparam  BIT_WIDTH = 8;

  typedef struct packed {
    logic                 is_weight;
    logic [BIT_WIDTH-1:0] data;
  } PEMsg;

  logic        clk;
  logic        rst;

  logic [BIT_WIDTH-1:0]  part_prod_recv;
  logic                  part_prod_recv_val;
  logic                  part_prod_recv_rdy;

  PEMsg                  msg_recv;
  logic                  msg_recv_val;
  logic                  msg_recv_rdy;

  logic [BIT_WIDTH-1:0]  part_prod_send;
  logic                  part_prod_send_val;
  logic                  part_prod_send_rdy;

  PEMsg                  msg_send;
  logic                  msg_send_val;
  logic                  msg_send_rdy;

  // TEST CASES --------------------------------------------
  logic [0:4][BIT_WIDTH-1:0] stim_weights;
  logic [0:4][BIT_WIDTH-1:0] stim_activations;
  logic [0:4][BIT_WIDTH-1:0] stim_part_prod;  
  logic [0:4][BIT_WIDTH-1:0] expected;

  assign msg_send_rdy = '1;
  assign part_prod_send_rdy = '1;

  initial begin
    stim_weights     = '{0, 1, 2,   10, 17};
    stim_activations = '{0, 5, 8,   12, 13};
    stim_part_prod   = '{5, 4, 3,    2,  1};
    expected         = '{5, 9, 19, 122, 222};
  end
  // -------------------------------------------------------

  // TASKS -------------------------------------------------
  // reset the PE
  task reset ();
    begin
      rst = '1;
      @(posedge clk);
      rst = '0; 
    end
  endtask

  // load in new weight; PE must be empty
  task load_weight;
    input byte unsigned weight;
    begin
      msg_recv.data = weight;
      msg_recv.is_weight = '1;
      msg_recv_val = '1;
      @(posedge clk);
      msg_recv_val = '0;
    end
  endtask

  // loads activation from left and part prod from above
  task load_neighbors;
    input byte unsigned activation, part_prod;
    begin
      msg_recv.data = activation;
      msg_recv.is_weight = '0;
      part_prod_recv = part_prod;
      msg_recv_val = '1;
      part_prod_recv_val = '1;
      @(posedge clk);
      msg_recv_val = '0;
      part_prod_recv_val = '0;
    end
  endtask
  //--------------------------------------------------------


  int i = 0;

  initial begin
    clk = 0;
    msg_recv_val = '0;
    part_prod_recv_val = '0;
    rst = '1;
    @(posedge clk);

    while (i < 5) begin
      reset();
      load_weight(stim_weights[i]);
      load_neighbors(stim_activations[i], stim_part_prod[i]);
      @(posedge clk);

      $display ("weight:\t%d", stim_weights[i]);
      $display ("activ: \t%d", stim_activations[i]);
      $display ("expect:\t%d", expected[i]);
      $display ("actual:\t%d\n\n", part_prod_send);
      // $display ("val?:\t%d", part_prod_send_val);
      // assert (part_prod_send == expected[i]);
      //assert (part_prod_send < 250);
      // @(posedge clk);

      i = i + 1;
    end
  end

    //generate a clock
  always #period clk <= !clk;

  // dump for plotting waves
  // initial
    // begin
    //   $dumpfile ("processor_element.dump");
    //   $dumpvars (0, processing_element_tb);
    // end

  always @(posedge clk) begin
    if(i == 5) begin
      $stop;
    end
  end

  processing_element uut
  (
    .i_part_prod_recv(part_prod_recv),
    .i_part_prod_recv_val(part_prod_recv_val),
    .o_part_prod_recv_rdy(part_prod_recv_rdy),

    .i_msg_recv(msg_recv),
    .i_msg_recv_val(msg_recv_val),
    .o_msg_recv_rdy(msg_recv_rdy),

    .o_part_prod_send(part_prod_send),
    .o_part_prod_send_val(part_prod_send_val),
    .i_part_prod_send_rdy(part_prod_send_rdy),

    .o_msg_send(msg_send),
    .o_msg_send_val(msg_send_val),
    .i_msg_send_rdy(msg_send_rdy),

    .i_clk(clk),
    .i_rst(rst)
    // .o_wr_weight_ena(wr_weight_ena_out),
    // .o_weight_full(weight_full)
  );

endmodule