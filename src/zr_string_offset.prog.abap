*&---------------------------------------------------------------------*
*& Report zr_string_offset
*&---------------------------------------------------------------------*
* Exercício:
*
* "Produto: Notebook, Preço: 2500.00, Quantidade: 10; Produto: Smartphone,
* Preço: 1500.00, Quantidade: 20; Produto: Tablet, Preço: 1200.00, Quantidade: 15"
*
* -  Use a função find() para localizar as posições das palavras-chave
*     "Produto:", "Preço:" e "Quantidade:" em cada bloco de produto.
*
* - Extraia o nome do produto, o preço e a quantidade de cada bloco.

* - Exiba os resultados no seguinte formato:
*     Produto: Notebook, Preço: 2500.00, Quantidade: 10
*     Produto: Smartphone, Preço: 1500.00, Quantidade: 20
*     Produto: Tablet, Preço: 1200.00, Quantidade: 15
*
*&---------------------------------------------------------------------*

REPORT zr_string_offset NO STANDARD PAGE HEADING.

DATA: lv_offset     TYPE i,
      lv_start      TYPE i,
      lv_end        TYPE i,
      lv_string     TYPE string,
      lv_produto    TYPE string,
      lv_quantidade TYPE string,
      lv_preco      TYPE string.

DATA: lt_produtos  TYPE STANDARD TABLE OF string,
      lt_resultado TYPE STANDARD TABLE OF string.

lv_string = 'Produto: Notebook,'   &&
            'Preço: 2500.00,'      &&
            'Quantidade: 10;'      &&
            'Produto: Smartphone,' &&
            'Preço: 1500.00,'      &&
            'Quantidade: 20;'      &&
            'Produto: Tablet,'     &&
            'Preço: 1200.00,'      &&
            'Quantidade: 15'.


SPLIT lv_string AT ';' INTO TABLE lt_produtos.

LOOP AT lt_produtos INTO DATA(ls_line).

  CONDENSE ls_line.

  " Comentários ref ao primeiro loop
  lv_offset = find( val = lv_string sub = 'Produto:' ). " 0
  DATA(lv_tam) = strlen('Produto: ').

  IF lv_offset >= 0.                                   " Extrai o nome do produto
    lv_start = lv_offset + strlen( 'Produto:' ).  " 0 + 8 = 8
    lv_end = find( val = ls_line sub = ',' occ = 1 ).      " 17
    lv_produto = substring( val = ls_line off = lv_start len = lv_end - lv_start ).  " start 8, tamanho 17 - 8 = 9
  ENDIF.

  lv_offset = find( val = lv_string sub = 'Preço:' ).   " 18

  IF lv_offset >= 0.                                  " Extrai o preço
    lv_start = lv_offset + strlen( 'Preço:' ).     " 18 + 6 = 24
    lv_end = find( val = ls_line sub = ',' occ = 2 ).   " 32
    lv_preco  = substring( val = ls_line off = lv_start len = lv_end - lv_start ). " start 24, tamanho 32 - 24 = 9
  ENDIF.

  lv_offset = find( val = lv_string sub = 'Quantidade:' ).  " 33

  IF lv_offset >= 0.                                   " Extrai a quantidade
    lv_start = lv_offset + strlen( 'Quantidade:' ).    " 33 + 11 = 44
    lv_quantidade = substring( val = ls_line off = lv_start ). " start 44 até o final
    " Aqui vai até o final, pois estamos na linha da tabela

    "Obs.:
    " Não precisa de end para o len, pois estamos extraindo o valor final (até o final da linha).
    " Dessa forma, o len é dispensável
    "lv_end = find( val = ls_line sub = ',' ).
  ENDIF.

  DATA(ls_item) = |Produto:{ lv_produto } Quantidade:{ lv_quantidade } Preço:{ lv_preco }|.
  APPEND ls_item TO lt_resultado.

ENDLOOP.

LOOP AT lt_resultado INTO DATA(ls_resultado).
  WRITE:/ ls_resultado.
ENDLOOP.
