program sudoku;
{$codepage UTF8} //Permite usar acentos y ñ en consola.
uses crt;
var
i, j: integer;
const
tab1: array[1..9, 1..9] of integer = ((3,7,9,2,1,5,4,6,8), (4,8,1,6,3,7,2,5,9), (2,5,6,8,4,9,1,3,7), (6,3,7,4,5,1,9,8,2), (8,9,2,7,6,3,5,1,4), (1,4,5,9,2,8,3,7,6), (5,2,4,1,7,6,8,9,3), (9,6,3,5,8,2,7,4,1), (7,1,8,3,9,4,6,2,5));
begin
    clrscr;
    for i:=1 to 9 do
    begin
        for j:=1 to 9 do
        begin
            write(tab1[i, j], ' ');
        end;
        writeln('');
    end;
end.