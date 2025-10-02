Yes — the two versions are **functionally the same**, only the order is different.

In Verilog:

```verilog
assign y = (a & sbar) | (s & b);
assign sbar = ~s;
```

and

```verilog
assign sbar = ~s;
assign y = (a & sbar) | (s & b);
```

both describe the **same hardware logic**.

### Why?

* `assign` statements are **continuous assignments**.
* They don’t execute in order like software instructions — instead, they define combinational connections in hardware.
* So regardless of which line you write first, the synthesizer sees:

  * `sbar = ~s`
  * `y = (a & ~s) | (s & b)`

That is exactly a **2:1 multiplexer**:

* If `s = 0` → `y = a`
* If `s = 1` → `y = b`

---

⚠️ Important contrast: In an `always` block with **procedural assignments**, the order *does* matter. But with `assign`, the order does **not** matter.

Would you like me to also show the **truth table** so you can clearly see it behaves like a MUX?
