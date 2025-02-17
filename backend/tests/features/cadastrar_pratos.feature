# # Cadastrar Pratos
# Feature: Cadastrar prato no sistema
#   As um administrador
#   I want poder cadastrar novos pratos 
#   So that eu possa adicionar pratos com informações como nome, descrição, categoria, ingredientes

# # GUI Scenarios

# Scenario: Cadastro de prato com sucesso
#   Given o administrador "Lorenzo" está logado no sistema
#   And as categorias de pratos são "Entradas", "Pratos principais" e "Sobremesas"
#   When o administrador seleciona a opção "Cadastrar novo prato"
#   And preenche os campos obrigatórios da lista de pratos "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "Spaghetti Carbonara", "Prato típico italiano com molho cremoso.", "Pratos principais", "Macarrão, ovos, bacon, queijo parmesão" respectivamente
#   Then uma mensagem de cadastro com sucesso de "Spaghetti Carbonara" é exibida com as informações do prato  

# Scenario: Cadastro de prato com falha devido a campos obrigatórios vazios
#   Given o administrador "Lorenzo" está logado no sistema
#   And existem categorias de pratos como "Entradas", "Pratos principais" e "Sobremesas"
#   When o administrador seleciona a opção "Cadastrar novo prato"
#   And preenche os campos obrigatórios "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "", "Prato sem nome", "Pratos principais", "Macarrão, ovos, bacon" respectivamente
#   Then o sistema exibe uma mensagem de erro indicando que o campo "Nome" é obrigatório
#   And o administrador "Lorenzo" é redirecionado para tela de cadastro de prato

# # Service Scenarios
# Scenario: Cadastro de prato com todos os dados obrigatórios
#   Given o administrador "Lorenzo" está logado no sistema
#   And existem categorias de pratos como "Entradas", "Pratos principais" e "Sobremesas"
#   When o administrador envia os dados do prato "Spaghetti Carbonara" com os seguintes campos:
#     And preenche os campos obrigatórios "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "Spaghetti Carbonara", "Prato típico italiano com molho cremoso.", "Pratos principais", "Macarrão, ovos, bacon, queijo parmesão"
#   Then o sistema cadastra o prato "Spaghetti Carbonara" no banco de dados
#   And o prato "Spaghetti Carbonara" é incluído na lista de pratos cadastrados com as informações "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "Spaghetti Carbonara", "Prato típico italiano com molho cremoso.", "Pratos principais", "Macarrão, ovos, bacon, queijo parmesão"


# Scenario: Cadastro de prato com falha devido a campos obrigatórios vazios
#   Given o administrador "Lorenzo" está logado no sistema
#   When o administrador tenta enviar o prato "Spaghetti Carbonara" com os seguintes campos obrigatórios vazios:
#     And preenche os campos obrigatórios "Nome", "Descrição", "Categoria", "Ingredientes" com os valores "", "Prato sem nome", "Pratos principais", "Macarrão, ovos, bacon"
#   Then o sistema não cadastra o prato
#   And o sistema exibe uma mensagem de erro indicando que o campo "Nome" é obrigatório


# language: pt

Funcionalidade: Cadastro de Pratos
  Como administrador do sistema
  Eu quero poder cadastrar novos pratos no cardápio
  Para manter o menu atualizado com opções variadas

  # Cenários de Criação
  Cenário: Criar prato com sucesso
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | Frango Dobroo Parmegiana |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 201
    E a resposta deve conter um prato com nome "Frango Dobroo Parmegiana"

  Cenário: Criar prato sem nome
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato é obrigatório"

  Cenário: Criar prato com nome muito curto
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | A |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato deve ter pelo menos 2 caracteres"

  Cenário: Criar prato com nome muito longo
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | Esta é uma descrição extremamente longa para o nome de um prato e não deveria ser aceita. |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato não pode ter mais que 50 caracteres"

  Cenário: Criar prato com categoria inexistente
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | Doritos com carne |
      | description | Tortilhas de milho recheadas com carne temperada e acompanhamentos. |
      | category    | Comida Mexicana |
      | ingredients | tortilhas de milho, carne moída, alface, tomate, queijo cheddar |
      | rating      | 4.1 |
      | views       | 12 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Categoria não encontrada"

  Cenário: Criar prato com rating inválido
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | Banoffee |
      | description | Bolo macio e úmido com cobertura de chocolate. |
      | category    | Italiana |
      | ingredients | farinha de trigo, açúcar, ovos, chocolate em pó, manteiga |
      | rating      | 5.5 |
      | views       | 925 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Rating deve ser entre 0 e 5"

  Cenário: Criar prato com views inválido
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | Sushi de Feijao |
      | description | Seleção de sushi com peixes frescos e feijao temperado. |
      | category    | Japonesa |
      | ingredients | arroz para sushi, salmão, atum, alga nori, feijao |
      | rating      | 4.8 |
      | views       | -5 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Views não pode ser negativo"


  Cenário: Criar prato com ingredientes vazios
    Quando eu faço uma requisição POST para "/dishes" com os dados:
      | name        | Lasanha de Jaca |
      | description | Camadas de massa intercaladas com molho de jaca e queijo. |
      | category    | Italiana |
      | ingredients | |
      | rating      | 4.5 |
      | views       | 376 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Ingredientes são obrigatórios"

  Cenário: Buscar prato por ID
    Quando eu faço uma requisição GET para "/dishes/1"
    Então o código de status da resposta deve ser 200
    E a resposta deve conter os dados do prato

  Cenário: Buscar prato por ID inválido
    Quando eu faço uma requisição GET para "/dishes/14"
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Prato não encontrado"
