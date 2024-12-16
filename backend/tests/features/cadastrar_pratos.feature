# Cadastrar Pratos
Feature: Cadastrar prato no sistema
  As um administrador
  I want poder cadastrar novos pratos 
  So that eu possa adicionar pratos com informações como nome, descrição, categoria, ingredientes

# GUI Scenarios

Scenario: Cadastro de prato com sucesso
  Given o administrador "Lorenzo" está logado no sistema
  And as categorias de pratos são "Entradas", "Pratos principais" e "Sobremesas"
  When o administrador seleciona a opção "Cadastrar novo prato"
  And preenche os campos obrigatórios da lista de pratos "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "Spaghetti Carbonara", "Prato típico italiano com molho cremoso.", "Pratos principais", "Macarrão, ovos, bacon, queijo parmesão" respectivamente
  Then uma mensagem de cadastro com sucesso de "Spaghetti Carbonara" é exibida com as informações do prato  

Scenario: Cadastro de prato com falha devido a campos obrigatórios vazios
  Given o administrador "Lorenzo" está logado no sistema
  And existem categorias de pratos como "Entradas", "Pratos principais" e "Sobremesas"
  When o administrador seleciona a opção "Cadastrar novo prato"
  And preenche os campos obrigatórios "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "", "Prato sem nome", "Pratos principais", "Macarrão, ovos, bacon" respectivamente
  Then o sistema exibe uma mensagem de erro indicando que o campo "Nome" é obrigatório
  And o administrador "Lorenzo" é redirecionado para tela de cadastro de prato

# Service Scenarios
Scenario: Cadastro de prato com todos os dados obrigatórios
  Given o administrador "Lorenzo" está logado no sistema
  And existem categorias de pratos como "Entradas", "Pratos principais" e "Sobremesas"
  When o administrador envia os dados do prato "Spaghetti Carbonara" com os seguintes campos:
    And preenche os campos obrigatórios "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "Spaghetti Carbonara", "Prato típico italiano com molho cremoso.", "Pratos principais", "Macarrão, ovos, bacon, queijo parmesão"
  Then o sistema cadastra o prato "Spaghetti Carbonara" no banco de dados
  And o prato "Spaghetti Carbonara" é incluído na lista de pratos cadastrados com as informações "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "Spaghetti Carbonara", "Prato típico italiano com molho cremoso.", "Pratos principais", "Macarrão, ovos, bacon, queijo parmesão"


Scenario: Cadastro de prato com falha devido a campos obrigatórios vazios
  Given o administrador "Lorenzo" está logado no sistema
  When o administrador tenta enviar o prato "Spaghetti Carbonara" com os seguintes campos obrigatórios vazios:
    And preenche os campos obrigatórios "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "", "Prato sem nome", "Pratos principais", "Macarrão, ovos, bacon"
  Then o sistema não cadastra o prato
  And o sistema exibe uma mensagem de erro indicando que o campo "Nome" é obrigatório
