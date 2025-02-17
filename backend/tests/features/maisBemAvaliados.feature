Feature: Mais Bem Avaliados
As a usuário do sistema
I want to visualizar os pratos mais bem avaliados pelos usuários
So that eu possa escolher refeições de melhor qualidade

    Scenario: Listagem dos pratos mais bem avaliados com sucesso  
    Given O usuário quer visualizar os pratos mais bem avaliados com sucesso  
    When uma requisição GET for enviada para "dishes/best-rated"  
    Then o status da resposta deve ser "200"
    And o JSON da resposta deve conter uma lista de pratos ordenados por nota média, do maior para o menor  

    Scenario: Listagem limitada a 5 pratos mais bem avaliados  
    Given O usuário quer visualizar os pratos mais bem avaliados  
    When uma requisição GET for enviada para o endereço "dishes/best-rated"  
    Then o status da resposta deve ser "200" e ser aceito 
    And o JSON da resposta deve conter no máximo 5 pratos, mesmo que existam mais pratos avaliados no sistema  

  Scenario: Visualizar o prato na posição 1 do ranking
    Given O usuário quer visualizar o prato na posição 1 dos mais bem avaliados
    When uma requisição GET for enviada para o endpoint "dishes/best-rated/1"
    Then o status da resposta deve ser "200 por hora"
    And o JSON da resposta deve conter o prato na posição 1 do ranking

