#include "totvs.ch"

/*/{Protheus.doc} tstMail
Rotina de teste de configuração de e-mail
@type  Function
@author Cristiam Rossi
@since 13/10/2025
@version 1.0
/*/
user function tstMail()
local   oDlg
local   aProtocol := { "TLS", "SSL" }
local   oCombo
local   oCheck
private cURLSmtp  := space(80)
private nPortSmtp := 587
private cUserSmtp := space(80)
private cPassSmtp := space(40)
private cProtSmtp := "TLS"
private lAuthSmtp := .T.
private cTo       := space(80)

	DEFINE MSDIALOG oDlg TITLE "E-mail test" FROM 0,0 TO 300,415 pixel

	@ 05,05 say "Url SMTP:"  of oDlg pixel
	@ 20,05 say "Port SMTP:" of oDlg pixel
	@ 35,05 say "User SMTP:" of oDlg pixel
	@ 50,05 say "Pass SMTP:" of oDlg pixel
	@ 65,05 say "Protocol:"  of oDlg pixel
	@ 80,05 say "To e-mail:" of oDlg pixel

	@ 03,40 get cURLSmtp  picture "@X"    size 150,08 of oDlg pixel
	@ 17,40 get nPortSmtp picture "99999" size  30,08 of oDlg pixel
	@ 32,40 get cUserSmtp picture "@X"    size  80,08 of oDlg pixel
	@ 47,40 get cPassSmtp picture "@X"    size  80,08 of oDlg pixel PASSWORD
	@ 63,40 comboBox oCombo var cProtSmtp items aProtocol size 30,08 of oDlg pixel
	@ 77,40 get cTo       picture "@X"    size  80,08 of oDlg pixel
	@ 95,05 checkbox oCheck var lAuthSmtp prompt "Authentication required" size 80,08 of oDlg pixel

	@ 130,05 Button "test E-mail" Size 50,15 of oDlg Pixel Action Processa( {|| chkEmail() }, "Testing", "Please wait...", .F.)

	ACTIVATE MSDIALOG oDlg CENTER
Return nil


/*/{Protheus.doc} chkEmail
Rotina auxiliar que testa a conta e envia e-mail
@type  Function
@author Cristiam Rossi
@since 13/10/2025
@version 1.0
/*/
static function chkEmail()
local oServer
local oMessage
local nSMTPTime  := 120
local nErr

	processMessages()

	oServer := TMailManager():New()

	oServer:SetUseSSL( cProtSmtp == "SSL" )
	oServer:SetUseTLS( cProtSmtp == "TLS" )

	oServer:Init( "", alltrim(cURLSmtp), alltrim(cUserSmtp), alltrim(cPassSmtp), 0, nPortSmtp)
	oServer:SetSMTPTimeout(nSMTPTime)

	if ( nErr := oServer:smtpConnect() ) != 0
		oServer:smtpDisconnect()
		showMsg( "Fail: " + oServer:getErrorString(nErr) )
		return .F.
	endif

	if lAuthSmtp .and. ( nErr := oServer:smtpAuth( alltrim(cUserSmtp), alltrim(cPassSmtp) ) ) != 0
		oServer:smtpDisconnect()
		showMsg( "Authencticaton fail: " + oServer:getErrorString(nErr) )
		return .F.
	endif

	oMessage := tMailMessage():new()
	oMessage:clear()
	oMessage:cFrom    := alltrim(cUserSmtp)
	oMessage:cTo      := alltrim(cTo)
	oMessage:cSubject := "[TEST] validation e-mail"
	oMessage:cBody    := "<pre>If you are reading this message, the setup is <strong>correct</strong>.</pre>"
	oMessage:MsgBodyType( "text/html" )

	if ( nErr := oMessage:send(oServer) ) <> 0
		oServer:smtpDisconnect()
		showMsg( "Send fail: " +  oServer:getErrorString(nErr) )
		return .F.
	Else
		showMsg( "Your message has been sent successfully" )
	EndIf

	oServer:smtpDisconnect()
	FWFreeObj( oServer )
	FWFreeObj( oMessage )
Return nil


/*/{Protheus.doc} showMsg
Rotina auxiliar que exibe mensagens
@type  Function
@author Cristiam Rossi
@since 13/10/2025
@version 1.0
/*/
static function showMsg( cText, cTitle )
local   oDlg
local   oSay
local   nMilSecs := 5000
local   oTFont   := TFont():New('Arial',,-16,,.F.)
default cText    := ""
default cTitle   := "E-mail test"

    DEFINE DIALOG oDlg TITLE cTitle PIXEL

    oDlg:nWidth := 400
    oDlg:nHeight := 200

    oSay := TSay():New(0,0,{|| "<br>"+cText },oDlg,,oTFont,,,,.T.,,,0,0,,,,,,.T. /*lHtml*/)
    oSay:align := CONTROL_ALIGN_ALLCLIENT
    oSay:SetTextAlign(2,2)

    oTimer := TTimer():New(nMilSecs, {|| oDlg:end() }, oDlg )
    oTimer:Activate()

    ACTIVATE DIALOG oDlg CENTER
return nil
