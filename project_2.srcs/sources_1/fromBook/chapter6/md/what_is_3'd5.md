`3'd5` is a **Verilog constant literal**. It means:

* **`3`** → the **width** of the constant is 3 bits.
* **`d`** → the **radix/base** is **decimal** (`d` = decimal, `b` = binary, `o` = octal, `h` = hex).
* **`5`** → the actual **value** is 5 in decimal.

So:

```
3'd5 = decimal 5, represented in 3 bits
```

In binary:

```
5 (decimal) = 101 (binary)
```

Since it’s 3 bits wide, the stored value is:

```
3'b101
```

---

### Other examples

* `4'b1010` → 4-bit binary literal = decimal 10
* `8'hFF`   → 8-bit hex literal = decimal 255
* `6'o77`   → 6-bit octal literal = decimal 63
* `3'd7`    → 3-bit decimal literal = binary `111`

If the number is **too big for the width**, it gets truncated to the lower bits. For example:

```
3'd9 = decimal 9 = binary 1001 → truncated to 3 bits = 001
```

---

👉 In your code:
`on_time = 3'd5;` means the `on_time` parameter is a **3-bit wide constant equal to decimal 5** (`101` in binary).

Do you want me to also explain why we often specify the width like `3'd5` instead of just `5` in Verilog FSM/counter designs?
