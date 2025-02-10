*&---------------------------------------------------------------------*
*& Report ZR_STRING_SUBSTRING
*&---------------------------------------------------------------------*
*& " 1. ... substring( val = text [off = off] [len = len] ) ...
*
* - Tabela: zrestudo_produto
*      idproduto
*      idfornec
*      descricao
*      tipo_embalagem
*      embalagem
*      preco
*      quantidade
*&---------------------------------------------------------------------*
REPORT zr_string_substring NO STANDARD PAGE HEADING.

DATA: lt_produto TYPE TABLE OF ztestudo_produto,
      ls_produto TYPE ztestudo_produto,
      lt_string type TABLE OF string.

**********************************************************************

START-OF-SELECTION.
  PERFORM f_insert_data.
  PERFORM f_format_string.

**********************************************************************
FORM f_insert_data .

  CLEAR ls_produto.

  ls_produto-idproduto      = 1.
  ls_produto-idfornec       = 100.
  ls_produto-descricao      = 'Camiseta Algodão'.
  ls_produto-tipo_embalagem = 'Pacote'.
  ls_produto-embalagem      = 5.
  ls_produto-preco          = '79.90'.
  ls_produto-quantidade     = 50.

  APPEND ls_produto TO lt_produto.
  CLEAR ls_produto.

  ls_produto-idproduto      = 2.
  ls_produto-idfornec       = 200.
  ls_produto-descricao      = 'Calça Jeans'.
  ls_produto-tipo_embalagem = 'Caixa'.
  ls_produto-embalagem      = 2.
  ls_produto-preco          = '149.99'.
  ls_produto-quantidade     = 30.

  APPEND ls_produto TO lt_produto.
  CLEAR ls_produto.

  ls_produto-idproduto      = 3.
  ls_produto-idfornec       = 300.
  ls_produto-descricao      = 'Tênis Esportivo'.
  ls_produto-tipo_embalagem = 'Caixa'.
  ls_produto-embalagem      = 1.
  ls_produto-preco          = '299.90'.
  ls_produto-quantidade     = 20.

  APPEND ls_produto TO lt_produto.
  CLEAR ls_produto.

  ls_produto-idproduto      = 4.
  ls_produto-idfornec       = 400.
  ls_produto-descricao      = 'Boné Trucker'.
  ls_produto-tipo_embalagem = 'Pacote'.
  ls_produto-embalagem      = 3.
  ls_produto-preco          = '59.90'.
  ls_produto-quantidade     = 40.

  APPEND ls_produto TO lt_produto.
  CLEAR ls_produto.

ENDFORM.

FORM f_format_string .

ENDFORM.
