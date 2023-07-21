module processing_element_array_tb;
  localparam period = 5ns;
  localparam BIT_WIDTH = 8;
  localparam MSG_WIDTH = BIT_WIDTH+2;
  localparam PP_MSG_WIDTH = BIT_WIDTH+1;
  localparam NUM_ROWS = 2;
  localparam NUM_COLS = 2;

  typedef logic [BIT_WIDTH-1:0] rmat [NUM_COLS][NUM_ROWS];

  function rmat rotate_matrix;
    input logic [BIT_WIDTH-1:0] matrix [NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; i++) begin
      for (int j = 0; j < NUM_COLS; j++) begin
        rotate_matrix[i][j] = matrix[NUM_COLS-1-j][i];
      end
    end

  endfunction

  task automatic load_weights; 
    ref logic [BIT_WIDTH-1:0] weights [NUM_ROWS-1:0][NUM_COLS-1:0];
    ref logic [NUM_ROWS-1:0] rdy; 
    ref logic [MSG_WIDTH-1:0] msg [NUM_ROWS-1:0];
    ref logic [NUM_ROWS-1:0] val;
    ref logic clk;
    begin
      for (int i = 0; i < NUM_COLS; i++) begin
        val = '1;
        for (int j = 0; j < NUM_ROWS; j++) begin
          msg[j][BIT_WIDTH-1:0] = weights[j][NUM_COLS-1-i];
          msg[j][MSG_WIDTH-1] = '0;
          msg[j][MSG_WIDTH-2] = '1;
        end
        wait (rdy == '1);
        @(posedge clk);
        // val = '0;
      end
      val = '0;
      msg = '{default:'0};
    end
  endtask

  task automatic load_activations; 
  ref logic [BIT_WIDTH-1:0] activations [NUM_ROWS-1:0][NUM_COLS-1:0];
  ref logic [NUM_ROWS-1:0] rdy; 
  ref logic [MSG_WIDTH-1:0] msg [NUM_ROWS-1:0];
  ref logic [NUM_ROWS-1:0] val;
  ref logic clk;
  begin
    int write_count [NUM_ROWS-1 : 0] = '{default:0};
    int total_write_count = 0;
    val = '0;
    while (total_write_count < NUM_ROWS*NUM_COLS) begin
      for (int i = 0; i < NUM_ROWS; i++) begin
        if (rdy[i] && val) begin  // Count completed writes
          if (write_count[i] < NUM_ROWS) begin
            write_count[i] += 1;
            total_write_count += 1;
          end
        end
        if (write_count[i] < NUM_ROWS) begin
          msg[i][BIT_WIDTH-1:0] = rotate_matrix(activations)[i][write_count[i]];
          // msg[i][BIT_WIDTH-1:0] = activations[i][write_count[i]];
          msg[i][MSG_WIDTH-1] = 1'b0;
          msg[i][MSG_WIDTH-2] = 1'b0;
        end else begin
          msg[i][BIT_WIDTH-1:0] = '0;
          msg[i][MSG_WIDTH-1] = 1'b1;  // Set is_flush bit high
          msg[i][MSG_WIDTH-2] = 1'b0;  // Set is_weight bit low
        end
      end
      val = '1; 
      @(posedge clk);
    end
    // set all messages to flush
    for (int i = 0; i < NUM_ROWS; i++) begin
      msg[i][BIT_WIDTH-1:0] = '0;
      msg[i][MSG_WIDTH-1] = 1'b1;  // Set is_flush bit high
      msg[i][MSG_WIDTH-2] = 1'b0;  // Set is_weight bit low
    end
  end
endtask

  typedef struct packed {
    logic                 is_weight;
    logic [BIT_WIDTH-1:0] data;
  } PEMsg;

  logic clk;
  logic rst;

  logic [MSG_WIDTH-1:0]   msg_recv_msg [NUM_ROWS-1:0];
  logic [NUM_ROWS-1:0]    msg_recv_val;
  logic [NUM_ROWS-1:0]    msg_recv_rdy;

  logic [PP_MSG_WIDTH-1:0]  prod_send_msg [NUM_COLS-1:0];
  logic [NUM_COLS-1:0]      prod_send_val;
  logic [NUM_COLS-1:0]      prod_send_rdy;

  logic [NUM_ROWS-1:0]  test_rdy = '0;
  logic [MSG_WIDTH-1:0] test_msg [NUM_ROWS-1:0];
  logic [NUM_ROWS-1:0]  test_val;
  logic [BIT_WIDTH-1:0] test_weights [NUM_ROWS][NUM_COLS] = 
    {
      {'d1, 'd0},
      {'d0, 'd1}
    };
  logic [BIT_WIDTH-1:0] test_activations [NUM_ROWS][NUM_COLS] = 
  {
    {'d1, 'd2},
    {'d3, 'd4}
  };

  logic [BIT_WIDTH-1:0] output_array [NUM_ROWS][NUM_COLS] = '{default:'0};
  int output_counts [NUM_COLS] = '{default:0};

  initial
  begin
    clk <= '0;
    rst <= '1;
    msg_recv_msg <= '{default:'0};
    msg_recv_val <= '0;
    prod_send_rdy <= '1;
    for (int i=0; i<2; i++)
      @(posedge clk);
    rst <= '0;
    load_weights(test_weights, msg_recv_rdy, msg_recv_msg, msg_recv_val, clk);

    for (int i=0; i<5; i++)
      @(posedge clk);

    load_activations(test_activations, msg_recv_rdy, msg_recv_msg, msg_recv_val, clk);
    msg_recv_val = '1;

    for (int i=0; i<15; i++)
      @(posedge clk);

    wait (output_counts[NUM_COLS-1] == NUM_ROWS);

    $stop;
  end

  //generate a clock
  always #period clk <= !clk;
  int row = 0;
  always @(posedge clk) begin
    for (int col=0; col<NUM_COLS; col++) begin
      if (prod_send_val[col] && prod_send_rdy[col]) begin
        if (prod_send_msg[col][PP_MSG_WIDTH-1] == 1'b0) begin
          row = output_counts[col];
          output_array[row][col] = prod_send_msg[col][BIT_WIDTH-1:0];
          output_counts[col] ++;
        end
      end
    end
  end

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