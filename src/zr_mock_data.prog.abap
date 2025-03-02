*&---------------------------------------------------------------------*
*& Report ZR_MOCK_DATA
*&---------------------------------------------------------------------*
*& TESTES Para ALV
*&---------------------------------------------------------------------*
REPORT zr_mock_data.

" Structure Types:
*TYPES: BEGIN OF ty_order,
*         gstrp TYPE afko-gstrp, " sy-datum
*         gltrp TYPE afko-gltrp, " sy-datum
*         bukrs TYPE aufk-bukrs, " char4
*         aufnr TYPE aufk-aufnr, " char12
*         auart TYPE aufk-auart, " char4
*         vaplz TYPE aufk-vaplz, " char8
*         ktext TYPE aufk-ktext, " char40
*         equnr TYPE itob-equnr, " char18
*         erdat TYPE aufk-erdat, " sy-datum
*         tplnr TYPE iflo-tplnr, " char30
*       END OF ty_order.

*DATA: lt_input TYPE TABLE OF ty_order,
*      ls_input TYPE ty_order,
*      ls_afko  TYPE afko,
*      ls_aufk  TYPE aufk,
*      ls_itob  TYPE itob,
*      ls_iflo  TYPE iflo.
*
*
*types: BEGIN OF ty_equi,
*    equnr type equi-equnr,
*  end of ty_equi.
*
*  data: lt_equi type TABLE OF ty_equi,
*        ls_equi type ty_equi.

**********************************************************************

*START-OF-SELECTION.
*  PERFORM f_input_data.
*
*END-OF-SELECTION.

**********************************************************************
"FORM f_input_data .
*  ls_equi-equnr = '10000600'.
*  ls_equi-bukrs = '1101'.
*  ls_equi-ktext = 'Congelamento de Ar'.
*  "APPEND ls_equi to lt_equi.
*
*  MODIFY equi FROM ls_equi.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro EQUI' TYPE 'E'.
*  ENDIF.
*
*  ls_equi-equnr = '100000500'.
*  ls_equi-bukrs = '1101'.
*  ls_equi-ktext = 'Problema na bomba de dreno'.
*  "APPEND ls_equi to lt_equi.
*
*    MODIFY equi FROM ls_equi.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro EQUI' TYPE 'E'.
*  ENDIF.
*
*  ls_equi-equnr = '10000300'.
*  ls_equi-bukrs = '1101'.
*  ls_equi-ktext = 'Troca de Compressor'.
*  "APPEND ls_equi to lr_equi.
*
*    MODIFY equi FROM ls_equi.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro EQUI' TYPE 'E'.
*  ENDIF.
*

