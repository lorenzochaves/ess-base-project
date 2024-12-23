Feature: Relatórios de Uso
    As um administrador do sistema
    I want gerar e visualizar relatórios detalhados sobre o uso do sistema, como pratos mais acessados ou categorias mais populares
    So that eu possa tomar decisões informadas para melhorar a experiência do usuário e otimizar o sistema.

Scenario: Gerar relatório de pratos mais acessados por categoria - Serviço
    Given o administrador "Alyson" está autenticado no sistema  
    And existem as seguintes categorias com dados de acesso:  
        | Categoria   | Acessos   |  
        | Sobremesas  | 120       |  
        | Carnes      | 80        |  
        | Veganos     | 50        |  
    When o administrador faz uma requisição "GET" para "/relatorios/mais-acessados" com os seguintes parâmetros:  
        | filtro      | categoria |  
        | período     | semanal   |   
    Then o status da resposta deve ser "200"  
    And o JSON da resposta deve conter:  
        """
        {
            "relatorio": [
                { "categoria": "Sobremesas", "acessos": 120 },
                { "categoria": "Carnes", "acessos": 80 },
                { "categoria": "Veganos", "acessos": 50 }
            ],
            "periodo": "semanal"
        }
        """
    And o relatório gerado deve refletir os dados do período solicitado.

Scenario: Visualização do relatório de categorias mais acessadas no mês
    Given o administrador "Alyson" está autenticado no sistema
    And existem as seguintes categorias com dados de acesso:
        | Categoria  | Acessos |
        | Sobremesas | 500     |
        | Carnes     | 350     |
        | Veganos    | 150     |
    When o administrador faz uma requisição "GET" para "/relatorios/mais-acessados" com os seguintes parâmetros:
        | filtro     | categoria |
        | período    | mensal    |
    Then o status da resposta deve ser "200"
    And o JSON da resposta deve conter:
        """
        {
            "relatorio": [
                { "categoria": "Sobremesas", "acessos": 500 },
                { "categoria": "Carnes", "acessos": 350 },
                { "categoria": "Veganos", "acessos": 150 }
            ],
            "periodo": "mensal"
        }
        """