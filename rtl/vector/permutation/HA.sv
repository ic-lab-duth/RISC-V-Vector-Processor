module HA(
  input logic a,
  input logic b,

  output logic s,
  output logic c_out
);

assign s = a ^ b;
assign c_out = a & b;

endmodule
