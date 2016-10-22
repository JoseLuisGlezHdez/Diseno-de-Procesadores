module uc (input wire clk, reset, z, input wire [5:0] opcode, output reg s_inc, s_inm, we3,fin , output reg [2:0] op);//Cambiams wire por reg

always @( * )//Posible fallo al no incluir reset
	casex (opcode)
		6'bxx0xxx: // Operación aritmética, cualquiera en la que el 4 bit
			   //menos significativo sea 0.
			begin					
				we3 <= 1'b1;	  // Activar escritura				
				op = opcode[2:0]; // El opcode que manda la Unidad de Control son los
						  // 3 primeros bits de opcode.
				s_inc <= 1'b1; 	  // Incrementa el PC en 1.
				s_inm <= 1'b0; 	  // Activa la salida de la ALU que pasa por el multiplexor 		  // al banco de registro
				fin <= 1'b0;	
			end

		6'bxx1000: // Carga de un valor inmediato en un registro.
			begin
				s_inc <= 1'b1;	 // Incrementa el PC en 1.
				s_inm <= 1'b1;	 // WA3 a banco de registro y Dato inmediato a WD3
				we3 <=1'b1;	 // Habilitar escritura
				op= 000;
				fin <= 1'b0;	
			end

		6'bxx1001: // Operación de salto absoluto incondicional
			begin
				s_inc <= 1'b0;	// Activa que la salida del multiplexor sea la 
						// que viene de [15:6] de datos. 
				s_inm <= 1'b0;	// Es trivial ya que no se va a usar la ALU ni se va a 			// cargar un valor inmediato.
				we3 <= 1'b0;	// No se va a escribir ningún dato en el banco de Registros.
				op=000;
				fin <= 1'b0;	
			end

		6'bxx1010: // Operación de salto condicional 0.
			begin
				//op=000;
				s_inm <= 1'b0;	 // Es trivial ya que no se va a usar la ALU ni se va a 			// cargar un valor inmediato.
				we3 <= 1'b0;	// No se va a escribir ningún dato en el banco de registros.
				if (z==0)	// 1 -> resultado op anterior 0
					s_inc <= 1'b0; 	// Salto a la instruccion en registro de direccion
				else
					s_inc <= 1'b1;	// Siguiente instruccion
				
				fin <= 1'b0;	
			end

		6'bxx1011: // Operación de salto condicional no 0
			begin
				s_inm <= 1'b0;// Es trivial ya que no se va a usar la ALU ni 
					      // se va a cargar un valor inmediato.
				we3 <= 1'b0;  // No se va a escribir en ningún dato en el banco de 			      // registros.
				if (z==0)	
				begin		
					s_inc <= 1'b1;	// Siguiente instruccion
					op=000;
					end
				else
					s_inc <= 1'b0;	// Salto a la siguiente
				
				fin <= 1'b0;	
				
			end

	  
		6'b111111: //Señal de fin
		    begin
			fin <= 1'b1;
		        s_inm<=1'b0;
			we3 <=1'b0;
			s_inc<=1'b0;
			op=000;
			
		    end
		default://Caso por defecto
		   begin
		   s_inm<=1'b0;
		   we3 <=1'b0;
		   s_inc<=1'b1;
		   op=000;
		   fin <= 1'b0;	
	       end
	endcase

endmodule
