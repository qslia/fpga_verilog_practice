module dp_ram (
    clka,
    clkb,
    ada,
    adb,
    ina,
    inb,
    ena,
    enb,
    wea,
    web,
    outa,
    outb
);
    input clka, clkb, ena, wea, enb, web;
    input [2:0] ada, adb;
    input [7:0] ina, inb;
    output reg [7:0] outa, outb;
    reg [7:0] mem[0:7];
    initial begin
        outa = 8'b00000000;
        outb = 8'b00000000;
    end
    always @(posedge clka)
        if (ena) begin
            if (wea) mem[ada] = ina;
            else outa = mem[ada];
        end else outa = outa;
    always @(posedge clkb)
        if (enb) begin
            if (web) mem[adb] = inb;
            else outb = mem[adb];
        end else outb = outb;
endmodule
