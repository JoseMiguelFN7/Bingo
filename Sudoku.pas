program sudoku;
{$codepage UTF8} //Permite usar acentos y ñ en consola.
uses crt;
var
fJugadaInt, cJugadaInt, nJugadoInt: integer; //Fila, columna y numero ingresado por el usuario.
nombre, fJugada, cJugada, nJugado: string; //La fila, columna y numero se ingresan como string y despues se pasan a un integer despues de las validaciones.
tabElegido, tabJuego: array[1..9, 1..9] of integer; //Tablero prediseñado elegido y tablero que se usa durante el juego.
indexPistas: array[1..2, 1..17] of integer; //Indices de los numeros que seran usados como pistas.
indexSubArray, indexerror: array[1..2] of integer; //Indices de la primera posicion de cada subarreglo 3x3 e indices de la posicion del numero que se repite.
const
//Tableros prediseñados.
tab1: array[1..9, 1..9] of integer = ((3,7,9,2,1,5,4,6,8), (4,8,1,6,3,7,2,5,9), (2,5,6,8,4,9,1,3,7), (6,3,7,4,5,1,9,8,2), (8,9,2,7,6,3,5,1,4), (1,4,5,9,2,8,3,7,6), (5,2,4,1,7,6,8,9,3), (9,6,3,5,8,2,7,4,1), (7,1,8,3,9,4,6,2,5));
tab2: array[1..9, 1..9] of integer = ((6,9,5,2,7,8,3,1,4), (3,4,1,5,9,6,7,2,8), (2,8,7,1,3,4,5,6,9), (1,2,4,6,8,3,9,7,5), (5,6,3,9,2,7,4,8,1), (9,7,8,4,5,1,6,3,2), (7,3,2,8,4,5,1,9,6), (8,5,6,7,1,9,2,4,3), (4,1,9,3,6,2,8,5,7));
tab3: array[1..9, 1..9] of integer = ((1,3,5,6,2,7,4,8,9), (8,4,9,3,1,5,2,6,7), (2,6,7,8,4,9,1,3,5), (6,8,1,5,3,4,9,7,2), (4,5,3,9,7,2,8,1,6), (7,9,2,1,6,8,5,4,3), (3,2,6,4,5,1,7,9,8), (9,7,4,2,8,3,6,5,1), (5,1,8,7,9,6,3,2,4));
tab4: array[1..9, 1..9] of integer = ((2,3,6,4,1,5,7,8,9), (5,8,9,6,2,7,1,3,4), (1,4,7,8,3,9,2,5,6), (7,5,2,3,4,1,9,6,8), (6,9,8,7,5,2,3,4,1), (3,1,4,9,6,8,5,2,7), (4,6,5,1,7,3,8,9,2), (9,7,3,2,8,4,6,1,5), (8,2,1,5,9,6,4,7,3));
tab5: array[1..9, 1..9] of integer = ((3,4,6,1,2,5,7,8,9), (5,8,9,6,3,7,1,2,4), (1,2,7,8,4,9,3,5,6), (8,3,1,4,5,2,6,9,7), (9,6,5,7,1,3,8,4,2), (2,7,4,9,6,8,5,1,3), (6,9,8,2,7,1,4,3,5), (7,5,2,3,8,4,9,6,1), (4,1,3,5,9,6,2,7,8));

procedure elegirTablero(); //Procedimiento para elegir el tablero de juego.
var
ran: integer;
begin
    Randomize;
    ran:=random(5)+1; //Genera un numero random entre 1 y 5.
    case (ran) of //El numero generado determina el tablero que se usara.
        1: begin
            tabElegido:=tab1;
        end;
        2: begin
            tabElegido:=tab2;
        end;
        3: begin
            tabElegido:=tab3;
        end;
        4: begin
            tabElegido:=tab4;
        end;
        5: begin
            tabElegido:=tab5;
        end;
    end;
end;

procedure elegirPistas(); //Genera los indexs de las pistas que se van a mostrar
var 
ranFila, ranColumna, k, m: integer;
repetido: boolean;
begin
    k:=1;
    repeat
        repetido:=false; //Booleano que se usa para asegurarse de que no se guarde la misma posicion en el arreglo 2 veces.
        ranFila:=random(9)+1; //Genera un numero random entre 1 y 9, sera el indice aleatorio de la fila.
        ranColumna:=random(9)+1; //Genera un numero random entre 1 y 9, sera el indice aleatorio de la columna.
        for m:=1 to k do
        begin
            if(ranFila=indexPistas[m,1]) and (ranColumna=indexPistas[m,2]) then //Si ese juego de indices (f/c) ya esta en el arreglo
            begin                                                               //se intercambia por otro aleatorio hasta conseguir uno
                repetido:=true;                                                 //que no este en el arreglo de indexs.
            end;
        end;
        if(not repetido) then
        begin
            indexPistas[k,1]:=ranFila;
            indexPistas[k,2]:=ranColumna;
            k+=1; //El contador aumenta cuando los indices no se repiten.
        end;
    until (k=18); //Para que se agreguen solo 17 pares de filas y columnas.
