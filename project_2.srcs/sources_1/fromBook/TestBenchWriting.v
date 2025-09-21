module mux_gl (
    input  a,
    b,
    s,
    output y
);
  wire q1, q2, sbar;
  not n1 (sbar, s);
  and a1 (q1, sbar, a);
  and a2 (q2, s, b);
  or o1 (y, q1, q2);
endmodule

