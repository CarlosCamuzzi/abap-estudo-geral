*&---------------------------------------------------------------------*
*& Report ZR_ESTUDO_LOOP_FOR_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_ESTUDO_LOOP_FOR_02.

TYPES: BEGIN OF ty_pessoa,
         nome  TYPE string,
         idade TYPE i,
       END OF ty_pessoa.

DATA: lt_pessoas   TYPE TABLE OF ty_pessoa,
      lt_demaior   TYPE TABLE OF ty_pessoa,
      lt_uppercase TYPE TABLE OF ty_pessoa,
      ls_uppercase TYPE ty_pessoa.

lt_pessoas = VALUE #(
  ( nome = 'Renata' idade = 12 )
  ( nome = 'Fábio'  idade = 14 )
  ( nome = 'Júlia'  idade = 18 )
  ( nome = 'Paula'  idade = 22 )
  ( nome = 'Marcos' idade = 23 )
  ( nome = 'Maria'  idade = 17 )
).

" Vai percorrer cada linha da tabela lt_pessoas em ls_pessoa
" Fazendo o filtro com Where
" Após o filtro, é necessário passar os campos entre parênteses para de fato salvar na tabela
" Observar que o campo vai ser lido na work area: ls_pessoa
" É possível colocar mais cláusulas: WHERE ( idade >= 18 AND nome = 'Renata' )
lt_demaior = VALUE #(
  FOR ls_pessoa IN lt_pessoas
    WHERE ( idade >= 18   )
    ( nome = ls_pessoa-nome
      idade = ls_pessoa-idade )
).

"cl_demo_output=>display( lt_demaior ).

" Usando o LET
" LET cria uma variável interna que pode ser usada em cada loop
" Nesse caso:
" - Estamos iterando, filtrando a idade com where
" - Declara LET lv_nome e deixando o nome da pessoa em uppercase
" - IN: Finaliza o LET fazendo a atribuição da variável local alterada
"     para o nome que vai ser salvo na tabela lt_uppercase
lt_uppercase = VALUE #(
  FOR ls_pessoa IN lt_pessoas WHERE ( idade < 18 )
    LET lv_nome = to_upper( ls_pessoa-nome )
      IN nome = lv_nome
      ( idade = ls_pessoa-idade )
).

"cl_demo_output=>display( lt_uppercase ).

FREE: lt_uppercase.

" Esse código é equivalente ao for acima
LOOP AT lt_pessoas INTO DATA(wa_pessoa) WHERE idade < 18.
  ls_uppercase-nome = to_upper( wa_pessoa-nome ).
  ls_uppercase-idade = wa_pessoa-idade.
  APPEND ls_uppercase to lt_uppercase.
ENDLOOP.

cl_demo_output=>display( lt_uppercase ).
