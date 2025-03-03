*&---------------------------------------------------------------------*
*& Report zr_alv_04_insert_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_alv_04_insert_data NO STANDARD PAGE HEADING.

TABLES: vbap, vbak.

DATA: lt_material TYPE TABLE OF makt.
DATA: lt_pedido  TYPE TABLE OF zrs_alv_estudo_04.

DATA: ls_vbap TYPE vbap,
      ls_vbak TYPE vbak.

**********************************************************************

START-OF-SELECTION.
  "PERFORM f_insert_material.
  PERFORM f_insert_data.

**********************************************************************

FORM f_insert_material.
  lt_material = VALUE #(
   ( matnr = 'SB000001' spras = 'PT' maktx = 'PARAFUSO SEXTAVADO TOP' )
   ( matnr = 'SB000002' spras = 'PT' maktx = 'CADEADO BRONZE' )
   ( matnr = 'SB000003' spras = 'PT' maktx = 'CHAVE INGLESA' )
   ( matnr = 'SB000004' spras = 'PT' maktx = 'ALICATE EMBORRACHADO' )
   ( matnr = 'SB000005' spras = 'PT' maktx = 'PREGO 50UN' )
   ( matnr = 'SB000006' spras = 'PT' maktx = 'MAQUINA SOLDA' )
  ).

  LOOP AT lt_material INTO DATA(ls_material).
    INSERT makt FROM ls_material.
    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      MESSAGE: 'ERRO' TYPE 'E'.
      ROLLBACK WORK.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM f_insert_data.

  lt_pedido = VALUE #(
    ( vbeln = 'VD00000001'
      erdat = sy-datum
      erzet = sy-uzeit
      ernam = sy-uname
      waerk = 'BRL'
      posnr = 1
      matnr = 'SB000001'
      netwr = '10.25'
      werks = '0521'
      kunnr = '0010100014'
      name1 = 'PAYER - Zentrale Walldorf'
      regio = 'BW' )

    ( vbeln = 'VD00000002'
      erdat = sy-datum
      erzet = sy-uzeit
      ernam = sy-uname
      waerk = 'BRL'
      posnr = 2
      matnr = 'SB000002'
      netwr = '15.75'
      werks = '0521'
      kunnr = '0010100014'
      name1 = 'PAYER - Zentrale Walldorf'
      regio = 'BW' )

    ( vbeln = 'VD00000003'
      erdat = sy-datum
      erzet = sy-uzeit
      ernam = sy-uname
      waerk = 'BRL'
      posnr = 3
      matnr = 'SB000003'
      netwr = '20.50'
      werks = '0521'
      kunnr = '0010100014'
      name1 = 'PAYER - Zentrale Walldorf'
      regio = 'BW' )

    ( vbeln = 'VD00000004'
      erdat = sy-datum
      erzet = sy-uzeit
      ernam = sy-uname
      waerk = 'BRL'
      posnr = 4
      matnr = 'SB000004'
      netwr = '30.00'
      werks = '0521'
      kunnr = '0010100014'
      name1 = 'PAYER - Zentrale Walldorf'
      regio = 'BW' )

    ( vbeln = 'VD00000005'
      erdat = sy-datum
      erzet = sy-uzeit
      ernam = sy-uname
      waerk = 'BRL'
      posnr = 5
      matnr = 'SB000005'
      netwr = '12.90'
      werks = '0521'
      kunnr = '0010100014'
      name1 = 'PAYER - Zentrale Walldorf'
      regio = 'BW' )
  ).

  LOOP AT lt_pedido INTO DATA(ls_pedido).
    CLEAR: ls_vbak, ls_vbap.

    MOVE-CORRESPONDING ls_pedido TO ls_vbak.
*    ls_vbak-vbeln = ls_pedido-vbeln.
*    ls_vbak-erdat = ls_pedido-erdat.
*    ls_vbak-erzet = ls_pedido-erzet.
*    ls_vbak-ernam = ls_pedido-ernam.
*    ls_vbak-waerk = ls_pedido-waerk.
*    ls_vbak-kunnr = ls_pedido-kunnr.
    MODIFY vbak FROM ls_vbak.

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      MESSAGE 'ERRO VBAK' TYPE 'E'.
      ROLLBACK WORK.
    ENDIF.

    MOVE-CORRESPONDING ls_pedido TO ls_vbap.
*    ls_vbap-vbeln = ls_pedido-vbeln.
*    ls_vbap-posnr = ls_pedido-posnr.
*    ls_vbap-matnr = ls_pedido-matnr.
*    ls_vbap-netwr = ls_pedido-netwr.
*    ls_vbap-werks = ls_pedido-werks.
    MODIFY vbap FROM ls_vbap.

    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      MESSAGE 'ERRO VBAP' TYPE 'E'.
      ROLLBACK WORK.
    ENDIF.
  ENDLOOP.

ENDFORM.
