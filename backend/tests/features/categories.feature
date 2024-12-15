Feature: Usuário administrador

# Gerência de pratos

Scenario: Cadastro de categoria de prato bem sucedida (sem descrição e ícone)

    Given o administrador "Lorenzo" está autenticado no sistema com o login "lfc4" e a senha "12345"
    And está na página "Painel de controle"
    And a categoria "Sobremesas" não está listada em "Gerenciamento de categorias"
    When o administrador acessa "Gerenciamento de categorias"
    And seleciona "Criar nova categoria"
    And preenche o campo "Nome da categoria" com "Sobremesas"
    And confirma clicando em "Salvar"
    Then a categoria "Sobremesas" é exibida na lista de categorias disponíveis


Scenario: Editar nome de categoria existente
 
    Given o administrador "Lorenzo" está autenticado no sistema com o login "lfc4" e a senha "12345"
    And está na página "Painel de controle"
    And a categoria "Doces" está listada em "Gerenciamento de categorias"
    When o administrador acessa "Gerenciamento de categorias"
    And escolhe a opção "Editar" para a categoria "Doces"
    And altera o campo "Nome da categoria" para "Sobremesas"
    And confirma a alteração clicando em "Salvar"
    Then a categoria "Doces" não está mais presente na lista de categorias
    And o sistema exibe a categoria "Sobremesas" na lista de categorias disponíveis

Scenario: Editar nome, descrição e ícone de uma categoria existente

    Given o administrador "Lorenzo" está autenticado no sistema com o login "lfc4" e a senha "12345"
    And está na página "Painel de controle"
    And a categoria "Doces" está listada em "Gerenciamento de categorias" com a descrição "Sobremesas variadas" e o ícone "icone-doces.png"
    When o administrador acessa "Gerenciamento de categorias"
    And seleciona a opção "Editar" para a categoria "Doces"
    And altera o campo "Nome da categoria" para "Sobremesas"
    And altera o campo "Descrição" para "Sobremesas doces e deliciosas"
    And altera o campo "Ícone" para o arquivo "sobremesas.png"
    And clica em "Salvar"
    And o sistema exibe a mensagem de confirmação "Tem certeza que deseja salvar as alterações?"
    And o administrador seleciona "Sim"
    Then a categoria "Doces" não está mais presente na lista
    And o sistema exibe a categoria "Sobremesas" na lista de categorias disponíveis com a descrição "Sobremesas doces e deliciosas" e o ícone "sobremesas.png"


Scenario: Excluir categorias existentes que possuem pratos vinculados

    Given o administrador "Lorenzo" está autenticado no sistema com o login "lfc4" e a senha "12345"
    And está na página "Painel de controle"
    And a categoria "Doces" está listada em "Gerenciamento de categorias"
    And os pratos "Bolo" e "Pé de Moleque" estão associados à categoria "Doces"
    And a categoria "Sem Categoria" já existe no sistema
    When o administrador acessa "Gerenciamento de categorias"
    And seleciona a opção "Excluir" para a categoria "Doces"
    And confirma a exclusão clicando em "Sim" na mensagem de confirmação
    Then o sistema remove a categoria "Doces" da lista de categorias disponíveis
    And os pratos "Bolo" e "Pé de Moleque" são automaticamente movidos para a categoria "Sem Categoria"
    And o sistema exibe uma mensagem "Categoria 'Doces' excluída com sucesso. Os pratos associados foram movidos para 'Sem Categoria'".
    And o sistema mantém o administrador na página "Gerenciamento de categorias".

Scenario: Nome duplicado ao cadastrar categoria

    Given o administrador "Lorenzo" está autenticado no sistema com o login "lfc4" e a senha "12345"
    And está na página "Painel de controle"
    And a categoria "Sobremesas" está listada em "Gerenciamento de categorias"
    When o administrador acessa "Gerenciamento de categorias"
    And seleciona a opção "Criar nova categoria"
    And preenche o campo "Nome da categoria" com "Sobremesas"
    And confirma a ação clicando em "Salvar"
    Then o sistema exibe a mensagem de erro "O nome da categoria já existe. Por favor, escolha outro nome."
    And a nova categoria não é adicionada à lista de categorias disponíveis
    And o sistema mantém o administrador na página "Gerenciamento de categorias".


Scenario: Cancelar a edição de uma categoria
    Given o administrador "Lorenzo" está autenticado no sistema com o login "lfc4" e a senha "12345"
    And está na página "Painel de controle"
    And a categoria "Sobremesas" está listada em "Gerenciamento de categorias"
    When o administrador acessa "Gerenciamento de categorias"
    And seleciona a opção "Editar" para a categoria "Sobremesas"
    And altera o campo "Nome da categoria" para "Sobremesas novas"
    And clica em "Salvar"
    And o sistema exibe a mensagem de confirmação "Tem certeza que deseja salvar as alterações?"
    And o administrador seleciona "Não"
    Then o sistema mantém o administrador na página "Gerenciamento de categorias"
    And a categoria "Sobremesas" está exibida lista de categorias disponíveis