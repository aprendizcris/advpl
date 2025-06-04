#include 'TOTVS.CH'
#include 'RESTFUL.CH'

/*/{Protheus.doc} exemploWS
WS Rest de exemplo
@type function
@author Cristiam Rossi
@since 01/06/2025
/*/
wsRestFul exemploWS Description "CRUD x API REST Protheus" format "application/json"
    wsData   Codigo as string optional

    wsMethod POST   funcPOST description "Inclusão de registros"    path "/api/v1/exemploWS" wsSyntax "/api/v1/exemploWS" produces APPLICATION_JSON
    wsMethod GET    funcGET  description "Obtenção de registros"    path "/api/v1/exemploWS" wsSyntax "/api/v1/exemploWS" produces APPLICATION_JSON
    wsMethod PUT    funcPUT  description "Atualização de registros" path "/api/v1/exemploWS" wsSyntax "/api/v1/exemploWS" produces APPLICATION_JSON
    wsMethod DELETE funcDEL  description "Exclusão de registros"    path "/api/v1/exemploWS" wsSyntax "/api/v1/exemploWS" produces APPLICATION_JSON
end wsRestFul


wsMethod POST funcPOST wsRest exemploWS
local cContent := self:getContent()     // conteúdo Body da requisição
local oJson    := JsonObject():New()
local oRetorno := JsonObject():New()
local nRetCode := 400       // 400 Bad Request

    varinfo( "POST-request", cContent )      // útil em tempo de testes (remover depois) para exbir Body da requisição no console.log

    if oJson:FromJson(cContent) == nil
        cCodigo := iif( oJson["codigo"]     == nil, "", oJson["codigo"]     )
        cDescri := iif( oJson["descricao"]  == nil, "", oJson["descricao"]  )

        if empty( cCodigo )
            oRetorno["message"] := EncodeUTF8("Favor informar a tag codigo")
        elseif empty( cDescri )
            oRetorno["message"] := EncodeUTF8("Favor informar a tag descricao")
        else
/*
    aqui fazemos a operação de inclusão: recLock, MVC ou execAuto. 
    caso o objeto for complexo pode demorar e ocorrer erro de timeout, avalie o tempo da operação.
    Se necessário grave em uma tabela de processo/represa e processe depois com um Job ou rotina de menu
*/
            oRetorno["message"] := EncodeUTF8("Registro incluído com exito")
            nRetCode := 201     // 201 Created
        endif
    else
        oRetorno["message"] := EncodeUTF8("Ocorreu um erro ao ler a estrutura do Json da requisição")
    endif

    if nRetCode == 201
        ::setResponse( oRetorno:ToJson() )
    else
        setRestFault( nRetCode, oRetorno:ToJson() )
    endif

    FwFreeObj( oJson )
    FwFreeObj( oRetorno )
return nil


wsMethod GET funcGET wsRest exemploWS
local oRetorno := JsonObject():New()
local oAux
local aItens   := {}
local cJson    := ""
local nI

/*
    aqui fazemos a recuperação dos dados, geralmente uma query.
    recomendo utilizar a classe FWAdapterBaseV2 por conta dos filtros e paginação, fique chic
    link: https://tdn.totvs.com/display/public/framework/09.+FWAdapterBaseV2
*/
    for nI := 1 to 5
        oAux := JsonObject():New()
        oAux["codigo"]    := nI
        oAux["descricao"] := extenso( nI, .T. )
        aAdd( aItens, oAux )
    next
    oRetorno["itens"] := aItens             // lista mocada com 5 itens de retorno
    cJson := oRetorno:ToJson()

    ::setResponse( cJson )

    FwFreeObj( oRetorno )
return nil


wsMethod PUT funcPUT wsRest exemploWS
local   cContent  := self:getContent()     // conteúdo Body da requisição
local   oJson     := JsonObject():New()
local   oRetorno  := JsonObject():New()
local   cJson     := ""
local   nRetCode  := 400       // 400 Bad Request
local   cCodigo   := ::codigo

    varinfo( "PUT-request", cContent )      // útil em tempo de testes (remover depois)

    if empty( cCodigo )
        oRetorno["message"] := EncodeUTF8("Obrigatório informar o código")

    elseif oJson:FromJson(cContent) == nil
        cDescri := iif( oJson["descricao"]  == nil, "", oJson["descricao"]  )
        cObs    := iif( oJson["observacao"] == nil, "", oJson["observacao"] )

        if empty( cDescri )
            oRetorno["message"] := EncodeUTF8("Favor informar a tag descricao")
        else
/*
    fazer o posicionamento no registro e atualização necessária
*/
            oRetorno["message"] := EncodeUTF8("Registro atualizado com exito")
            nRetCode := 200
        endif
    else
        oRetorno["message"] := EncodeUTF8("Ocorreu um erro ao ler a estrutura do Json da requisição")
    endif

    cJson := oRetorno:ToJson()

    if nRetCode == 200      // 200 Ok
        ::setResponse( cJson )
    else
        setRestFault( nRetCode, cJson )
    endif

    FwFreeObj( oJson )
    FwFreeObj( oRetorno )
return nil


wsMethod DELETE funcDEL wsRest exemploWS
local   oRetorno  := JsonObject():New()
local   cJson     := ""
local   nRetCode  := 400       // 400 Bad Request
local   cCodigo   := ::Codigo

    if empty( cCodigo )
        oRetorno["message"] := EncodeUTF8("Obrigatório informar o código")
    else
/*
    fazer o posicionamento no registro e realizar a exclusão
*/
        oRetorno["message"] := EncodeUTF8("Registro excluído com sucesso")
        nRetCode := 200
    endif

    cJson := oRetorno:ToJson()

    if nRetCode == 200      // 200 Ok
        ::setResponse( cJson )
    else
        setRestFault( nRetCode, cJson )
    endif

    FwFreeObj( oRetorno )
return nil