*  ls_input-gstrp = sy-datum.
*  ls_input-gltrp = sy-datum + 10.
*  ls_input-bukrs = '1101'.
*  ls_input-aufnr = '4000000005'.
*  ls_input-auart = 'PM05'.
*  ls_input-vaplz = 'ASSELBLE'.
*  ls_input-ktext = 'Congelamento de Ar'.
*  ls_input-equnr = '10000600'.
*  ls_input-erdat = sy-datum.
*  ls_input-tplnr = '200801'.
*
*  ls_afko-aufnr = ls_input-aufnr.
*  ls_afko-gstrp = ls_input-gstrp.
*  ls_afko-gltrp = ls_input-gltrp.
*  ls_aufk-bukrs = ls_input-bukrs.
*  ls_aufk-aufnr = ls_input-aufnr.
*  ls_aufk-auart = ls_input-auart.
*  ls_aufk-vaplz = ls_input-vaplz.
*  ls_aufk-ktext = ls_input-ktext.
*  ls_itob-aufnr = ls_input-aufnr.
*  ls_itob-equnr = ls_input-equnr.
*  ls_aufk-erdat = ls_input-erdat.
*  ls_iflo-aufnr = ls_input-aufnr.
*  ls_iflo-tplnr = ls_input-tplnr.
*
*  MODIFY aufk FROM ls_aufk.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro AUFK' TYPE 'E'.
*  ENDIF.
*
*  MODIFY afko FROM ls_afko.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro AFKO' TYPE 'E'.
*  ENDIF.
*
*    ls_input-gstrp = sy-datum.
*  ls_input-gltrp = sy-datum + 10.
*  ls_input-bukrs = '1101'.
*  ls_input-aufnr = '4000000004'.
*  ls_input-auart = 'PM01'.
*  ls_input-vaplz = 'ASSELBLE'.
*  ls_input-ktext = 'Problema na bomba de dreno'.
*  ls_input-equnr = '10000500'.
*  ls_input-erdat = sy-datum.
*  ls_input-tplnr = '305001'.
*
*  ls_afko-aufnr = ls_input-aufnr.
*  ls_afko-gstrp = ls_input-gstrp.
*  ls_afko-gltrp = ls_input-gltrp.
*  ls_aufk-bukrs = ls_input-bukrs.
*  ls_aufk-aufnr = ls_input-aufnr.
*  ls_aufk-auart = ls_input-auart.
*  ls_aufk-vaplz = ls_input-vaplz.
*  ls_aufk-ktext = ls_input-ktext.
*  ls_itob-aufnr = ls_input-aufnr.
*  ls_itob-equnr = ls_input-equnr.
*  ls_aufk-erdat = ls_input-erdat.
*  ls_iflo-aufnr = ls_input-aufnr.
*  ls_iflo-tplnr = ls_input-tplnr.
*
*  MODIFY aufk FROM ls_aufk.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro AUFK' TYPE 'E'.
*  ENDIF.
*
*  MODIFY afko FROM ls_afko.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro AFKO' TYPE 'E'.
*  ENDIF.
*
*     ls_input-gstrp = sy-datum.
*  ls_input-gltrp = sy-datum + 10.
*  ls_input-bukrs = '1101'.
*  ls_input-aufnr = '4000000002'.
*  ls_input-auart = 'PM02'.
*  ls_input-vaplz = 'ASSELBLE'.
*  ls_input-ktext = 'Troca de Compressor'.
*  ls_input-equnr = '10000300'.
*  ls_input-erdat = sy-datum.
*  ls_input-tplnr = '100055'.
*
*  ls_afko-aufnr = ls_input-aufnr.
*  ls_afko-gstrp = ls_input-gstrp.
*  ls_afko-gltrp = ls_input-gltrp.
*  ls_aufk-bukrs = ls_input-bukrs.
*  ls_aufk-aufnr = ls_input-aufnr.
*  ls_aufk-auart = ls_input-auart.
*  ls_aufk-vaplz = ls_input-vaplz.
*  ls_aufk-ktext = ls_input-ktext.
*  ls_itob-aufnr = ls_input-aufnr.
*  ls_itob-equnr = ls_input-equnr.
*  ls_aufk-erdat = ls_input-erdat.
*  ls_iflo-aufnr = ls_input-aufnr.
*  ls_iflo-tplnr = ls_input-tplnr.
*
*  MODIFY aufk FROM ls_aufk.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro AUFK' TYPE 'E'.
*  ENDIF.
*
*  MODIFY afko FROM ls_afko.
*  IF sy-subrc <> 0.
*    MESSAGE 'Erro AFKO' TYPE 'E'.
*  ENDIF.


" COMMIT WORK.

"ENDFORM.

**********************************************************************

" Table JEST
*
*TYPES: tt_jest TYPE jest.
*
*DATA: ls_jest TYPE jest.
*
*START-OF-SELECTION.
*  ls_jest-objnr = 'TEST000000000000000001'.
*  ls_jest-stat = 'TEST1'.
*  ls_jest-inact = ''.
*  ls_jest-chgnr = 001.
*  MODIFY jest FROM ls_jest.
*
*  IF SY-SUBRC <> 0.
*    MESSAGE: 'ERRO 1' TYPE 'E'.
*    ROLLBACK WORK.
*  ENDIF.
*
*  ls_jest-objnr = 'TEST000000000000000002'.
*  ls_jest-stat = 'TEST2'.
*  ls_jest-chgnr = 001.
*  MODIFY jest FROM ls_jest.
*
*  IF SY-SUBRC <> 0.
*    MESSAGE: 'ERRO 1' TYPE 'E'.
*    ROLLBACK WORK.
*  ENDIF.
*
*  ls_jest-objnr = 'TEST000000000000000003'.
*  ls_jest-stat = 'TEST3'.
*  ls_jest-chgnr = 001.
*  MODIFY jest FROM ls_jest.
*
*  IF SY-SUBRC <> 0.
*    MESSAGE: 'ERRO 1' TYPE 'E'.
*    ROLLBACK WORK.
*  ENDIF.
*
*if SY-SUBRC = 0.
*  MESSAGE: 'Sucesso' TYPE 'S'.
*  COMMIT WORK.
*  ENDIF.

