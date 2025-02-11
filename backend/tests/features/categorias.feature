# language: pt

Funcionalidade: Gerenciamento de Categorias
  Como um administrador do sistema
  Eu quero poder gerenciar as categorias do cardápio
  Para manter o menu organizado

  # Cenários de Listagem
  Cenário: Listar todas as categorias
    Dado que existem categorias cadastradas no sistema
    Quando eu faço uma requisição GET para "/categories"
    Então devo receber uma lista com todas as categorias cadastradas
    E o código de status da resposta deve ser 200

  # Cenários de Busca
  Cenário: Buscar uma categoria específica
    Dado que existe uma categoria com id "1"
    Quando eu faço uma requisição GET para "/categories/1"
    Então devo receber os detalhes da categoria
    E o código de status da resposta deve ser 200

  Cenário: Buscar uma categoria inexistente
    Quando eu faço uma requisição GET para "/categories/999"
    Então o código de status da resposta deve ser 404
    E a resposta deve conter a mensagem de erro "Categoria não encontrada"

  Cenário: Buscar categoria com ID inválido
    Quando eu faço uma requisição GET para "/categories/abc"
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "ID inválido"

  # Cenários de Criação
  Cenário: Criar uma nova categoria com sucesso
    Quando eu faço uma requisição POST para "/categories" com os dados:
      | name        | Vegana         |
      | description | Pratos veganos |
    Então o código de status da resposta deve ser 201
    E a resposta deve conter uma categoria com nome "Vegana"

  Cenário: Tentar criar categoria sem nome
    Quando eu faço uma requisição POST para "/categories" com os dados:
      | description | Pratos veganos |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome da categoria é obrigatório"

  Cenário: Tentar criar categoria com nome muito curto
    Quando eu faço uma requisição POST para "/categories" com os dados:
      | name        | A            |
      | description | Descrição    |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome deve ter pelo menos 2 caracteres"

  Cenário: Tentar criar categoria com nome muito longo
    Quando eu faço uma requisição POST para "/categories" com os dados:
      | name        | Esta é uma categoria com um nome extremamente longo que não deveria ser aceito pelo sistema |
      | description | Descrição    |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome não pode ter mais que 50 caracteres"

  Cenário: Tentar criar categoria com nome duplicado
    Dado que existe uma categoria com nome "Carnes"
    Quando eu faço uma requisição POST para "/categories" com os dados:
      | name        | Carnes      |
      | description | Nova carnes |
    Então o código de status da resposta deve ser 409
    E a resposta deve conter a mensagem de erro "Categoria já existe"

  Cenário: Tentar criar categoria com descrição muito longa
    Quando eu faço uma requisição POST para "/categories" com os dados:
      | name        | Teste |
      | description | Esta é uma descrição extremamente longa que ultrapassa o limite máximo permitido pelo sistema. Precisamos garantir que as descrições sejam concisas e objetivas para manter a qualidade dos dados. Por isso, deve-se tentar novamente o processo!!! |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Descrição não pode ter mais que 200 caracteres"

  # Cenários de Atualização
  Cenário: Atualizar uma categoria existente
    Dado que existe uma categoria com id "1"
    Quando eu faço uma requisição PUT para "/categories/1" com os dados:
      | name        | Carnes Premium |
      | description | Carnes nobres  |
    Então o código de status da resposta deve ser 200
    E a resposta deve conter uma categoria com nome "Carnes Premium"

  Cenário: Tentar atualizar categoria inexistente
    Quando eu faço uma requisição PUT para "/categories/999" com os dados:
      | name        | Teste     |
      | description | Descrição |
    Então o código de status da resposta deve ser 404
    E a resposta deve conter a mensagem de erro "Categoria não encontrada"

  Cenário: Tentar atualizar categoria com nome duplicado
    Dado que existe uma categoria com nome "Massas"
    Quando eu faço uma requisição PUT para "/categories/1" com os dados:
      | name        | Massas    |
      | description | Descrição |
    Então o código de status da resposta deve ser 409
    E a resposta deve conter a mensagem de erro "Já existe uma categoria com esse nome"

  Cenário: Tentar atualizar categoria com nome vazio
    Quando eu faço uma requisição PUT para "/categories/1" com os dados:
      | name        |           |
      | description | Descrição |
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "Nome da categoria é obrigatório"

  # Cenários de Exclusão
  Cenário: Deletar uma categoria
    Dado que existe uma categoria com id "2"
    E que a categoria não está vinculada a nenhum prato
    Quando eu faço uma requisição DELETE para "/categories/2"
    Então o código de status da resposta deve ser 204

  Cenário: Tentar deletar categoria inexistente
    Quando eu faço uma requisição DELETE para "/categories/999"
    Então o código de status da resposta deve ser 404
    E a resposta deve conter a mensagem de erro "Categoria não encontrada"

  Cenário: Tentar deletar categoria vinculada a pratos
    Dado que existe uma categoria com id "1"
    E que a categoria está vinculada a pratos
    Quando eu faço uma requisição DELETE para "/categories/1"
    Então o código de status da resposta deve ser 409
    E a resposta deve conter a mensagem de erro "Não é possível excluir: categoria está vinculada a pratos"

  Cenário: Tentar deletar categoria com ID inválido
    Quando eu faço uma requisição DELETE para "/categories/abc"
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "ID inválido"

  Cenário: Buscar categoria com caracteres especiais no ID
    Quando eu faço uma requisição GET para "/categories/@#$"
    Então o código de status da resposta deve ser 400
    E a resposta deve conter a mensagem de erro "ID inválido"