Feature: Exclusão de Usuários
    As an administrador do sistema
    I want to deletar um cadastro existente
    So that a conta seja removida do sistema

    Scenario: Exclusão de usuário com sucesso
        Given O administrador quer deletar um cadastro no sistema
        When uma requisição DELETE for enviada para "/users/1"
        Then o statusCode deverá ser "200"
        And o JSON deve conter a message "Usuário deletado com sucesso"

    Scenario: Tentativa de exclusão de usuário inexistente
        Given O administrador quer deletar um cadastro no sistema
        When uma requisição DELETE for enviada para "/users/999"
        Then o statusCode deverá ser "404"
        And o JSON deve conter a message "Usuário não encontrado"