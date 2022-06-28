# TLookupEdit
Componente para pesquisa de registros em Delphi.

# Sobre
O componente consiste em um edit que realiza a busca dos registros de acordo com o filtro informado, criando uma grid dinâmica abaixo do edit onde pode-se selecionar o resultado desejado.

# Documentação
No <i>Object Inspector</i> do componente é possível ajustar 6 configurações, sendo elas:

<b>*AutoList:</b><br />
- Esta opção representa se o grid será ou não exibido no momento em que o edit recebe o foco.<br />
--- alChange significa que o grid não será exibido quando o edit receber o foco, apenas quando digitar.<br />
--- alEnter significa que o grid será exibido quando o edit receber o foco.<br /><br />

<b>*DisplayField:</b><br />
- Esta opção representa o campo/coluna da tabela que será exibido no edit quando o registro for escolhido.<br /><br />

<b>*KeyField:</b><br />
- Esta opção representa o campo/coluna chave da tabela em caso de querer recuperar o ID, por exemplo, quando o registro for escolhido. Muito últil em casos de relacionamentos de tabelas (<i>Foreign Key</i>)<br /><br />

<b>*ListSource:</b><br />
- Esta opção representa a tabela que será listada no grid.<br /><br />

<b>*SearchField:</b><br />
- Esta opção representa o(s) campo(s)/coluna(s) da tabela que será(ão) levado(s) em conta para o filtro.<br />
- Para informar mais de um campo, separar por ";" (ponto e vírgula). Exemplo: ID;NOME;CPF<br /><br />

<b>*ShowColumn:</b><br />
- Esta opção representa o(s) campo(s)/coluna(s) da tabela que será(ão) exibido(s) no grid.<br />
- Para informar mais de um campo, separar por ";" (ponto e vírgula). Exemplo: ID;NOME;CPF
