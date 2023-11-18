program sudoku;
{$codepage UTF8} //Permite usar acentos y ñ en consola.
uses crt;
var
i, j, fJugadaInt, cJugadaInt, nJugadoInt: integer;
nombre, fJugada, cJugada, nJugado: string;
tabElegido, tabJuego: array[1..9, 1..9] of integer;
indexPistas: array[1..2, 1..17] of integer;
indexSubArray: array[1..2] of integer;
indexerror: array of integer;
a: char;
const
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
    case (ran) of
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
        repetido:=false;
        ranFila:=random(9)+1;
        ranColumna:=random(9)+1;
        for m:=1 to k do
        begin
            if(ranFila=indexPistas[m,1]) and (ranColumna=indexPistas[m,2]) then
            begin
                repetido:=true;
            end;
        end;
        if(not repetido) then
        begin
            indexPistas[k,1]:=ranFila;
            indexPistas[k,2]:=ranColumna;
            k+=1;
        end;
    until (k=18);
end;

function esPista(f,c: integer): boolean;
var indexp: integer;
begin
    esPista:=false;
    for indexp:=1 to 17 do
    begin
        if ((f=indexPistas[indexp,1]) and (c=indexPistas[indexp,2])) then
        begin
            esPista:=true;
            break;
        end;
    end;
end;

function esNumero(n: string; var nInt: integer): boolean;
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

procedure getSubArray();
var
rf, rc: real;
begin
    rf:= fJugadaInt/3;
    rc:= cJugadaInt/3;
    if (rf<=1) then
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
    if (rc<=1) then
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

function numeroValido(): boolean;
var m, n: integer;
begin
    numeroValido:=true;
    for m:=1 to 9 do
    begin
        if not (m=cJugadaInt) then
        begin
            if (tabJuego[fJugadaInt, m]=nJugadoInt) then
            begin
                numeroValido:=false;
                exit;
            end;
        end;
        if not (m=fJugadaInt) then
        begin
            if (tabJuego[m, cJugadaInt]=nJugadoInt) then
            begin
                numeroValido:=false;
                exit;
            end;
        end;
    end;
    getSubArray();
    for m:=indexSubArray[1] to indexSubArray[1]+2 do
    begin
        for n:=indexSubArray[2] to indexSubArray[2]+2 do
        begin
            if not ((m=fJugadaInt) and (n=cJugadaInt)) then
            begin
                if (tabJuego[m,n]=nJugadoInt) then
                begin
                    numeroValido:=false;
                    exit;
                end;
            end;
        end;
    end;
end;

procedure generarTableroInicial();
var
f, c, num: integer;
begin
    writeln('');
    writeln('  ||===|===|===||===|===|===||===|===|===||                Para rendirse, introduzca 0 en cualquier momento.');
    for f:=1 to 9 do
    begin
        write('  || ');
        for c:=1 to 9 do
        begin
            if esPista(f,c) then
            begin
                TextColor(3);
                num:=tabElegido[f,c];
            end
            else 
            begin
                TextColor(0);
                num:=0;
            end;
            tabJuego[f,c]:=num;
            if (c mod 3 = 0) then
            begin
                write(num); TextColor(15); write(' || ');
            end
            else begin
                write(num); TextColor(15); write(' | ');
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

procedure generarTableroJuego();
var
f, c: integer;
begin
    writeln('');
    writeln('  ||===|===|===||===|===|===||===|===|===||                Para rendirse, introduzca 0 en cualquier momento.');
    for f:=1 to 9 do
    begin
        write('  || ');
        for c:=1 to 9 do
        begin
            if esPista(f,c) then
            begin
                TextColor(3);
            end
            else begin
                if (tabJuego[f,c]=0) then
                begin
                    TextColor(0);
                end
                else begin
                    if (numeroValido()) then 
                    begin
                        TextColor(15);
                    end
                    else begin
                        TextColor(4);
                    end;
                end;
            end;
            if (c mod 3 = 0) then
            begin
                write(tabJuego[f,c]); TextColor(15); write(' || ');
            end
            else begin
                write(tabJuego[f,c]); TextColor(15); write(' | ');
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

procedure mostrarRespuesta();
var f, c: integer;
begin
    clrscr;
    writeln('La solucion del sudoku es la siguiente:');
    writeln('');
    writeln('  ||===|===|===||===|===|===||===|===|===||');
    for f:=1 to 9 do
    begin
        write('  || ');
        for c:=1 to 9 do
        begin
            if esPista(f,c) then
            begin
                TextColor(3);
            end;
            if (c mod 3 = 0) then
            begin
                write(tabElegido[f,c]); TextColor(15); write(' || ');
            end
            else begin
                write(tabElegido[f,c]); TextColor(15); write(' | ');
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
    writeln('¡Muchas gracias por jugar!');
    writeln('Presione cualquier tecla para salir...');
    readkey;
    halt(0);
end;

procedure comprobarCero(n: string; nInt: integer);
begin
    if esNumero(n, nInt) then
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

procedure solicitarElemento(var jugada: string; var jugadaInt: integer; p: integer);
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

begin
    clrscr;
    writeln('¡Bienvenido a SUDOKU!');
    writeln('Presione cualquier tecla para continuar...');
    readkey;
    repeat
        clrscr;
        write('Por favor ingrese su nickname de jugador: ');
        readln(nombre);
        if (nombre='') then
        begin
            writeln('Debe ingresar un nickname.');
            delay(2000);
        end;
    until not (nombre='');
    writeln('¡Hola, ', nombre, '! Te deseamos mucha suerte.');
    writeln('Presione cualquier tecla para jugar...');
    readkey;
    Randomize;
    elegirTablero();
    elegirPistas();
    generarTableroInicial();
    writeln('Presione cualquier tecla para empezar a jugar...');
    readkey;
    repeat
        repeat
            solicitarElemento(fJugada, fJugadaInt, 1);
            solicitarElemento(cJugada, cJugadaInt, 2);
            if (esPista(fJugadaInt, cJugadaInt)) then
            begin
                writeln('No puede modificar las casillas de pista.');
                delay(3000);
            end;
        until not (esPista(fJugadaInt, cJugadaInt));
        repeat
            solicitarElemento(nJugado, nJugadoInt, 3);
            tabJuego[fJugadaInt, cJugadaInt]:=nJugadoInt;
            if not numeroValido() then
            begin
                clrscr;
                generarTableroJuego();
                writeln('El número ingresado se repite en la misma fila, columna, o matriz de 3x3. Ingrese un valor válido.');
                writeln(nJugadoInt);
                write(indexSubArray[1], '    ', indexSubArray[2]);
                delay(3000);
            end;
        until numeroValido();
        a:=readkey;
    until a='q';
    readkey;
end.