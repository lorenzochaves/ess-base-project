Feature: Favoritos
    As um usuário do sistema
    I want adicionar, visualizar, remover e organizar pratos na minha lista de favoritos
    So that eu possa acessar rapidamente os pratos que mais gosto ou desejo consumir novamente.

Scenario: Adicionar prato à lista de favoritos - GUI
    Given o usuário "Alan" está autenticado no sistema  
    And o prato "Lasanha de Frango" está listado na página "Feed"  
    And o prato "Lasanha de Frango" não está na lista de favoritos do usuário  
    When o usuário clica no ícone de "Favoritar" associado ao prato "Lasanha de Frango"  
    Then o sistema exibe o ícone de "Favoritado" no prato  
    And o prato "Lasanha de Frango" é adicionado à lista de favoritos do usuário

Scenario: Remover prato da lista de favoritos
    Given o usuário "Alan" está autenticado no sistema
    And o prato "Lasanha de Frango" está na lista de favoritos do usuário
    When o usuário clica no ícone "Desfavoritar" associado ao prato
    Then o sistema remove o prato da lista de favoritos
    And o ícone volta a exibir "🤍 Favoritar"
    And uma mensagem "Prato removido dos favoritos com sucesso" é exibida.

Scenario: Visualizar lista de pratos favoritos
    Given o usuário "Alan" está autenticado no sistema
    And a lista de favoritos do usuário contém os seguintes pratos:
        | Prato               |
        | Lasanha de Frango   |
        | Risoto de Cogumelos |
    When o usuário acessa a página "Meus Favoritos"
    Then o sistema exibe a lista com os pratos favoritados:
        | Lasanha de Frango   |
        | Risoto de Cogumelos |