program sudoku;
{$codepage UTF8} //Permite usar acentos y ñ en consola.
uses crt;
var
i, j: integer;
tabJuego: array[1..9, 1..9] of integer;
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
            tabJuego:=tab1;
        end;
        2: begin
            tabJuego:=tab2;
        end;
        3: begin
            tabJuego:=tab3;
        end;
        4: begin
            tabJuego:=tab4;
        end;
        5: begin
            tabJuego:=tab5;
        end;
    end;
end;

begin
    clrscr;
    elegirTablero();
    for i:=1 to 9 do
    begin
        for j:=1 to 9 do
        begin
            write(tabJuego[i, j], ' ');
        end;
        writeln('');
    end;
end.