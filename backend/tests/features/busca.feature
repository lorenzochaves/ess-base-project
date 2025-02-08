## BUSCA COM FILTROS        Permite que os usuários pesquisem conteúdos específicos, aplicando filtros como categorias, preço ou avaliação
# GUI
Scenario: Filtrar itens utilizando apenas um filtro  
  Given estou na página de busca de itens e a barra lateral de filtros está visível   
  And a lista de itens no menu é:
  | Nome                    | Nota          | Categoria         | Popularidade          |
  | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |
  | Doce de leite           | 4,3           | Sobremesa         | Melhores avaliados    |
  | Feijoada                | 4,6           | Almoço            | Melhores avaliados    |
  When seleciono "Sobremesa" no campo categoria
  Then os resultados exibidos são:
  | Nome                    | Nota          |
  | Doce de leite           | 4,3           |


Scenario: Filtrar itens utilizando múltiplas opções simultâneas  
  Given estou na página de busca de itens e a barra lateral de filtros está visível   
  And a lista de itens no menu é:
  | Nome                    | Nota          | Categoria         | Popularidade          |
  | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |
  | Strogonoff de frango    | 4,3           | Almoço            | Melhores avaliados    |
  | Strogonoff de avestruz  | 1,6           | Almoço            | Baixa avaliacao       |
  | Paçoca                  | 4,3           | Sobremesa         | Melhores avaliados    |
  When escrevo "Strogonoff"
  And seleciono "Melhores avaliados" no campo popularidade, "Almoço" no campo categoria e "4 estrelas ou mais" no campo avaliações  
  Then os resultados exibidos são:
  | Nome                    | Nota          |  
  | Strogonoff de carne     | 4,5           |
  | Strogonoff de frango    | 4,3           |


Scenario: Limpar todos os filtros da busca  
  Given estou na página de busca com filtros aplicados  
  And a barra lateral mostra "Popularidade: Mais acessados" e "Categoria: Bebidas"  
  When clico no botão "Limpar filtros"  
  Then todos os filtros aplicados são removidos  
  And os resultados exibem todos os itens disponíveis  


Scenario: Visualização da barra lateral de filtros  
  Given estou na página de busca de itens  
  When a página carrega  
  Then eu vejo a barra lateral com opções de filtro  
  And as opções incluem "Nome do prato", "Popularidade", "Categoria" e "Avaliações"  
  And há um botão "Limpar filtros" visível  


Scenario: Buscar itens utilizando o campo de texto "Nome do prato"  
  Given estou na página de busca de itens  
  When digito "Bolo de Chocolate" no campo "Nome do prato"  
  And pressiono Enter  
  Then os resultados exibem apenas itens com o nome "Bolo de Chocolate"  


Scenario: Aplicar filtros que não retornam nenhum resultado  
  Given estou na página de busca de itens  
  And o sistema possui os seguintes itens cadastrados:  
    | Nome                    | Nota  | Categoria         | Popularidade         |  
    | Strogonoff de carne     | 4.5   | Almoço            | Melhores avaliados   |  
    | Risoto de camarão       | 4.7   | Jantar            | Mais acessados       |  
  When seleciono "Café da manhã" no filtro de Categoria  
  And seleciono "4 estrelas ou mais" no filtro de Avaliações  
  Then uma mensagem é exibida: "Nenhum resultado encontrado"  
  And nenhum item é exibido na lista.  




# Service   
Scenario: Serviço retorna itens que correspondem à categoria buscada  
  Given existem itens cadastrados nas categorias "Almoço" e "Sobremesa"  
  And a lista de itens no menu é:  
    | Nome                    | Nota          | Categoria         | Popularidade          |  
    | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
    | Doce de leite           | 4,3           | Sobremesa         | Melhores avaliados    |  
    | Feijoada                | 4,6           | Almoço            | Mais acessados        |  
  When envio uma requisição GET para "/busca" com o parâmetro:  
    | categoria | Almoço           |  
  Then o serviço retorna os itens:  
    | Nome                    | Nota          |  
    | Strogonoff de carne     | 4,5           |  
    | Feijoada                | 4,6           |  


