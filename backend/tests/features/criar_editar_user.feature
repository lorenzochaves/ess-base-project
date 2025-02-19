Feature: Cadastro de Usuários
As a usuário do sistema
I want to cadastrar uma conta com meu nome, meu user e minha senha no sistema 
So that eu posso me comunicar com outros usuários

# Service Scenarios

    Scenario: Cadastro com sucesso
    Given O usuário quer realizar um cadastro no sistema
    When uma requisição POST com um JSON com nome "Vaca", login "rfbc", senha "sa12303123123123" 
    And esta requisição for enviada para "users"
    Then o statuscode deve ser "201"
    And o JSON da resposta deve conter nome "Vaca", login "rfbc", senha "sa12303123123123"

    Scenario: Cadastro sem sucesso por senha pequena demais
    Given O usuário quer realizar um cadastro no sistema
    When uma requisição POST com um JSON com nome "Vaca", login "jvcn", senha "vaca123" 
    And esta requisição for enviada para "users"
    Then o statuscode deve ser "400"
    And o JSON deve ser "A senha deve ter pelo menos 8 caracteres" 

    Scenario: Cadastro sem sucesso por falta de login
    Given O usuário quer realizar um cadastro no sistema
    When uma requisição POST com um JSON com nome "Vaca", senha "vaca12345" 
    And esta requisição for enviada para "users"
    Then o statuscode deve ser "400"
    And o JSON deve ser "Login não pode ser vazio" 


    Scenario: Edição bem-sucedida do perfil  
    Given O usuário quer editar seu perfil no sistema  
    When uma requisição PUT para editar o id 1 com nome "Vaca Carlos", login "jvcn"
    And esta requisição for enviada para "users"  
    Then o statuscode deve ser "200"  
    And o JSON da resposta deve conter id 1 com nome "Vaca Carlos", login "jvcn"

    Scenario: Edição sem sucesso por ID não existente
    Given O usuário quer editar seu perfil no sistema
    When uma requisição PUT para editar o id 999 não existente com nome "Carlos Souza", e login "joao.silva"
    And esta requisição for enviada para "users"
    Then o statuscode deve ser "404"
    And o JSON deve ser "Usuário não encontrado"