end;

function esPista(f,c: integer): boolean; //Para determinar si una posicion del tablero es una pista (Se usa en los procedimientos que generan tableros)
var indexp: integer;
begin
    esPista:=false;
    for indexp:=1 to 17 do
    begin
        if ((f=indexPistas[indexp,1]) and (c=indexPistas[indexp,2])) then //Si los indices coinciden con los que estan en el arreglo de indices, es una pista.
        begin
            esPista:=true;
            break;
        end;
    end;
end;

function esNumero(n: string; var nInt: integer): boolean; //Para validar que el dato ingresado es un numero.
var error: integer;
begin
    esNumero:=true;
    val(n, nInt, error);
    if (error<>0) then
    begin
        esNumero:= false;
        exit;
    end;
    if ((nInt<0) or (nInt>9)) then
    begin
        esNumero:= false;
    end;
end;

procedure getSubArray(); //Para determinar los indices para la posicion del primer elemento en el subarray de 3x3.
var
rf, rc: real;
begin
    rf:= fJugadaInt/3;
    rc:= cJugadaInt/3;
    if (rf<=1) then //Para determinar la fila.
    begin
        indexSubArray[1]:=1;
    end
    else begin
        if (rf<=2) then
        begin
            indexSubArray[1]:=4;
        end
        else begin
            if (rf<=3) then
            begin
                indexSubArray[1]:=7;
            end
        end;
    end;
    if (rc<=1) then //Para determinar la columna.
    begin
        indexSubArray[2]:=1;
    end
    else begin
        if (rc<=2) then
        begin
            indexSubArray[2]:=4;
        end
        else begin
            if (rc<=3) then
            begin
                indexSubArray[2]:=7;
            end
        end;
    end;
end;

function numeroValido(): boolean; //Para determinar si el numero se repite en la fila, columna o subarreglo 3x3.
var m, n: integer;
begin
    numeroValido:=true;
    for m:=1 to 9 do
    begin
        if not (m=cJugadaInt) then //Para no chequear la posicion donde se esta ingresando el numero.
        begin
            if (tabJuego[fJugadaInt, m]=nJugadoInt) then //Si se repite en la fila, no es valido.
            begin
                numeroValido:=false;
                exit;
            end;
        end;
        if not (m=fJugadaInt) then //Para no chequear la posicion donde se esta ingresando el numero.
        begin
            if (tabJuego[m, cJugadaInt]=nJugadoInt) then //Si se repite en la columna, no es valido.
            begin
                numeroValido:=false;
                exit;
            end;
        end;
    end;
    getSubArray(); //Consigue la primera posicion del 3x3 en el tablero.
    for m:=indexSubArray[1] to indexSubArray[1]+2 do
    begin
        for n:=indexSubArray[2] to indexSubArray[2]+2 do
        begin
            if not ((m=fJugadaInt) and (n=cJugadaInt)) then //Para no chequear la posicion donde se esta ingresando el numero.
            begin
                if (tabJuego[m,n]=nJugadoInt) then //Si se repite en el 3x3, no es valido.
                begin
                    numeroValido:=false;
                    exit;
                end;
            end;
        end;
    end;
end;

procedure generarTableroInicial(); //Genera el tablero vacio con las pistas al inicio del juego.
var
f, c, num: integer;
begin
    clrscr;
    writeln('                                                          |---------------------------------------------------|');
    writeln('                                                          | Para rendirse, introduzca 0 en cualquier momento. |');
    writeln('                                                          |---------------------------------------------------|');
    writeln('  ||===|===|===||===|===|===||===|===|===||');
    for f:=1 to 9 do
    begin
        write('  || ');
        for c:=1 to 9 do
        begin
            if esPista(f,c) then
            begin
                TextColor(3); //Si la posicion es una pista, se imprime en cyan.
                num:=tabElegido[f,c]; //Se guarda la pista en una variable para guardarla en el tablero de juego e imprimirla.
            end
            else 
            begin
                TextColor(0); //Si esta vacio, contiene un cero de color negro.
                num:=0; //se guardara cero en el tablero de juego y se imprimira en esa posicion.
            end;
            tabJuego[f,c]:=num; //Se guarda el numero elegido en esa posicion.
            if (c mod 3 = 0) then
            begin
                write(num); TextColor(15); write(' || '); //Se resetea el color a blanco para imprimir las otras partes del tablero.
            end
            else begin
                write(num); TextColor(15); write(' | '); //Se resetea el color a blanco para imprimir las otras partes del tablero.
            end;
        end;
        writeln('');
        if (f mod 3 = 0) then
        begin
            writeln('  ||===|===|===||===|===|===||===|===|===||');
        end
        else writeln('  ||---|---|---||---|---|---||---|---|---||');
    end;
    writeln('');
