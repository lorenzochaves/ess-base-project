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

Scenario: Adicionar prato duplicado aos favoritos
    Given o usuário "Alan" está autenticado no sistema
    And o prato "Lasanha de Frango" já está na lista de favoritos
    When o usuário clica novamente no ícone "Favoritar" associado ao prato
    Then o sistema não permite a duplicação
    And uma mensagem "Este prato já está nos seus favoritos" é exibida.

Scenario: Limpar todos os pratos da lista de favoritos
    Given o usuário "Alan" está autenticado no sistema
    And existem pratos na lista de favoritos:
        | Prato               |
        | Lasanha de Frango   |
        | Risoto de Cogumelos |
    When o usuário clica na opção "Limpar Favoritos"
    Then o sistema remove todos os pratos da lista de favoritos
    And exibe uma mensagem "Sua lista de favoritos foi limpa com sucesso"
    And a lista de favoritos fica vazia.

Scenario: Favoritar prato enquanto navega por categorias
    Given o usuário "Alan" está autenticado no sistema
    And o usuário está navegando na categoria "Veganos"
    And o prato "Risoto de Cogumelos" está listado na página
    When o usuário clica no ícone "Favoritar" associado ao prato "Risoto de Cogumelos"
    Then o prato "Risoto de Cogumelos" é adicionado à lista de favoritos
    And o sistema exibe o ícone "❤️ Favoritado" no prato
    And exibe a mensagem "Prato adicionado aos favoritos com sucesso".