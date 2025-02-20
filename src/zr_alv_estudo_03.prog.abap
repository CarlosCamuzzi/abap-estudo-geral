*&---------------------------------------------------------------------*
*& Report ZR_ALV_ESTUDO_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_ALV_ESTUDO_03.

DATA: lt_data    TYPE TABLE OF mara,
      lt_fieldcat TYPE slis_t_fieldcat_alv,
      lt_events  TYPE slis_t_event,
      ls_event   TYPE slis_alv_event.

" Preencher a tabela interna com dados
SELECT * FROM mara INTO TABLE lt_data.

" Definir o catálogo de campos
PERFORM build_fieldcat.

" Definir eventos
ls_event-name = 'TOOLBAR'.
ls_event-form = 'ALV_TOOLBAR'.
APPEND ls_event TO lt_events.

ls_event-name = 'USER_COMMAND'.
ls_event-form = 'HANDLE_USER_COMMAND'.
APPEND ls_event TO lt_events.

TRY .
  " Exibir o ALV
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat   = lt_fieldcat
    it_events     = lt_events
  TABLES
    t_outtab      = lt_data.


    CATCH cx_root INTO DATA(lo_excp).
      WRITE: / 'Erro capturado:', lo_excp->get_text( ).

ENDTRY.


FORM build_fieldcat.
  DATA: ls_fieldcat TYPE slis_fieldcat_alv.

  ls_fieldcat-fieldname = 'CAMPO1'.
  ls_fieldcat-seltext_m = 'Campo 1'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-fieldname = 'CAMPO2'.
  ls_fieldcat-seltext_m = 'Campo 2'.
  APPEND ls_fieldcat TO lt_fieldcat.
ENDFORM.

FORM alv_toolbar CHANGING it_toolbar TYPE ttb_button.
  DATA: st_toolbar TYPE stb_button.

  TYPE-POOLS icon.

  st_toolbar-butn_type = 3.  " Separador
  APPEND st_toolbar TO it_toolbar.

  st_toolbar-function = 'PRINT'.
  st_toolbar-icon = icon_print.
  st_toolbar-quickinfo = 'Imprimir Romaneio'.
  st_toolbar-butn_type = 0.
  st_toolbar-text = 'Imprimir Romaneio'.
  st_toolbar-disabled = ''.
  APPEND st_toolbar TO it_toolbar.

  st_toolbar-butn_type = 3.  " Separador
  APPEND st_toolbar TO it_toolbar.
ENDFORM.

FORM handle_user_command USING ucomm LIKE sy-ucomm
                               selfield TYPE slis_selfield.
  CASE ucomm.
    WHEN 'PRINT'.
      PERFORM imprimir_romaneio.
    WHEN OTHERS.
      " Outras ações
  ENDCASE.
ENDFORM.

FORM imprimir_romaneio.
  " Lógica para imprimir o romaneio
  MESSAGE 'Romaneio impresso com sucesso!' TYPE 'S'.
ENDFORM.
