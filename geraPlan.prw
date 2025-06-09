#include "totvs.ch"

/*/{Protheus.doc} geraPlan
rotina exemplo de geração de planilha excel
@type function
@author Cristiam Rossi
@since 23/05/2025
/*/
user function geraPlan()
local cHTML
local cArquivo := "c:\temp\planilha.xls"

    makeDir("c:\temp")

    cHTML := '<!doctype html>'
    cHTML += '<html lang="pt-BR">'
    cHTML += '<head>'
    cHTML +=    '<title>Titulo da pagina</title>'
    cHTML += '</head>'

    cHTML += '<body>'
    cHTML += '<table>'
    cHTML +=    '<tr bgcolor="#CCCCCC"><th>Coluna 1</th><th>Coluna 2</th><th>Coluna 3</th></tr>'
    cHTML +=    '<tr><td bgcolor="#CCFFCC">Linha 1,1</td><td>Linha 1,2</td><td>Linha 1,3</td></tr>'
    cHTML +=    '<tr><td>Linha 2,1</td><td bgcolor="#FFD94D">Linha 2,2</td><td>Linha 2,3</td></tr>'
    cHTML +=    '<tr bgcolor="#0096C7"><td>Linha 3,1</td><td>Linha 3,2</td><td>Linha 3,3</td></tr>'
    cHTML += '</table>'
    cHTML += '<br><br>'
    cHTML += 'Imagem:<br>'
    cHTML += '<img src="https://itforum.com.br/wp-content/uploads/2020/03/shutterstock_577183882.jpg?x91605">'
    cHTML += '<br>'
    cHTML += '</body>'

    memowrite( cArquivo, cHtml )
    ShellExecute( "Open", cArquivo , "", "C:\temp", 1 )

return nil
