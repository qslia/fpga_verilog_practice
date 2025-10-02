# Blocking vs Non-Blocking Assignments in Verilog

## Code Corrections Made

### Original (Incorrect) Code:
```verilog
# Blocking Procedural Statement
begin
 x = #5 1'b1;
 x = #6 1'b0;
 x = #7 1'b1;
 end

# Non-Blocking Procedural Statement
 begin
 x <= #5 1'b1;
 x <= #6 1'b0;
 x <= #7 1'b1;
 end
```

### Corrected Code:
```verilog
// Blocking Procedural Statement Example
initial begin
  x = #5 1'b1;   // Wait 5 time units, then assign 1 to x
  x = #6 1'b0;   // Wait 6 more time units, then assign 0 to x
  x = #7 1'b1;   // Wait 7 more time units, then assign 1 to x
end

// Non-Blocking Procedural Statement Example
initial begin
  x <= #5 1'b1;  // Schedule assignment of 1 to x after 5 time units
  x <= #6 1'b0;  // Schedule assignment of 0 to x after 6 time units
  x <= #7 1'b1;  // Schedule assignment of 1 to x after 7 time units
end
```

## Syntax Errors Fixed

1. **Comment Syntax**: Changed `#` to `//` for comments
2. **Procedural Block**: Added `initial` keyword to create proper procedural blocks
3. **Indentation**: Fixed proper indentation for readability

## Blocking vs Non-Blocking Assignments

### Blocking Assignment (`=`)

**Syntax**: `variable = value;`

**Characteristics**:
- Executes **immediately** and **sequentially**
- Blocks execution until assignment is complete
- Next statement waits for current assignment to finish
- Used for **combinational logic**

**Example with Timing**:
```verilog
initial begin
  x = #5 1'b1;   // At time 5: x becomes 1
  x = #6 1'b0;   // At time 11: x becomes 0 (5+6)
  x = #7 1'b1;   // At time 18: x becomes 1 (11+7)
end
```

**Timeline for Blocking**:
```
Time:  0    5    11   18
x:     ?    1    0    1
       │    │    │    │
       │    └─5──┘    │
       │         └─6──┘
       └──────────7────┘
```

### Non-Blocking Assignment (`<=`)

**Syntax**: `variable <= value;`

**Characteristics**:
- **Schedules** assignments for future execution
- All assignments in a block are **evaluated simultaneously**
- Assignments happen **in parallel** at the end of the time step
- Used for **sequential logic** (flip-flops, registers)

**Example with Timing**:
```verilog
initial begin
  x <= #5 1'b1;  // Schedule: x = 1 at time 5
  x <= #6 1'b0;  // Schedule: x = 0 at time 6
  x <= #7 1'b1;  // Schedule: x = 1 at time 7
end
```

**Timeline for Non-Blocking**:
```
Time:  0    5    6    7
x:     ?    1    0    1
       │    │    │    │
       └─5──┘    │    │
       └──6──────┘    │
       └────7─────────┘
```

## Key Differences Summary

| Aspect | Blocking (`=`) | Non-Blocking (`<=`) |
|--------|----------------|---------------------|
| **Execution** | Sequential | Parallel |
| **Timing** | Immediate | Scheduled |
| **Next Statement** | Waits | Continues |
| **Use Case** | Combinational Logic | Sequential Logic |
| **Clock Domain** | Any procedural block | Always blocks with clocks |

## Practical Examples

### 1. Combinational Logic (Use Blocking)
```verilog
always @(*) begin
  temp = a & b;      // Execute first
  y = temp | c;      // Execute after temp is updated
end
```

### 2. Sequential Logic (Use Non-Blocking)
```verilog
always @(posedge clk) begin
  q1 <= d;           // All assignments happen
  q2 <= q1;          // simultaneously at clock edge
  q3 <= q2;          // Creates proper shift register
end
```

### 3. What Happens if You Mix Them Wrong?

**Wrong: Using Blocking in Sequential Logic**
```verilog
always @(posedge clk) begin
  q1 = d;    // q1 gets d immediately
  q2 = q1;   // q2 gets the NEW value of q1 (same as d)
  q3 = q2;   // q3 also gets d - NOT a shift register!
end
```

**Right: Using Non-Blocking in Sequential Logic**
```verilog
always @(posedge clk) begin
  q1 <= d;    // q1 scheduled to get d
  q2 <= q1;   // q2 scheduled to get OLD value of q1
  q3 <= q2;   // q3 scheduled to get OLD value of q2
end             // All assignments happen together - proper shift register
```

## Race Conditions

### Blocking Assignment Race
```verilog
// Block 1
always @(posedge clk) begin
  a = b;
end

// Block 2  
always @(posedge clk) begin
  b = a;
end
```
**Problem**: Order of execution is undefined - race condition!

### Non-Blocking Solution
```verilog
// Block 1
always @(posedge clk) begin
  a <= b;
end

// Block 2
always @(posedge clk) begin
  b <= a;
end
```
**Solution**: Both use old values, then update simultaneously - proper swap!

## Best Practices

1. **Use blocking (`=`) for combinational logic** in `always @(*)` blocks
2. **Use non-blocking (`<=`) for sequential logic** in `always @(posedge clk)` blocks
3. **Never mix blocking and non-blocking** in the same always block
4. **Use non-blocking for all clocked elements** (flip-flops, registers)
5. **Use blocking for temporary variables** in combinational logic

## Memory Aid

- **Blocking** = **Combinational** = **`=`** = **Immediate**
- **Non-Blocking** = **Sequential** = **`<=`** = **Scheduled**

## Common Mistakes to Avoid

1. Using blocking assignments in clocked always blocks
2. Using non-blocking assignments in combinational always blocks  
3. Mixing blocking and non-blocking in the same always block
4. Not understanding that non-blocking assignments are scheduled, not immediate

Understanding these concepts is crucial for writing reliable, synthesizable Verilog code that behaves correctly in both simulation and hardware!
