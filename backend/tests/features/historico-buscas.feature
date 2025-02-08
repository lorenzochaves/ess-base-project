Feature: Histórico de Buscas
    As um usuário
    I want to visualizar, adicionar, remover e limpar meu histórico de buscas
    So that  eu possa gerenciar facilmente meus termos de pesquisa anteriores.

Scenario: Exibir últimas 5 buscas na barra de busca - GUI
  Given o usuário "Bruno" está na página "Feed"
  And o histórico de buscas do usuário contém "pizza", "hambúrguer", "sushi", "vegetariano" e "lasanha"  
  When o usuário acessa a barra de busca  
  Then as sugestões no dropdown exibem:  
    | Sugestão      |
    | lasanha       |
    | vegetariano   |
    | sushi         |
    | hambúrguer    |
    | pizza         |

Scenario: Atualizar histórico de buscas após nova busca - GUI

  Given o usuário "Bruno" está na página "Feed"
  And o histórico de buscas do usuário é: "salada", "hambúrguer", "bolo"
  When o usuário pesquisa pelo termo "chocolate" na barra de busca
  Then o sistema adiciona "chocolate" ao histórico de buscas
  And o histórico de buscas atualizado é: "chocolate", "salada", "hambúrguer", "bolo"

Scenario: Atualizar histórico de buscas após nova busca - Serviço

  Given o usuário "Bruno" tem o seguinte histórico de buscas:
    | termo       |
    | salada      |
    | hambúrguer  |
    | bolo        |
  When o usuário faz uma requisição "POST" para "/historico/adicionar" com os seguintes dados:
    | usuario_id  | 12345       |
    | termo       | chocolate   |
  Then o status da resposta deve ser "200"
  And o JSON da resposta deve conter um campo "msg" com o valor "Busca adicionada com sucesso"
  And o histórico de buscas do usuário deve ser:
    | termo       |
    | chocolate   |
    | salada      |
    | hambúrguer  |
    | bolo        |

Scenario: Exibir todo o histórico de buscas em uma página separada  - GUI
  Given o usuário "Bruno" está na página "Feed" 
  And o histórico de buscas do usuário contém "carne", "hambúrguer", "frango", "vegetariano", "lasanha", "chocolate"  
  When o usuário seleciona o botão "Ver todo o histórico" na barra de busca  
  Then o sistema redireciona para a página "Histórico de buscas"  
  And a página exibe o histórico completo:  
    | Termo         |
    | carne         |
    | hambúrguer    |
    | frango        |
    | vegetariano   |
    | lasanha       |
    | chocolate     |


Scenario: Limpar todo o histórico de buscas - Serviço

  Given o usuário "Bruno" tem o seguinte histórico de buscas:
    | termo       |
    | salada      |
    | hambúrguer  |
    | bolo        |
  When o usuário faz uma requisição "DELETE" para "/historico/limpar" com os seguintes dados:
    | usuario_id  | 12345       |
  Then o status da resposta deve ser "200"
  And o JSON da resposta deve conter um campo "msg" com o valor "Histórico de buscas limpo com sucesso"
  And o histórico de buscas do usuário deve ser:
    | termo       |
    |             |


Scenario: Remover busca específica do histórico - Serviço


  Given o usuário "Bruno" tem o seguinte histórico de buscas:
    | termo       |
    | salada      |
    | hambúrguer  |
    | bolo        |
  When o usuário faz uma requisição "DELETE" para "/historico/remover" com os seguintes dados:
    | usuario_id  | 12345       |
    | termo       | hambúrguer  |
  Then o status da resposta deve ser "200"
  And o JSON da resposta deve conter um campo "msg" com o valor "Busca removida com sucesso"
  And o histórico de buscas do usuário deve ser:
    | termo       |
    | salada      |
    | bolo        |

Scenario: Histórico de buscas ao adicionar um termo repetido - Serviço
  Given o usuário "Bruno" tem o seguinte histórico de buscas:
    | termo       |
    | pizza       |
    | hambúrguer  |
  When o usuário faz uma requisição "POST" para "/historico/adicionar" com os seguintes dados:
    | usuario_id  | 12345       |
    | termo       | pizza       |
  Then o status da resposta deve ser "200"
  And o histórico de buscas do usuário não deve ser alterado:
    | termo       |
    | pizza       |
    | hambúrguer  |






 