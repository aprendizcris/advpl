#include "totvs.ch"

/*/{Protheus.doc} sndMail
rotina de sendMail
@type function
@author Cristiam Rossi
@since 07/02/2025
/*/
user function sndMail( cAssunto, cCorpo, cTo, cCC, aAnexos )
local   oServer   := tMailManager():New()
local   oMessage  := tMailMessage():new()
local   cRootPath := strTran( getSrvProfString("RootPath",""), "\", "/" )
local   nI
local   nErr      := 0
local   nPos
local   cSMTPAddr := allTrim( getMV("MV_RELSERV") )
local   nSMTPPort := getMV("MV_PORSMTP",,465)
local   nSMTPTime := 60
local   cUser     := allTrim( getMV("MV_RELACNT") )
local   cPass     := allTrim( getMV("MV_RELPSW") )
local   cFrom     := getMV("MV_RELFROM",,cUser)
local   lAuth     := getMV("MV_RELAUTH",,.F.)
local   lSSL      := getMV("MV_RELSSL" ,,.F.)
local   lTLS      := getMV("MV_RELTLS" ,,.F.)
local   aRemove   := {}
local   lOk       := .T.
default cAssunto  := ""
default cCorpo    := ""
default cTo       := ""
default cCC       := ""
default aAnexos   := {}

	if empty( cTo )
		msgInfo("[ERROR] Favor informar um e-mail para envio")
		return .F.
	endif

	if ( nPos := AT( ":", cSMTPAddr ) ) > 0				// recuperar a Porta de conexão SMTP
		nSMTPPort := val( subStr( cSMTPAddr, nPos+1 ) )
		cSMTPAddr := left( cSMTPAddr, nPos-1)
	endif

	oServer:setUseSSL( lSSL )
	oServer:setUseTLS( lTLS )
	oServer:init( "", cSMTPAddr, cUser, cPass, 0, nSMTPPort )

	oServer:SetSMTPTimeout(nSMTPTime)

	if ( nErr := oServer:smtpConnect() ) != 0			// conexão com servidor de e-mail SMTP
		msgInfo("[ERROR] Falha ao conectar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		return .F.
	endif

	if lAuth .and. ( nErr := oServer:smtpAuth(cUser, cPass) ) != 0		// autenticação
		msgInfo("[ERROR] Falha ao autenticar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		return .F.
	endif

	oMessage:clear()
	oMessage:cFrom    := cFrom
	oMessage:cTo      := cTo
	oMessage:cCC      := cCC
	oMessage:cSubject := cAssunto
	oMessage:cBody    := cCorpo
	oMessage:msgBodyType( "text/html" )

	for nI := 1 to len(aAnexos)
		cArquivo := strTran( aAnexos[nI], "\", "/" )
		if file( cArquivo )
			cArquivo := strTran( cArquivo, cRootPath, "" )
			if left( cArquivo, 1 ) != "/"			// se anexo não estiver no RootPath
				makeDir("/tmp")						// crio pasta /Protheus_Data/tmp
				if CpyT2S( cArquivo, "/tmp" )		// copio o anexo p/ RootPath
					cArquivo := "/tmp" + subStr( cArquivo, RAT( "/", cArquivo ) )
					aAdd( aRemove, cArquivo )
				endif
			endif

			if oMessage:AttachFile( cArquivo ) < 0		// a classe só anexa arquivo dentro do RootPath
				msgInfo("[ERROR] Falha ao inserir anexo: " + aAnexos[nI])
			endif
		else
			msgInfo("[ERROR] Anexo não encontrado: " + aAnexos[nI])
		endif
	next

	if ( nErr := oMessage:send(oServer) ) <> 0
		msgInfo("[ERROR] Falha ao enviar: " + oServer:getErrorString(nErr))
		lOk := .F.
//	Else
//		MsgInfo("Mensagem Enviada com Sucesso!!!")
	EndIf

	for nI := 1 to len( aRemove )		// se copiei para RootPath
		fErase( aRemove[nI] )			// apago o arquivo
	next

	oServer:smtpDisconnect()
return lOk


/*/{Protheus.doc} tstMail
rotina para demonstração de uso
@type function
@author Cristiam Rossi
@since 07/02/2025
/*/
user function tstMail()
local cAssunto := "teste de envio"
local cCorpo   := "este é uma <b>mensagem</b> de teste"		// podemos colocar conteúdo HTML
local cTo      := "aprendiz_cris@yahoo.com.br"
local cCC      := ""
local aAnexos  := {}

	makeDir( "c:\temp" )
	memowrite( "c:\temp\leiame.txt", "apenas um arquivo texto para teste de anexos" )	
	aAdd( aAnexos, "c:\temp\leiame.txt" )

	lRet := u_sndMail( cAssunto, cCorpo, cTo, cCC, aAnexos )

return nil