end;

procedure generarTableroJuego(); //Genera el tablero con los valores que van siendo ingresados.
var
f, c: integer;
begin
    writeln('                                                          |---------------------------------------------------|');
    writeln('                                                          | Para rendirse, introduzca 0 en cualquier momento. |');
    writeln('     1   2   3    4   5   6    7   8   9                  |---------------------------------------------------|');
    writeln('  ||===|===|===||===|===|===||===|===|===||');
    for f:=1 to 9 do
    begin
        write('  || ');
        for c:=1 to 9 do
        begin
            if esPista(f,c) then
            begin
                TextColor(3); //Si es pista, se imprime de color cyan.
            end
            else begin
                if (tabJuego[f,c]=0) then
                begin
                    TextColor(0); //Si es cero, se imprime de color negro.
                end
                else begin
                    if ((f=indexerror[1]) and (c=indexerror[2])) then 
                    begin
                        TextColor(4); //Si el numero se repite, se imprime de color rojo.
                    end
                    else begin
                        TextColor(15); //Si es un numero valido ingresado por el usuario, se imprime de color blanco.
                    end;
                end;
            end;
            if (c mod 3 = 0) then
            begin
                write(tabJuego[f,c]); TextColor(15); write(' || '); //Se resetea el color a blanco para imprimir las otras partes del tablero.
            end
            else begin
                write(tabJuego[f,c]); TextColor(15); write(' | '); //Se resetea el color a blanco para imprimir las otras partes del tablero.
            end;
        end;
        writeln(f);
        if (f mod 3 = 0) then
        begin
            writeln('  ||===|===|===||===|===|===||===|===|===||');
        end
        else writeln('  ||---|---|---||---|---|---||---|---|---||');
    end;
end;

procedure mostrarRespuesta(); //Si el usuario se rinde, se muestra el tablero elegido completado.
var f, c: integer;
begin
    clrscr;
    writeln('');
    writeln('  |-----------------------------------------|');
    writeln('  | La solucion del sudoku es la siguiente: |');
    writeln('  |-----------------------------------------|');
    writeln('');
    writeln('  ||===|===|===||===|===|===||===|===|===||');
    for f:=1 to 9 do
    begin
        write('  || ');
        for c:=1 to 9 do
        begin
            if esPista(f,c) then
            begin
                TextColor(3); //Si es pista, se imprime de color cyan.
            end;
            if (c mod 3 = 0) then
            begin
                write(tabElegido[f,c]); TextColor(15); write(' || '); //Se resetea el color a blanco para imprimir las otras partes del tablero.
            end
            else begin
                write(tabElegido[f,c]); TextColor(15); write(' | '); //Se resetea el color a blanco para imprimir las otras partes del tablero.
            end;
        end;
        writeln('');
        if (f mod 3 = 0) then
        begin
            writeln('  ||===|===|===||===|===|===||===|===|===||');
        end
        else writeln('  ||---|---|---||---|---|---||---|---|---||');
    end;
    writeln('');
    writeln('  |------------------------------------------|');
    writeln('  |        ¡Muchas gracias por jugar!        |');
    writeln('  |------------------------------------------|');
    writeln('  |  Presione cualquier tecla para salir...  |');
    writeln('  |------------------------------------------|');
    readkey;
    halt(0);
end;

procedure comprobarCero(n: string; nInt: integer); //Comprueba si el numero ingresado es un cero, para saber si el jugador se rindio.
begin
    if esNumero(n, nInt) then //En este procedimiento tambien se comprueba si el numero ingresado no es una letra o caracter especial.
    begin
        if nInt=0 then
        begin
            mostrarRespuesta();
        end;
    end
    else begin
        writeln('  |------------------------------------------------------------------------|');
        writeln('  |                    El dato ingresado no es válido.                     |');
        writeln('  |------------------------------------------------------------------------|');
        delay(2000);
    end;
end;

procedure solicitarElemento(var jugada: string; var jugadaInt: integer; p: integer); //Para solicitar la fila, columna y numero a jugar.
begin
    repeat
        clrscr;
        generarTableroJuego();
        writeln('  |------------------------------------------------------------------------|');
        case (p) of
            1: begin
                writeln('  |  Indique el número de la fila de la casilla que desea jugar (1-9):     |');
            end;
            2: begin
                writeln('  |  Indique el número de la columna de la casilla que desea jugar (1-9):  |');
            end;
            3: begin
                writeln('  |  Indique el número que desea ingresar en el tablero (1-9):             |');
            end;
        end;
        writeln('  |------------------------------------------------------------------------|');
        write('  |-> ');
        readln(jugada);
        gotoXY(76, WhereY-1); writeln('|');
        comprobarCero(jugada, jugadaInt);
    until esNumero(jugada, jugadaInt);
