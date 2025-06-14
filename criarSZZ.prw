#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³GH        ³ Autor ³ MICROSIGA             ³ Data ³ 14/06/2025 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gestao Hospitalar                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function criarSZZ()

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [GH]","Aguarde , processando preparação dos arquivos")

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
//Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		if ascan( aRecnoSM0, {|it| it[1] == M0_CODIGO} ) == 0
			Aadd(aRecnoSM0,{ M0_CODIGO, SM0->M0_CODFIL })
		endif
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)

			if ! msgYesNo( "Deseja criar tabela SZZ na empresa " + aRecnoSM0[nI,1] )
				loop
			endif

			RpcSetEnv( aRecnoSM0[nI,1], aRecnoSM0[nI,2] )
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			cTexto += GeraSX2()
			cTexto += GeraSX3()
			cTexto += GeraSIX()
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX

			RpcClearEnv()
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()
Local lOpen := .F.
Local nLoop := 0

	For nLoop := 1 To 20
		If OpenSM0Excl(,.F.)
			lOpen := .T.
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop

	If !lOpen
		Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
	EndIf

Return( lOpen )




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX2  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX2()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZZ","                                        ","SZZ990  ","tabela de teste com MVC       ","tabela de teste com MVC       ","tabela de teste com MVC       ","                                        ","C","C","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                                                                                                    ","                                                                                                    "," "," "," ",00,00,00," "," "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZZ","01","ZZ_FILIAL ","C",len(cFilAnt),00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal                 ","Branch of the System     ","@!                                           ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       ","                                                                                                                                                                ","      ",01,"XXXXXX X        "," "," ","U","N"," "," ","        ","                                                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                  ","                                                                                                    ","                                                                                                    ","033"," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," "," "," ","               ","                                                  ","   "," "," ","N","N","N"})
AADD(aRegs,{"SZZ","02","ZZ_CODIGO ","C",04,00,"Codigo      ","Codigo      ","Codigo      ","Codigo                   ","Codigo                   ","Codigo                   ","                                             ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ","GETSXENUM('SZZ','ZZ_CODIGO')                                                                                                                                    ","      ",00,"xxxxxx x        "," "," ","U","S","V","R","        ","                                                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                  ","                                                                                                    ","                                                                                                    ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","   "," "," ","N","N","N"})
AADD(aRegs,{"SZZ","03","ZZ_DESCRI ","C",40,00,"Descricao   ","Descricao   ","Descricao   ","Descricao                ","Descricao                ","Descricao                ","                                             ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ","                                                                                                                                                                ","      ",00,"xxxxxx x        "," "," ","U","S","A","R","x       ","                                                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                  ","                                                                                                    ","                                                                                                    ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","   "," "," ","N","N","N"})
AADD(aRegs,{"SZZ","04","ZZ_DATA   ","D",08,00,"Dt Inclusao ","Dt Inclusao ","Dt Inclusao ","Dt Inclusao              ","Dt Inclusao              ","Dt Inclusao              ","                                             ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ","DDATABASE                                                                                                                                                       ","      ",00,"xxxxxx x        "," "," ","U","S","V","R","        ","                                                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                  ","                                                                                                    ","                                                                                                    ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","   "," "," ","N","N","N"})
AADD(aRegs,{"SZZ","05","ZZ_HORA   ","C",08,00,"Hs Inclusao ","Hs Inclusao ","Hs Inclusao ","Hs Inclusao              ","Hs Inclusao              ","Hs Inclusao              ","                                             ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ","TIME()                                                                                                                                                          ","      ",00,"xxxxxx x        "," "," ","U","S","V","R","        ","                                                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                  ","                                                                                                    ","                                                                                                    ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","   "," "," ","N","N","N"})
AADD(aRegs,{"SZZ","06","ZZ_STATUS ","C",01,00,"Status      ","Status      ","Status      ","Status                   ","Status                   ","Status                   ","@!                                           ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ","'0'                                                                                                                                                             ","      ",00,"xxxxxx x        "," "," ","U","N","A","R","        ","                                                                                                                                                                ","0=Pendente;1=Integrado;2=Erro                                                                                                   ","0=Pendente;1=Integrado;2=Erro                                                                                                   ","0=Pendente;1=Integrado;2=Erro                                                                                                   ","                                                  ","                                                                                                    ","                                                                                                    ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","   "," "," ","N","N","N"})
AADD(aRegs,{"SZZ","07","ZZ_OBS    ","M",10,00,"Observacoes ","Observacoes ","Observacoes ","Observacoes              ","Observacoes              ","Observacoes              ","                                             ","                                                                                                                                                                ","x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     ","                                                                                                                                                                ","      ",00,"xxxxxx x        "," "," ","U","N","A","R","        ","                                                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                  ","                                                                                                    ","                                                                                                    ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","   "," "," ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSIX()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZZ","1","ZZ_FILIAL+ZZ_CODIGO                                                                                                                                             ","Codigo                                                                ","Codigo                                                                ","Codigo                                                                ","U","                                                                                                                                                                ","          ","S"," "," "})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))