**********************************************************************
" Table EQUI
*
*DATA: ls_equi TYPE equi.
*
*START-OF-SELECTION.
*
*  ls_equi-objnr = 'TEST000000000000000001'.
*  ls_equi-equnr = '10000600'.
*  ls_equi-ernam = sy-uname.
*  ls_equi-erdat = sy-datum.
*  MODIFY equi FROM ls_equi.
*
*  IF sy-subrc <> 0.
*    MESSAGE: 'ERRO 1' TYPE 'E'.
*    ROLLBACK WORK.
*  ENDIF.
*
*  ls_equi-objnr = 'TEST000000000000000002'.
*  ls_equi-equnr = '10000500'.
*  ls_equi-ernam = sy-uname.
*  ls_equi-erdat = sy-datum.
*  MODIFY equi FROM ls_equi.
*
*  IF sy-subrc <> 0.
*    MESSAGE: 'ERRO 2' TYPE 'E'.
*    ROLLBACK WORK.
*  ENDIF.
*
*  ls_equi-objnr = 'TEST000000000000000003'.
*  ls_equi-equnr = '10000300'.
*  ls_equi-ernam = sy-uname.
*  ls_equi-erdat = sy-datum.
*  MODIFY equi FROM ls_equi.
*
*  IF sy-subrc <> 0.
*    MESSAGE: 'ERRO 3' TYPE 'E'.
*    ROLLBACK WORK.
*  ENDIF.
*
*  IF sy-subrc = 0.
*    MESSAGE: 'Sucesso' TYPE 'S'.
*    COMMIT WORK.
*  ENDIF.


**********************************************************************
" Table AUFK

*START-OF-SELECTION.
*    update aufk
*        set objnr = 'TEST000000000000000001'
*        where auart = 'PM02'.
*
*    update aufk
*        set objnr = 'TEST000000000000000002'
*        where auart = 'PM01'.
*
*        update aufk
*        set objnr = 'TEST000000000000000003'
*        where auart = 'PM05'.

**********************************************************************
DATA: ls_iflot TYPE iflot.

START-OF-SELECTION.
  ls_iflot-tplnr = '200801'.
  ls_iflot-objnr = 'TEST000000000000000001'.
  ls_iflot-ernam = sy-uname.
  ls_iflot-erdat = sy-datum.
  MODIFY iflot  FROM ls_iflot.

  IF sy-subrc <> 0.
    MESSAGE: 'ERRO 1' TYPE 'E'.
    ROLLBACK WORK.
  ENDIF.

  ls_iflot-tplnr = '305001'.
  ls_iflot-objnr = 'TEST000000000000000002'.
  ls_iflot-ernam = sy-uname.
  ls_iflot-erdat = sy-datum.
  MODIFY iflot  FROM ls_iflot.

  IF sy-subrc <> 0.
    MESSAGE: 'ERRO 2' TYPE 'E'.
    ROLLBACK WORK.
  ENDIF.

  ls_iflot-tplnr = '100055'.
  ls_iflot-objnr = 'TEST000000000000000003'.
  ls_iflot-ernam = sy-uname.
  ls_iflot-erdat = sy-datum.
  MODIFY iflot  FROM ls_iflot.

  IF sy-subrc <> 0.
    MESSAGE: 'ERRO 3' TYPE 'E'.
    ROLLBACK WORK.
  ENDIF.


  IF sy-subrc = 0.
    MESSAGE: 'Sucesso' TYPE 'S'.
    COMMIT WORK.
  ENDIF.




**********************************************************************

  " Structure Types:
*TYPES: BEGIN OF ty_order,
*         gstrp TYPE afko-gstrp, " sy-datum
*         gltrp TYPE afko-gltrp, " sy-datum
*         bukrs TYPE aufk-bukrs, " char4
*         aufnr TYPE aufk-aufnr, " char12
*         auart TYPE aufk-auart, " char4
*         vaplz TYPE aufk-vaplz, " char8
*         ktext TYPE aufk-ktext, " char40
*         "equnr TYPE itob-equnr, " char18
*         equnr TYPE char18, " char18
*         erdat TYPE aufk-erdat, " sy-datum
*         "tplnr TYPE iflo-tplnr, " char30
*         tplnr TYPE char30, " char30
*       END OF ty_order.

  "DATA: lt_output TYPE TABLE OF zrs_alv_estudo_02_001.

*START-OF-SELECTION.
*
**     SELECT afko~gstrp, afko~gltrp, aufk~bukrs,
**            aufk~aufnr, aufk~auart, aufk~vaplz,
**            aufk~ktext, aufk~erdat
**    FROM aufk INNER JOIN afko ON afko~aufnr = aufk~aufnr
**      INTO TABLE @lt_output
**      WHERE aufk~bukrs = '1101'.
*
*  SELECT aufk~aufnr, itob~equnr, itob~tplnr
*      INTO TABLE @DATA(lt_output)
*    FROM aufk
*        INNER JOIN jest ON aufk~objnr = jest~objnr
*        INNER JOIN itob ON jest~objnr = itob~objnr.
*  "WHERE aufk~aufnr = '10000123'.
*
*  IF sy-subrc = 0.
*    LOOP AT lt_output INTO DATA(ls_output).
*      WRITE:/ 'aufnr', ls_output-aufnr,
*            / 'equnr', ls_output-equnr,
*            / 'tplnr', ls_output-tplnr.
*    ENDLOOP.
*  ELSE.
*    MESSAGE: 'Nenhum dado encontrado' TYPE 'E'.
*  ENDIF.
*
*END-OF-SELECTION.
