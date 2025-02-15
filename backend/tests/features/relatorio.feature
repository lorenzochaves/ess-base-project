# apenas para mostrar no relatório## BUSCA COM FILTROS        Permite que os usuários pesquisem conteúdos específicos, aplicando filtros como categorias, preço ou avaliação
# # GUI
# Scenario: Filtrar itens utilizando apenas um filtro  
#   Given estou na página de busca de itens e a barra lateral de filtros está visível   
#   And a lista de itens no menu é:
#   | Nome                    | Nota          | Categoria         | Popularidade          |
#   | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |


# Scenario: Serviço retorna itens que correspondem ao nome buscado  
#   Given existem itens cadastrados com o nome "Bolo de Chocolate"
#   And a lista de itens no menu é:
#   | Nome                    | Nota          | Categoria         | Popularidade          |
#   | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |
#   | Doce de leite           | 4,3           | Sobremesa         | Melhores avaliados    |
#   | Feijoada                | 4,6           | Almoço            | Melhores avaliados    |
#   | Bolo de Chocolate       | 4,0           | Sobremesa         | Melhores avaliadoa    |  
#   When envio uma requisição GET para "/busca" com o parâmetro:  
#     | nome_prato | Bolo de Chocolate |  
#   Then o serviço retorna os itens:
#   | Nome                    | Nota          |
#   | Bolo de Chocolate       | 4,0           |


#  Scenario: Serviço ignora filtros com valores inválidos  
#   Given o sistema possui filtros válidos para busca  
#   And a lista de itens no menu é:  
#     | Nome                    | Nota          | Categoria         | Popularidade          |  
#     | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
#     | Doce de leite           | 4,3           | Sobremesa         | Mais curtidos         |  
#   When envio uma requisição GET para "/busca" com os parâmetros:  
#     | categoria   | Inexistente     |  
#     | avaliacao   | 6               |  
#   Then o serviço ignora os filtros inválidos  
#   And retorna os itens disponíveis com base nos filtros válidos restantes:  
#     | Nome                    | Nota          |  
#     | Strogonoff de carne     | 4,5           |  
#     | Doce de leite           | 4,3           |  
  


#   Scenario: Serviço retorna itens com múltiplos filtros simultâneos e nenhuma correspondência  
#   Given existem itens cadastrados com categorias e popularidade diversas  
#   And a lista de itens no menu é:  
#     | Nome                    | Nota          | Categoria         | Popularidade          |  
#     | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
#     | Doce de leite           | 4,3           | Sobremesa         | Mais curtidos         |  
#     | Feijoada                | 4,6           | Almoço            | Mais acessados        |  
#   When envio uma requisição GET para "/busca" com os parâmetros:  
#     | categoria    | Café da manhã     |  
#     | popularidade | Mais curtidos     |  
#   Then o serviço retorna a mensagem:  
#     | mensagem     | Nenhum item encontrado |  
#   And nenhum item é retornado.  


# coisa novaaaaaaaa
# dfsadsadas
# dasdasds
# asdsadsa
# dassadsadsad
