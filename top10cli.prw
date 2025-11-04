#include "totvs.ch"

/*/{Protheus.doc} top10cli
Exemplo de utilização da classe FwExecStatement()
@type function
@author Cristiam Rossi
@since 02/05/2025
/*/
user function top10cli()
local aArea      := getArea()
local cQuery
local cAlias     := getNextAlias()
local oStatement
local aDados     := {}
local oDlg
local oList

    cQuery := "select top 10" + CRLF                        // banco Oracle não tem TOP, usar subquery com ROWNUM no where
    cQuery += "     sum( F2_VALBRUT ) VALBRUTO," + CRLF
    cQuery += "     F2_FILIAL," + CRLF
    cQuery += "     F2_CLIENTE," + CRLF
    cQuery += "     F2_LOJA," + CRLF
    cQuery += "     A1_NREDUZ" + CRLF
    cQuery += " from " + retSqlName("SF2") + " SF2 " + CRLF
    cQuery += " join " + retSqlName("SA1") + " SA1 " + CRLF
    cQuery += "     on  A1_FILIAL = ?" + CRLF
    cQuery += "     and A1_COD = F2_CLIENTE" + CRLF
    cQuery += "     and A1_LOJA = F2_LOJA" + CRLF
    cQuery += "     and SA1.D_E_L_E_T_ <> ?" + CRLF
    cQuery += " where F2_FILIAL = ?" + CRLF
    cQuery += " and   F2_TIPO = ?" + CRLF
    cQuery += " and   F2_DUPL <> ?" + CRLF
    cQuery += " and   F2_EMISSAO > ?" + CRLF
    cQuery += " and SF2.D_E_L_E_T_ <> ?" + CRLF
    cQuery += " group by F2_FILIAL, F2_CLIENTE, F2_LOJA, A1_NREDUZ" + CRLF
    cQuery += " order by F2_FILIAL, 1 desc" + CRLF

	oStatement := FwExecStatement():new( cQuery )
    oStatement:setString( 1, xFilial("SA1") )
    oStatement:setString( 2, "*" )
    oStatement:setString( 3, xFilial("SF2") )
    oStatement:setString( 4, "N" )
    oStatement:setString( 5, " " )
    oStatement:setDate(   6, monthSub(firstDay(dDatabase), 6 ) )
    oStatement:setString( 7, "*" )

    cQuery := oStatement:getFixQuery()      // para poder ver a query pronta

    oStatement:OpenAlias( cAlias )
    while ! (cAlias)->( eof() )
        aAdd( aDados, { (cAlias)->F2_FILIAL, (cAlias)->A1_NREDUZ, (cAlias)->VALBRUTO } )
        (cAlias)->( dbSkip() )
    endDo

    define msDialog oDlg title "Ranking 10 maiores clientes em 6 meses" FROM 0,0 TO 200,500 pixel
	@ 1, 1 LISTBOX oList FIELDS HEADER "Filial","Cliente","Faturamento" SIZE 1,1 OF oDlg pixel
    oList:align := CONTROL_ALIGN_ALLCLIENT
	oList:SetArray( aDados )
	oList:bLine := {|| { ;
        aDados[oList:nAt,1],;
        aDados[oList:nAt,2],;
        transform(aDados[oList:nAt,3], "@E 999,999,999,999,999.99");
    } }

    activate msDialog oDlg

    (cAlias)->( dbCloseArea() )
    freeObj( oStatement )

    restArea( aArea )
return nil
