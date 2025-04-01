# pruebaTecnicaMercap

Ejercicio técnico para proceso de selección de Mercap.
Realizado en [CuisUniversity](https://sites.google.com/view/cuis-university).

La solución final se encuentra en el archivo [PruebaTecnicaMercap.st](https://github.com/asiciliani/pruebaTecnicaMercap/blob/main/PruebaTecnicaMercap.st).

Adicionalmente adjunto fileouts parciales por si interesa ver el progreso, como también los archivos de la imagen de Cuis que utilicé.

Comentarios:

- Tomo los horarios de inicio de llamada para computar las franjas, es decir, no me meto con la complejidad de que, por ejemplo, una llamada comience antes del horario laboral semanal pero termine después. Lo simplifico y lo calculo como que fue horario no laboral.

- En el mensaje outgoingCalls de TelephoneLine podria argumentarse que se rompe encapsulamiento, pero lo hago en pos de no agregarle logica de calculo de costos a la linea ya no que no tiene que ver con la esencia de este objeto.

- En el mensaje calculateTotalCost de TelephoneLineBill se podria argumentar que si agrego un tipo de llamada debo modificar este metodo, y que por lo tanto seria mejor sumar los costos de manera indistinta, pero creo que el hecho de que haya distintos tipos de llamada es esencial a la factura (por el enunciado), ya que entiendo que pide que se discriminen los costos, lo cual no se podria hacer si no se diferenciaran los tipos de estos. Por lo tanto tiene sentido tener que ademas modificar la factura si se agrega un nuevo tipo.

- No me meti demasiado con el modelado de como una linea llama a la otra (pues entiendo que el ejercicio apunta más a la facturación). Por lo tanto al hacer los llamados yo elijo la fecha y hora en la que se realizaron.

- Trate de tener en cuenta cuando se crea la linea para testear errores de, por ejemplo, no poder facturar una linea en un mes previo a su creación o en un mes que aún no terminó. Para no meterme con simular el paso del tiempo elegí alternativamente usar un mensaje de testing established: para setear a mano la fecha de creación. 

- Los tests 8, 9 y 10 podrían ser menos y la lógica para hacerlos pasar mas simple si hubiese usado la librería Chalten, pero opté por usar Date de Smalltalk para que sea más compatible con otras implementaciones del lenguaje.

- En conclusión respecto a los últimos puntos: no creo que esté hecho de la mejor manera el manejo del tiempo pero no quería dejar de hacer algo por si era relevante al ejercicio (ya que el punto 1 hace hincapie en que la facturación es mensual). Por otro lado, no quiero extenderme más intentando mejorarlo por lo que lo dejo como está.
