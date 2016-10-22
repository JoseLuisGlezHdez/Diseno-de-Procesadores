module microc(input wire clk, reset, s_inc, s_inm, we3, input wire [2:0] op, output wire z, output wire [5:0] opcode);//Esto queda como en el pdf, los reg vuelven a ser wire
//Microcontrolador sin memoria de datos de un solo ciclo

//Instanciar e interconectar pc, memprog, regfile, alu, sum y mux's
wire [9:0]  mux1;			// Salida del mux1 al PC.
wire [9:0]  dir;			// Salida del PC a la Memoria de Programa.
wire [9:0]  sumsal;			// Salida del sumador al PC.
wire [15:0] datos;			// Salida de la memoria de programa.
wire [7:0]  wd3;			// Salida del mux2 a al Banco de Registros.
wire [7:0]  alusal;			// Salida de la ALU al mux2.
wire [7:0]  rd1;			// Salida del Banco de Registros a la ALU.
wire [7:0]  rd2;			// Salida del Banco de Registros a la ALU.
wire 	    z_out;
wire 	    z_z;

memprog  memo(clk,dir,datos);
registro #(10) PC(clk,reset,mux1,dir);	
sum #(10) suma(dir,1,sumsal);
mux1 #(10) muxizq(datos[15:6],sumsal,s_inc,mux1);	
regfile #(8) banco(clk,we3,datos[7:4],datos[11:8],datos[15:12],wd3,rd1,rd2);
alu #(10) alualu(rd1,rd2,op,alusal,z_z);	
mux2 #(8) muxdch(alusal,datos[11:4],s_inm,wd3);	
registro_z #(8) reg_z(z_z, clk, z_out, op);

assign opcode=datos[5:0];
assign z=z_out;

endmodule