Scenario: Serviço retorna itens filtrados por múltiplas condições  
  Given o sistema possui itens cadastrados com categorias e avaliações 
  And a lista de itens no menu é:  
    | Nome                    | Nota          | Categoria         | Popularidade          |  
    | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
    | Doce de leite           | 4,3           | Sobremesa         | Melhores avaliados    |  
    | Feijoada                | 4,6           | Almoço            | Mais acessados        | 
  When envio uma requisição GET para "/busca" com os parâmetros:  
    | categoria               | Almoço             |  
    | popularidade            | Mais acessados     |  
  Then o serviço retorna:
    | Nome                    | Nota          |  
    | Feijoada                | 4,6           |  


  Scenario: Serviço retorna todos os itens ao limpar os filtros  
  Given existem filtros aplicados na busca  
  And o sistema possui os seguintes itens cadastrados:  
    | Nome                    | Nota          | Categoria         | Popularidade          |  
    | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
    | Doce de leite           | 4,3           | Sobremesa         | Mais curtidos         |  
  When envio uma requisição GET para "/busca" sem parâmetros de filtro  
  Then o serviço retorna todos os itens cadastrados no sistema:  
    | Nome                    | Nota          | Categoria         | Popularidade          |  
    | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
    | Doce de leite           | 4,3           | Sobremesa         | Mais curtidos         |  



Scenario: Serviço retorna itens que correspondem ao nome buscado  
  Given existem itens cadastrados com o nome "Bolo de Chocolate"
  And a lista de itens no menu é:
  | Nome                    | Nota          | Categoria         | Popularidade          |
  | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |
  | Doce de leite           | 4,3           | Sobremesa         | Melhores avaliados    |
  | Feijoada                | 4,6           | Almoço            | Melhores avaliados    |
  | Bolo de Chocolate       | 4,0           | Sobremesa         | Melhores avaliadoa    |  
  When envio uma requisição GET para "/busca" com o parâmetro:  
    | nome_prato | Bolo de Chocolate |  
  Then o serviço retorna os itens:
  | Nome                    | Nota          |
  | Bolo de Chocolate       | 4,0           |


 Scenario: Serviço ignora filtros com valores inválidos  
  Given o sistema possui filtros válidos para busca  
  And a lista de itens no menu é:  
    | Nome                    | Nota          | Categoria         | Popularidade          |  
    | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
    | Doce de leite           | 4,3           | Sobremesa         | Mais curtidos         |  
  When envio uma requisição GET para "/busca" com os parâmetros:  
    | categoria   | Inexistente     |  
    | avaliacao   | 6               |  
  Then o serviço ignora os filtros inválidos  
  And retorna os itens disponíveis com base nos filtros válidos restantes:  
    | Nome                    | Nota          |  
    | Strogonoff de carne     | 4,5           |  
    | Doce de leite           | 4,3           |  
  


  Scenario: Serviço retorna itens com múltiplos filtros simultâneos e nenhuma correspondência  
  Given existem itens cadastrados com categorias e popularidade diversas  
  And a lista de itens no menu é:  
    | Nome                    | Nota          | Categoria         | Popularidade          |  
    | Strogonoff de carne     | 4,5           | Almoço            | Melhores avaliados    |  
    | Doce de leite           | 4,3           | Sobremesa         | Mais curtidos         |  
    | Feijoada                | 4,6           | Almoço            | Mais acessados        |  
  When envio uma requisição GET para "/busca" com os parâmetros:  
    | categoria    | Café da manhã     |  
    | popularidade | Mais curtidos     |  
  Then o serviço retorna a mensagem:  
    | mensagem     | Nenhum item encontrado |  
  And nenhum item é retornado.  


