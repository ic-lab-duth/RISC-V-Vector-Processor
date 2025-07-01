module FA(
  input logic a,
  input logic b,
  input logic c_in,

  output logic s,
  output logic c_out
);

logic g, p;

assign p = a ^ b;
assign s = p ^ c_in;
assign g = a & b;
assign c_out = (p & c_in) | g;

endmodule
