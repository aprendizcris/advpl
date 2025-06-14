#include "totvs.ch"
#include "FWMVCdef.ch"

/*/{Protheus.doc} cadSZZ
Rotina de exemplo em MVC
@type function
@version 1.0
@author cristiamRossi
@since 11/06/2025
/*/
user function cadSZZ()
local oBrowse := FWMBrowse():New()                                          // objeto Browse

    oBrowse:SetAlias( "SZZ" )                                               // tabela a ser exibida
    oBrowse:AddLegend( "ZZ_STATUS=='0'", "YELLOW", "Pendente"  )            // Legendas
    oBrowse:AddLegend( "ZZ_STATUS=='1'", "BLUE"  , "Integrado" ) 
    oBrowse:AddLegend( "ZZ_STATUS=='2'", "RED"   , "Erro"      ) 
    oBrowse:SetDescription('Cadastro de Exemplo')                           // descrição da tela
    oBrowse:Activate()
return nil


/*/{Protheus.doc} menuDef
MenuDef - Lista de operações/opções do modelo/aplicação
@type function
@version 1.0
@author cristiamRossi
@since 10/06/2025
@return array, lista de opções (menu)
/*/
static function menuDef()
local aRotina := FWMVCMenu( "cadSZZ" )    // menu de opções do cadastro

    ADD OPTION aRotina TITLE "Inclusão sem ViewDef" ACTION 'U_cadSZZInc' OPERATION 3 ACCESS 0 // Incluir

return aRotina

/*/{Protheus.doc} ModelDef
MODEL - Controle do modelo/aplicação
@type function
@version 1.0
@author cristiamRossi
@since 10/06/2025
@return object, objeto Model-MVC
/*/
static Function ModelDef() 
local oStruSZZ := FWFormStruct( 1, "SZZ" )                                  // dicionário de campos
local oModel   := MPFormModel():New( "MODELSZZ" )                           // objeto do modelo

    oModel:AddFields( "SZZMASTER", , oStruSZZ )                             // insere campos no Model
    oModel:SetPrimaryKey( { "ZZ_FILIAL", "ZZ_CODIGO" } )                    // chave primária (Id único registro)
    oModel:SetDescription( "Modelo de dados tabela SZZ" )                   // descrição do Model
    oModel:GetModel( "SZZMASTER" ):SetDescription( "Dados do registro" )    // descrição do grupo de campos
return oModel


/*/{Protheus.doc} ViewDef
VIEW - aprensentação do modelo/aplicação
@type function
@version 1.0
@author cristiamRossi
@since 10/06/2025
@return object, objeto View-MVC
/*/
static Function ViewDef() 
local oModel   := FWLoadModel( "cadSZZ" )                   // objeto MODEL
local oStruSZZ := FWFormStruct( 2, "SZZ" )                  // dicionário de campos
local oView    := FWFormView():New()                        // objeto View do modelo

    oView:SetModel( oModel )                                // vincula o MODEL a ser usado
    oView:AddField( 'VIEW_SZZ', oStruSZZ, 'SZZMASTER' )     // insere os campos no formulário
    oView:CreateHorizontalBox( 'TELA' , 100 )               // cria formulário tela cheia 100%
    oView:SetOwnerView( 'VIEW_SZZ', 'TELA' )                // vincula campos no Box/formulário
return oView



/*/{Protheus.doc} cadSZZInc
Inclui um registro direto pelo Model, sem chamar a View
@type function
@version 1.0
@author cristiamRossi
@since 12/06/2025
/*/
user function cadSZZInc()
local oModel := FWLoadModel( "cadSZZ" )                 // instanciação do MODEL

    oModel:SetOperation( MODEL_OPERATION_INSERT )       // operação a ser executada - INCLUSÃO
    if oModel:Activate()                                // ativação do MODEL

        oModel:SetValue( "SZZMASTER", "ZZ_DESCRI", "Inclusão sem View" )        // informamos os campos e valores
        oModel:SetValue( "SZZMASTER", "ZZ_OBS"   , "É possível fazer inclusões diretamente pela Model" )

        if oModel:VldData()                             // valida os dados preenchidos
            oModel:CommitData()                         // se OK, grava
        Else
            aErro := oModel:GetErrorMessage()           // em caso de falha na validação do MODEL
    		AutoGrLog( "Mensagem do erro: [" + AllToChar(aErro[6]) + "]" )      // salvo mensagem da falha 

	    	if ! isBlind()                                          // estamos executando via Smartclient (temos tela)
		    	Help(" ",1,"ERROR",,AllToChar(aErro[6]),4,1 )       // exibe mensagem da falha
		    else
    			MostraErro()                                        // exibe mensagem da falha
	    	endif
        endif

        oModel:DeActivate()                             // desativamos o MODEL
    endif
return nil
