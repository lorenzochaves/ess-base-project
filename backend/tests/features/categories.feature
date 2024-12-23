#Gerência de categorias
Feature: Categorias

As um usuário com permissão de administrador
I want criar, editar e deletar Categorias
So that eu possa gerenciar as Categorias no sistema
  

Scenario: Cadastro de categoria de prato bem sucedida (sem descrição e ícone) - GUI

    Given o administrador "Lorenzo" está na página "Gerenciamento de categorias"
    And a categoria "Sobremesas" não está listada em "Gerenciamento de categorias"
    When o administrador seleciona a opção "Criar nova categoria"
    And preenche o campo "Nome da categoria" com "Sobremesas"
    And salva as alterações
    Then a categoria "Sobremesas" é exibida na lista de categorias disponíveis


Scenario: Cadastro de categoria de prato bem-sucedida - Serviço

  Given a lista inicial de categorias é:
    | name        | description             | icon               |
    | Veganos     | Culinária vegana        | carnes.png         |
    | Carnes      | Carnes diversas         | veganos.png        |

  When o administrador faz uma requisição "POST" para  "/categories" com os seguintes dados:
    """
    {
      "name": "Sobremesas",
      "description": "Doces e bolos",
      "icon": "sobs.png"
    }
    """
  Then a status da resposta deve ser "201"
  And o JSON da resposta deve conter um campo "code" com o valor "UPDATED_CATEGORY"
  And a lista atualizada de categorias deve ser:
    | name        | description             | icon               |
    | Veganos     | Culinária vegana        | carnes.png         |
    | Carnes      | Carnes diversas         | veganos.png        |
    | Sobremesas  | Doces e bolos           | sobs.png           |

Scenario: Editar nome de categoria existente - GUI
 
    Given o administrador "Lorenzo" está na página "Gerenciamento de categorias"
    And a categoria "Doces" está listada em "Gerenciamento de categorias"
    When o administrador escolhe "Editar" para a categoria "Doces"
    And altera o campo "Nome da categoria" para "Sobremesas"
    And salva as alterações
    Then a categoria "Doces" não está mais presente na lista de categorias
    And o sistema exibe a categoria "Sobremesas" na lista de categorias disponíveis



Scenario: Editar nome, descrição e ícone de uma categoria existente - GUI

    Given o administrador "Lorenzo" está na página "Gerenciamento de categorias"
    And a categoria de nome "Doces", descrição "Sobremesas variadas" e o ícone "icone-doces.png" está listada em "Gerenciamento de categorias"
    When o administrador seleciona a opção "Editar" para a categoria "Doces"
    And altera os campos "Nome da categoria" para "Sobremesas", "Descrição" para "Sobremesas doces e deliciosas" e "Ícone" para o arquivo "sobremesas.png"
    And clica em "Salvar"
    Then o sistema exibe a mensagem de confirmação "Tem certeza que deseja salvar as alterações?"
    When o administrador seleciona "Sim"
    Then a categoria "Doces" não está mais presente na lista
    And o sistema exibe a categoria "Sobremesas" na lista de categorias disponíveis com a descrição "Sobremesas doces e deliciosas" e o ícone "sobremesas.png"



Scenario: Excluir categorias existentes que possuem pratos vinculados - GUI

    Given o administrador "Lorenzo" está na página "Gerenciamento de categorias"
    And a categoria "Doces" está listada em "Gerenciamento de categorias"
    And os pratos "Bolo" e "Pé de Moleque" estão associados à categoria "Doces"
    When o administrador seleciona a opção "Excluir" para a categoria "Doces"
    And confirma a exclusão da categoria
    Then o sistema remove a categoria "Doces" da lista de categorias disponíveis
    And os pratos "Bolo" e "Pé de Moleque" são automaticamente movidos para a categoria "Sem Categoria"
    And o sistema exibe uma mensagem "Categoria 'Doces' excluída com sucesso. Os pratos associados foram movidos para 'Sem Categoria'".


Scenario: Nome duplicado ao cadastrar categoria - GUI

    Given o administrador "Lorenzo" está na página "Gerenciamento de categorias"
    And a categoria "Sobremesas" está listada em "Gerenciamento de categorias"
    When o administrador acessa "Gerenciamento de categorias"
    And seleciona a opção "Criar nova categoria"
    And preenche o campo "Nome da categoria" com "Sobremesas"
    And salva as alterações
    Then o sistema exibe a mensagem de erro "O nome da categoria já existe. Por favor, escolha outro nome."
    And a nova categoria não é adicionada à lista de categorias disponíveis
    And o sistema mantém o administrador na página "Gerenciamento de categorias".

Scenario: Nome duplicado ao cadastrar categoria - Serviço

  Given a lista de Categoria é:
    | name        | description             | icon               |
    | Veganos     | Culinária vegana        | carnes.png         |
    | Carnes      | Carnes diversas         | veganos.png        |
  When o usuário faz uma requisição "POST" para "category" com os seguintes dados:
    | name        | description             | icon               |
    | Carnes      |                         |                    |
  Then o status da resposta deve ser "400"
  And o JSON da resposta deve conter um campo "code" com o valor "DUPLICATED_CATEGORY"
  And a lista de Categoria deve ser:
    | name        | description             | icon               |
    | Veganos     | Culinária vegana        | carnes.png         |
    | Carnes      | Carnes diversas         | veganos.png        |

Scenario: Cancelar a edição de uma categoria - GUI

    Given o administrador "Lorenzo" está na página "Gerenciamento de categorias"
    And a categoria "Sobremesas" está listada em "Gerenciamento de categorias"
    When o administrador seleciona a opção "Editar" para a categoria "Sobremesas"
    And altera o campo "Nome da categoria" para "Sobremesas novas"
    And clica em "Salvar"
    Then o sistema exibe a mensagem de confirmação "Tem certeza que deseja salvar as alterações?"
    When o administrador seleciona "Não"
    Then o sistema mantém o administrador na página "Gerenciamento de categorias"
    And a categoria "Sobremesas" está listada em "Gerenciamento de categorias" com o nome original "Sobremesas"

Scenario: Editar nome, descrição e ícone de uma categoria existente - Serviço


    Given a categoria com nome "Doces", descrição "Sobremesas variadas", e ícone "icone-doces.png" está na base de dados
    When o administrador faz uma requisição "PUT" para "category/Doces" com os seguintes dados:
        | nome         | Sobremesas                    |
        | descrição    | Sobremesas doces e deliciosas |
        | ícone        | sobremesas.png                |
    Then o status da resposta deve ser "200"
    And o JSON da resposta deve conter:
        | campo         | valor                                        |
        | msg           | Categoria atualizada com sucesso             |
        | confirmation  | true                                         |

    And a categoria "Doces" não deve mais existir na base de dados
    And a categoria "Sobremesas" deve estar na base de dados com os seguintes atributos:
        | nome         | Sobremesas                    |
        | descrição    | Sobremesas doces e deliciosas |
        | ícone        | sobremesas.png                |


