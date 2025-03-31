# pruebaTecnicaMercap

Comentarios:

- Tomo los horarios de inicio de llamada para computar las franjas, es decir, no me meto con la complejidad de que, por ejemplo, una llamada comience antes del horario laboral semanal pero termine después. Lo simplifico y lo calculo como que fue horario no laboral.

- En el mensaje outgoingCalls de TelephoneLine podria argumentarse que se rompe encapsulamiento, pero lo hago en pos de no agregarle logica de calculo de costos a la linea ya no que no tiene que ver con la esencia de este objeto.

- En el mensaje calculateTotalCost de TelephoneLineBill se podria argumentar que si agrego un tipo de llamada debo modificar este metodo, y que por lo tanto seria mejor sumar los costos de manera indistinta, pero creo que el hecho de que haya distintos tipos de llamada es esencial a la factura (por el enunciado), ya que entiendo que pide que se discriminen los costos, lo cual no se podria hacer si no se diferenciaran los tipos de estos. Por lo tanto tiene sentido tener que ademas modificar la factura si se agrega un nuevo tipo.
