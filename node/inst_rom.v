`include "defines.v"

//指令存储器rom

module inst_rom(
    input  wire        ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus] inst
);

    reg[`InstBus] inst_mem[0:`InstMemNum-1];  // 数组深度至少为4（存放4条指令）

    // 从.hex文件加载机器码（路径需与inst_mem.v同目录）
    initial begin
        $readmemh("inst_rom.data", inst_mem);  // 自动将文件内容按顺序存入数组
    end


    //当复位信号无效时，依据输入的地址，给出指令存储器ROM中的对应元素
    always @(*) begin
        if (ce == `ChipDisable) begin
            inst <= `ZeroWord;
        end else begin
            inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
        end
    end
    //OpenMIPS按字节寻址，定义的指令存储器每个地址是32bit的字，将给出的指令地址除4
    //将指令地址右移两位，InstMemNumLog2是指令存储器的实际地址宽度

endmodule
