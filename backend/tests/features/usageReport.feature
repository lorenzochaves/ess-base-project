# Feature: Relatórios de Uso
#     As um administrador do sistema
#     I want gerar e visualizar relatórios detalhados sobre o uso do sistema, como pratos mais acessados ou categorias mais populares
#     So that eu possa tomar decisões informadas para melhorar a experiência do usuário e otimizar o sistema.

# Scenario: Gerar relatório de pratos mais acessados por categoria - Serviço
#     Given o administrador "Alyson" está autenticado no sistema  
#     And existem as seguintes categorias com dados de acesso:  
#         | Categoria   | Acessos   |  
#         | Sobremesas  | 120       |  
#         | Carnes      | 80        |  
#         | Veganos     | 50        |  
#     When o administrador faz uma requisição "GET" para "/relatorios/mais-acessados" com os seguintes parâmetros:  
#         | filtro      | categoria |  
#         | período     | semanal   |   
#     Then o status da resposta deve ser "200"  
#     And o JSON da resposta deve conter:  
#         """
#         {
#             "relatorio": [
#                 { "categoria": "Sobremesas", "acessos": 120 },
#                 { "categoria": "Carnes", "acessos": 80 },
#                 { "categoria": "Veganos", "acessos": 50 }
#             ],
#             "periodo": "semanal"
#         }
#         """
#     And o relatório gerado deve refletir os dados do período solicitado.

# Scenario: Visualização do relatório de categorias mais acessadas no mês
#     Given o administrador "Alyson" está autenticado no sistema
#     And existem as seguintes categorias com dados de acesso:
#         | Categoria  | Acessos |
#         | Sobremesas | 500     |
#         | Carnes     | 350     |
#         | Veganos    | 150     |
#     When o administrador faz uma requisição "GET" para "/relatorios/mais-acessados" com os seguintes parâmetros:
#         | filtro     | categoria |
#         | período    | mensal    |
#     Then o status da resposta deve ser "200"
#     And o JSON da resposta deve conter:
#         """
#         {
#             "relatorio": [
#                 { "categoria": "Sobremesas", "acessos": 500 },
#                 { "categoria": "Carnes", "acessos": 350 },
#                 { "categoria": "Veganos", "acessos": 150 }
#             ],
#             "periodo": "mensal"
#         }
#         """

# Scenario: Falha ao gerar relatório sem dados disponíveis
#     Given o administrador "Alyson" está autenticado no sistema
#     And não existem registros de acessos nas categorias para o período solicitado
#     When o administrador faz uma requisição "GET" para "/relatorios/mais-acessados" com os seguintes parâmetros:
#         | período | semanal |
#     Then o status da resposta deve ser "404"
#     And o JSON da resposta deve conter:
#         """
#         { "error": "Nenhum dado disponível para o período selecionado" }
#         """

# Scenario: Filtrar relatório por categoria específica
#     Given o administrador "Alyson" está autenticado no sistema
#     And existem as seguintes categorias com dados de acesso:
#         | Categoria  | Acessos |
#         | Sobremesas | 500     |
#         | Carnes     | 350     |
#     When o administrador faz uma requisição "GET" para "/relatorios/mais-acessados" com os parâmetros:
#         | filtro     | Carnes  |
#     Then o status da resposta deve ser "200"
#     And o JSON da resposta deve conter:
#         """
#         {
#             "relatorio": [
#                 { "categoria": "Carnes", "acessos": 350 }
#             ]
#         }
#         """

# Scenario: Acesso não autorizado ao relatório
#     Given o usuário comum "Alan" está autenticado no sistema
#     When o usuário tenta acessar a rota "/relatorios/mais-acessados"
#     Then o status da resposta deve ser "403"
#     And o JSON da resposta deve conter:
#         """
#         { "error": "Acesso negado. Permissões insuficientes." }
#         """