end;

function ComprobarTabCompletado(): boolean; //Para comprobar si el tablero fue completado.
var
i,j: integer;
begin 
	ComprobarTabCompletado:= true;
	for i:= 1 to 9 do
	begin
		for j:= 1 to 9 do
		begin
			if tabJuego[i,j]= 0 then //Si se consigue un cero, hay casillas vacias.
            begin
				ComprobarTabCompletado:= false;
				break;
            end;
		end;
	end;
end;

function validarNombre(): boolean; //Para comprobar si el nickname no esta vacio o tiene espacios.
var i: integer;
begin
    validarNombre:= true;
    if nombre='' then
    begin
        validarNombre:= false;
        writeln('  | Debe ingresar un nickname.                          |');
        writeln('  |-----------------------------------------------------|');
        delay(2000);
        exit;
    end;
    for i:=1 to length(nombre) do
    begin
        if nombre[i]=' ' then
        begin
            validarNombre:= false;
            writeln('  | El nickname no puede contener espacios.             |');
            writeln('  |-----------------------------------------------------|');
            delay(2000);
            break;
        end;
    end;
end;

begin
    clrscr;
    writeln('');
    writeln('  ||============================================||');
    writeln('  ||            ¡Bienvenido a SUDOKU!           ||');
    writeln('  ||--------------------------------------------||');
    writeln('  || Presione cualquier tecla para continuar... ||');
    writeln('  ||============================================||');
    readkey;
    repeat
        clrscr;
        writeln('');
        writeln('  |-----------------------------------------------------|');
        writeln('  | Por favor ingrese su nickname de jugador:           |');
        writeln('  |-----------------------------------------------------|');
        write('  |-> ');
        readln(nombre); gotoXY(57, WhereY-1); writeln('|');
        writeln('  |-----------------------------------------------------|');
    until validarNombre();
    writeln('  | ¡Hola, ', nombre, '! Te deseamos mucha suerte.'); gotoXY(57, WhereY-1); writeln('|');
    writeln('  |-----------------------------------------------------|');
    writeln('  | Presione cualquier tecla para continuar...'); gotoXY(57, WhereY-1); writeln('|');
    writeln('  |-----------------------------------------------------|');
    readkey;
    Randomize; //Para randomizar todos los generadores de numeros.
    elegirTablero();
    elegirPistas();
    generarTableroInicial();
    writeln('  |-----------------------------------------------------|');
    writeln('  | Presione cualquier tecla para empezar a jugar...    |');
    writeln('  |-----------------------------------------------------|');
    readkey;
    repeat
        repeat
            solicitarElemento(fJugada, fJugadaInt, 1);
            solicitarElemento(cJugada, cJugadaInt, 2);
            if (esPista(fJugadaInt, cJugadaInt)) then
            begin
                writeln('  |------------------------------------------------------------------------|');
                writeln('  | No puede modificar las casillas de pista.                              |');
                writeln('  |------------------------------------------------------------------------|');
                delay(3000);
            end;
        until not (esPista(fJugadaInt, cJugadaInt)); //Pide fila y columna hasta que se indique una posicion que no sea de una pista.
        repeat
            solicitarElemento(nJugado, nJugadoInt, 3);
            tabJuego[fJugadaInt, cJugadaInt]:=nJugadoInt;
            indexerror[1]:=0;
            indexerror[2]:=0;
            if not numeroValido() then
            begin
                clrscr;
                indexerror[1]:=fJugadaInt;
                indexerror[2]:=cJugadaInt;
                generarTableroJuego();
                writeln('  |------------------------------------------------------------------------|');
                writeln('  | El número se repite en la misma fila, columna, o matriz de 3x3.        |');
                writeln('  |------------------------------------------------------------------------|');
                writeln('  | Ingrese un valor válido.                                               |');
                writeln('  |------------------------------------------------------------------------|');
                delay(3000);
            end;
        until numeroValido(); //Se pide el numero hasta que se agregue uno que no se repite.
    until ComprobarTabCompletado(); //El juego termina cuando el tablero se completa.
    clrscr;
    generarTableroJuego(); //Genera el tablero completado.
    writeln('  |--------------------------------------------------------------|');
    writeln('  | ¡Felicidades ', nombre, ', haz completado el sudoku!'); gotoXY(66, WhereY-1); writeln('|');
    writeln('  |--------------------------------------------------------------|');
    readkey;
end.