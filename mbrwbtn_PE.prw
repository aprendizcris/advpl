#include "totvs.ch"

/*/{Protheus.doc} MBRWBTN
    Ponto de Entrada tem por finalidade, validar se a rotina selecionada na MBrowse será 
    executada ou não a partir do retorno lógico do ponto de entrada.
    link TDN:
    https://tdn.totvs.com/pages/releaseview.action?pageId=6815197
@type Function
@author cristiamRossi
@since 29/08/2025
@version 1.0
@return logical, continua .T. / .F.
/*/
user function MBRWBTN
local lRet    := .T.
local cAlias  := PARAMIXB[1]
local nRecno  := PARAMIXB[2]
local nOpc    := PARAMIXB[3]    // 1=Pesquisa;2=Visualizar;3=Incluir;4=Alterar;5=Excluir
local cRotina := PARAMIXB[4]
local cText   := ""

    cText += "Alias ["+cAlias+"]" + CRLF
    cText += "Recno ["+cValToChar(nRecno)+"]" + CRLF
    cText += "nOpc  ["+cValToChar(nOpc)+"]" + CRLF
    cText += "cRotina ["+cRotina+"]"

    lRet := msgYesNo( cText, "Continua?" )

return lRet
