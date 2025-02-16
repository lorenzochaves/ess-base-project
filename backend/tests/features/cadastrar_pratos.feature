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
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Frango à Parmegiana |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 201
    E a resposta deve conter um prato com nome "Frango à Parmegiana"

  Cenário: Criar prato sem nome
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato é obrigatório"

  Cenário: Criar prato com nome muito curto
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | A |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato deve ter pelo menos 2 caracteres"

  Cenário: Criar prato com nome muito longo
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Esta é uma descrição extremamente longa para o nome de um prato e não deveria ser aceita. |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato não pode ter mais que 50 caracteres"

  Cenário: Criar prato com categoria inexistente
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Tacos de Carne |
      | description | Tortilhas de milho recheadas com carne temperada e acompanhamentos. |
      | category    | Comida Mexicana |
      | ingredients | tortilhas de milho, carne moída, alface, tomate, queijo cheddar |
      | rating      | 4.1 |
      | views       | 12 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Categoria não encontrada"

  Cenário: Criar prato com rating inválido
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Bolo de Chocolate |
      | description | Bolo macio e úmido com cobertura de chocolate. |
      | category    | Sobremesas |
      | ingredients | farinha de trigo, açúcar, ovos, chocolate em pó, manteiga |
      | rating      | 5.5 |
      | views       | 925 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Rating deve ser entre 0 e 5"

  Cenário: Criar prato com views inválido
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Sushi Variado |
      | description | Seleção de sushi com peixes frescos e arroz temperado. |
      | category    | Japonês |
      | ingredients | arroz para sushi, salmão, atum, alga nori, molho de soja |
      | rating      | 4.8 |
      | views       | -5 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Views não pode ser negativo"

  Cenário: Criar prato com todos os campos obrigatórios preenchidos
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Lasanha de Carne |
      | description | Camadas de massa intercaladas com molho de carne e queijo. |
      | category    | Italiana |
      | ingredients | massa para lasanha, carne moída, molho de tomate, queijo muçarela, queijo parmesão |
      | rating      | 4.5 |
      | views       | 376 |
    Então o código de status da resposta deve ser 201
    E a resposta deve conter um prato com nome "Lasanha de Carne"

  # Cenários de Criação
  Cenário: Criar prato com nome contendo caracteres especiais
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Frango@Parmegiana |
      | description | Filé de frango empanado coberto com molho de tomate e queijo derretido. |
      | category    | Aves |
      | ingredients | frango, farinha de rosca, ovos, molho de tomate, queijo muçarela |  
      | rating      | 4.2 |
      | views       | 1000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato não pode conter caracteres especiais"

  Cenário: Criar prato com ingredientes vazios
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Lasanha de Carne |
      | description | Camadas de massa intercaladas com molho de carne e queijo. |
      | category    | Italiana |
      | ingredients | |
      | rating      | 4.5 |
      | views       | 376 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Ingredientes são obrigatórios"

  Cenário: Criar prato com dados de categoria incorretos
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Bolo de Chocolate |
      | description | Bolo macio e úmido com cobertura de chocolate. |
      | category    | Sobremesas@ |
      | ingredients | farinha de trigo, açúcar, ovos, chocolate em pó, manteiga |
      | rating      | 4.6 |
      | views       | 925 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Categoria contém caracteres inválidos"

  Cenário: Criar prato com rating em formato inválido (texto)
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Sushi Variado |
      | description | Seleção de sushi com peixes frescos e arroz temperado. |
      | category    | Japonês |
      | ingredients | arroz para sushi, salmão, atum, alga nori, molho de soja |
      | rating      | excelente |
      | views       | 253 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Rating deve ser um número"

  Cenário: Criar prato com views muito altas
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Feijoada |
      | description | Prato tradicional brasileiro com feijão preto e diversas carnes. |
      | category    | Brasileira |
      | ingredients | feijão preto, linguiça, carne seca, costela de porco, folhas de louro |
      | rating      | 4.7 |
      | views       | 1000000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Views são muito altas, limite excedido"

  Cenário: Criar prato com dados de rating e views fora do intervalo permitido
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Risoto de Cogumelos |
      | description | Risoto cremoso preparado com cogumelos frescos. |
      | category    | Italiana |
      | ingredients | arroz arbóreo, cogumelos, caldo de legumes, cebola, queijo parmesão |
      | rating      | -1 |
      | views       | 500000 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Rating deve ser entre 0 e 5" e "Views devem estar dentro de um limite razoável"

  Cenário: Criar prato com nome de categoria e prato idênticos
    Quando eu faço uma requisição POST para "/api/dishes" com os dados:
      | name        | Carnes |
      | description | Prato delicioso com várias carnes assadas. |
      | category    | Carnes |
      | ingredients | carne, sal, alho |
      | rating      | 4.5 |
      | views       | 450 |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome do prato não pode ser igual ao nome da categoria"

  Cenário: Buscar prato por ID
    Quando eu faço uma requisição GET para "/api/dishes/{id}"
    Então o código de status da resposta deve ser 200
    E a resposta deve conter os dados do prato
