##MAIS VISTOS/LIDOS          Lista os itens mais acessados pelos usuários, destacando conteúdos com maior engajamento
#GUI


Scenario: Garantir que a seção "Mais vistos/lidos" seja exibida separadamente  
  Given estou na página inicial do sistema  
  When acesso os resultados de busca  
  Then a seção "Mais vistos/lidos" é exibida em um espaço separado dos resultados da busca  
  And inclui um título destacado indicando "Mais vistos/lidos".  


A lista de itens para os próximos 3 Scenario's é:  
    | Nome                    | Visualizações ultimo mês |  Visualizações ultima semana | Visualizações ultimo dia  |
    | Bolo de Chocolate       | 250                      |  100                         | 80                        |
    | Strogonoff de carne     | 220                      |  120                         | 20                        |
    | Feijoada Tradicional    | 180                      |  60                          | 40                        |
    | Salada de Frutas        | 90                       |  50                          | 15                        |
    | paçoca                  | 50                       |  15                          | 10                        |

  Scenario: Exibir itens mais vistos do ultimo mês 
  Given existem itens cadastrados com números de visualizações variados    
  When altero o período para "Último mês" na seção "Mais vistos/lidos"   
  Then o sistema exibe os itens mais vistos da última semana com ranking numérico:  
    | Posição | Nome                    | Visualizações |  
    | 1º      | Bolo de Chocolate       | 250           |  
    | 1º      | Strogonoff de carne     | 220           |  
    | 3º      | Feijoada Tradicional    | 180           |
    | 4º      | Salada de Frutas        | 90            | 
    | 5º      | Paçoca                  | 50            | 
  And itens com menos de 20 visualizações não são exibidos. 


Scenario: Exibir itens mais vistos da última semana  
  Given existem itens cadastrados com números de visualizações variados    
  When acesso a seção "Mais vistos/lidos" sem alterar o período  
  Then o sistema exibe os itens mais vistos da última semana com ranking numérico:  
    | Posição | Nome                    | Visualizações |  
    | 1º      | Strogonoff de carne     | 120           |  
    | 2º      | Bolo de Chocolate       | 100           |  
    | 3º      | Feijoada Tradicional    | 60            |
    | 4º      | Salada de Frutas        | 50            |  
  And itens com menos de 20 visualizações não são exibidos.  


  Scenario: Exibir itens mais vistos do ultimo dia 
  Given existem itens cadastrados com números de visualizações variados    
  When altero o período para "Último dia" na seção "Mais vistos/lidos"   
  Then o sistema exibe os itens mais vistos da última semana com ranking numérico:  
    | Posição | Nome                    | Visualizações |  
    | 1º      | Bolo de Chocolate       | 80            |  
    | 2º      | Feijoada Tradicional    | 40            |
    | 3º      | Strogonoff de carne     | 20            |  
  And itens com menos de 20 visualizações não são exibidos. 


Scenario: Resolver empate no número de visualizações  
  Given existem itens cadastrados com visualizações iguais  
  And a lista de itens é:  
    | Nome                    | Visualizações | Data de cadastro   |  
    | Receita de Bolo         | 150           | 2024-12-01         |  
    | Como fazer Strogonoff   | 150           | 2024-11-28         |  
    | Feijoada Tradicional    | 200           | 2024-11-25         |  
  When acesso a seção "Mais vistos/lidos"  
  Then o sistema resolve empates priorizando a data de cadastro mais recente:  
    | Posição | Nome                    | Visualizações |  
    | 1º      | Feijoada Tradicional    | 200           |  
    | 2º      | Receita de Bolo         | 150           |  
    | 3º      | Como fazer Strogonoff   | 150           |  


Scenario: Exibir destaque visual para os itens mais vistos  
  Given existem itens na lista "Mais vistos/lidos" com visualizações significativas  
  And a lista de itens é:  
    | Nome                    | Visualizações |  
    | Feijoada Tradicional    | 200           |  
    | Receita de Bolo         | 150           |  
    | Como fazer Strogonoff   | 120           |  
  When acesso a seção "Mais vistos/lidos"  
  Then os itens exibidos incluem:  
    | Posição | Nome                    | Visualizações | Destaque         |  
    | 1º      | Feijoada Tradicional    | 200           | Ícone de troféu  |  
    | 2º      | Receita de Bolo         | 150           | Ícone de estrela |  



# Service 

