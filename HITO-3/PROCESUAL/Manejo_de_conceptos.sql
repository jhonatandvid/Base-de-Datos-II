create database Manejo_de_conceptos;
use Manejo_de_conceptos
#manejo del concat
create function manejo_de_concat(cadena1 text,cadena2 text,cadena3 text)
returns text
begin
    declare resp text default ' ';
    set resp = concat(cadena1,cadena2,cadena3);
    return resp;
end;
select manejo_de_concat('manejo','de','concepto');
#manejo de substring
create function manejo_de_substring(cadena text)
returns text
begin
    declare resp text default ' ';
    declare cont int default locate(' ',cadena);
    set resp = substring(cadena,1,cont);
    return resp;
end;
select manejo_de_substring('ximena condori mar')
#7
create or replace function manejo_de_strcmp(cadena1 text,cadena2 text,cadena3 text)
returns text
begin
    declare resp text default ' ';
    if strcmp(cadena1,cadena2)=0 then
        set resp = '2 cadenas son iguales';
    else if strcmp(cadena2,cadena3)=0 then
        set resp = '2 cadenas son iguales';
        else if strcmp(cadena1,cadena3)=0 then
              set resp = '2 cadenas son iguales';

              else set resp = 'ninguno es igual';
        end if;
    end if;
    end if;
    return resp;
end;
select manejo_de_strcmp('bda','bd','bda');
#8
create or replace function manejo_de_locate(cadena text, letra char)
returns text
 begin
     declare resp text default ' ';
     declare cont int default 0;
     declare nVeces int default 0;
     declare puntero char;
     if locate(letra,cadena) > 0 then
         while cont <= char_length(cadena) do
             set puntero = substring(cadena,cont,1);
             if puntero = letra then
                 set nVeces = nVeces + 1 ;
             end if;
             set cont = cont + 1;
             end while;
         set resp = concat('en la cadena ',cadena,' la letra ', letra,' se repite ',nVeces);
     end if;
     return resp;
 end;
select manejo_de_locate('cadena','a')