Scenario: Serviço retorna os itens mais vistos do período padrão  
  Given existem itens cadastrados com números de visualizações semanais  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações |  
    | Receita de Bolo         | 150           |  
    | Como fazer Strogonoff   | 120           |  
    | Feijoada Tradicional    | 200           |  
    | Salada de Frutas        | 90            |  
  When envio uma requisição GET para "/mais-vistos" sem especificar o período  
  Then o serviço retorna os itens mais vistos da última semana:  
    | Nome                    | Visualizações | Posição |  
    | Feijoada Tradicional    | 200           | 1º      |  
    | Receita de Bolo         | 150           | 2º      |  
    | Como fazer Strogonoff   | 120           | 3º      |  


Scenario: Serviço retorna os itens mais vistos das últimas 24 horas  
  Given existem itens cadastrados com visualizações nas últimas 24 horas  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações |  
    | Receita de Bolo         | 15            |  
    | Como fazer Strogonoff   | 30            |  
    | Feijoada Tradicional    | 45            |  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | ultimas-24-horas |  
  Then o serviço retorna os itens mais vistos das últimas 24 horas:  
    | Nome                    | Visualizações | Posição |  
    | Feijoada Tradicional    | 45            | 1º      |  
    | Como fazer Strogonoff   | 30            | 2º      |  


Scenario: Serviço resolve empates no número de visualizações  
  Given existem itens cadastrados com o mesmo número de visualizações  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações | Data de Cadastro |  
    | Receita de Bolo         | 150           | 2024-12-01       |  
    | Como fazer Strogonoff   | 150           | 2024-11-28       |  
    | Feijoada Tradicional    | 200           | 2024-11-25       |  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | ultima-semana |  
  Then o serviço retorna os itens ordenados por visualizações e data de cadastro:  
    | Nome                    | Visualizações | Posição |  
    | Feijoada Tradicional    | 200           | 1º      |  
    | Receita de Bolo         | 150           | 2º      |  
    | Como fazer Strogonoff   | 150           | 3º      |  


Scenario: Serviço ignora itens com menos de 20 visualizações  
  Given existem itens cadastrados com números variados de visualizações  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações |  
    | Receita de Bolo         | 25            |  
    | Como fazer Strogonoff   | 15            |  
    | Feijoada Tradicional    | 30            |  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | ultima-semana |  
  Then o serviço retorna apenas itens com 20 ou mais visualizações:  
    | Nome                    | Visualizações | Posição |  
    | Feijoada Tradicional    | 30            | 1º      |  
    | Receita de Bolo         | 25            | 2º      |  


Scenario: Serviço retorna itens mais vistos do último mês  
  Given existem itens cadastrados com visualizações no último mês  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações |  
    | Receita de Bolo         | 200           |  
    | Como fazer Strogonoff   | 180           |  
    | Feijoada Tradicional    | 250           |  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | ultimo-mes |  
  Then o serviço retorna os itens mais vistos do último mês:  
    | Nome                    | Visualizações | Posição |  
    | Feijoada Tradicional    | 250           | 1º      |  
    | Receita de Bolo         | 200           | 2º      |  
    | Como fazer Strogonoff   | 180           | 3º      |  


Scenario: Serviço retorna erro para parâmetro de período inválido  
  Given o serviço aceita apenas os períodos: "ultimas-24-horas", "ultima-semana", "ultimo-mes"  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | invalido       |  
  Then o serviço retorna um erro HTTP 400 com a mensagem "Período inválido".  


Scenario: Serviço retorna lista vazia ao não encontrar itens elegíveis  
  Given existem itens cadastrados, mas nenhum possui mais de 20 visualizações  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações |  
    | Receita de Bolo         | 15            |  
    | Como fazer Strogonoff   | 10            |  
    | Feijoada Tradicional    | 5             |  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | ultima-semana |  
  Then o serviço retorna uma lista vazia.  

#opcional
Scenario: Serviço retorna itens com destaque adicional  
  Given existem itens cadastrados com visualizações elevadas  
  And a lista de itens no sistema é:  
    | Nome                    | Visualizações |  
    | Receita de Bolo         | 150           |  
    | Como fazer Strogonoff   | 120           |  
    | Feijoada Tradicional    | 200           |  
  When envio uma requisição GET para "/mais-vistos" com o parâmetro:  
    | periodo    | ultima-semana |  
  Then o serviço retorna os itens com destaques visuais:  
    | Nome                    | Visualizações | Posição | Destaque         |  
    | Feijoada Tradicional    | 200           | 1º      | Etiqueta Troféu  |  
    | Receita de Bolo         | 150           | 2º      | Etiqueta Estrela |  
    | Como fazer Strogonoff   | 120           | 3º      | Etiqueta Estrela |  
