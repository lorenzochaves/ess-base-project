Feature: Criar Notícias
    As a usuário administrador
    I want to criar e gerenciar notícias sobre o restaurante universitário
    So that eu possa informar os usuários sobre atualizações e eventos

  Scenario: Listar todas as noticias
    Given existem noticias cadastradas no sistema
    When o usuario faz uma requisição GET para "/news"
    Then o sistema retorna um status code 200
    And uma lista com todas as noticias cadastradas e retornada

  Scenario: Buscar uma noticia especifica
    Given existe uma noticia cadastrada no sistema com ID "1"
    When o usuario faz uma requisição GET para "/news/1"
    Then o sistema retorna um status code 200
    And a noticia e retornada

  Scenario: Buscar uma noticia que nao existe
    When o usuario faz uma requisição GET para "/news/866"
    Then o sistema retorna um status code 404
    And a resposta contera uma mensagem de erro "Notícia não encontrada"

  Scenario: Buscar uma noticia com ID invalido
    When o usuario faz uma requisição GET para "/news/alo"
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "ID inválido"

  Scenario: Criar notícia com sucesso
    When o usuario faz uma requisição POST para "/news" com os dados:
      | title    | RU UFPE adota medidas sustentáveis                                                                                                                                                                                        |
      | subtitle | Restaurante universitário implementa práticas ecológicas.                                                                                                                                                                 |
      | body     | O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização. |
    Then o sistema retorna um status code 201
    And a resposta contera uma noticia com title "RU UFPE adota medidas sustentáveis"

  Scenario: Criar notícia sem título
    When o usuario faz uma requisição POST para "/news" com os dados:
      | subtitle | Restaurante universitário implementa práticas ecológicas.                                                                                                                                                                 |
      | body     | O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização. |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O título é obrigatório e deve ter no máximo 50 caracteres."

  Scenario: Criar notícia com o titulo com quantidade de caracteres acima do limite
    When o usuario faz uma requisição POST para "/news" com os dados:
      | title    | RU UFPE adota medidas sustentavelmente muito grande para nao caber no limite de caracteres do titulo                                                                                                                      |
      | subtitle | Restaurante universitário implementa práticas ecológicas.                                                                                                                                                                 |
      | body     | O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização. |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O título é obrigatório e deve ter no máximo 50 caracteres."

  Scenario: Criar notícia sem subtitulo
    When o usuario faz uma requisição POST para "/news" com os dados:
      | title | RU UFPE adota medidas sustentáveis                                                                                                                                                                                        |
      | body  | O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização. |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O subtítulo é obrigatório e deve ter no máximo 100 caracteres."

  Scenario: Criar notícia com o subtitulo com quantidade de caracteres acima do limite
    When o usuario faz uma requisição POST para "/news" com os dados:
      | title    | RU UFPE adota medidas sustentáveis                                                                                                                                                                                        |
      | subtitle | Restaurante universitário implementa práticas ecológicas em todas as suas unidades, visando a sustentabilidade.                                                                                                           |
      | body     | O RU UFPE está adotando medidas sustentáveis, como a redução do uso de plásticos e a implementação de compostagem para os resíduos orgânicos. A iniciativa visa reduzir o impacto ambiental e promover a conscientização. |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O subtítulo é obrigatório e deve ter no máximo 100 caracteres."

  Scenario: Criar notícia sem corpo
    When o usuario faz uma requisição POST para "/news" com os dados:
      | title    | RU UFPE adota medidas sustentáveis                        |
      | subtitle | Restaurante universitário implementa práticas ecológicas. |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O corpo da notícia é obrigatório e deve ter no máximo 250 caracteres."

  Scenario: Criar notícia com o corpo com quantidade de caracteres acima do limite
    When o usuario faz uma requisição POST para "/news" com os dados:
      | title    | RU UFPE adota medidas sustentáveis                                                                                                                                                                                                                                                                                   |
      | subtitle | Restaurante universitário implementa práticas ecológicas.                                                                                                                                                                                                                                                            |
      | body     | A sustentabilidade é um tema crucial nos dias de hoje. O RU UFPE está implementando práticas eco-friendly, como a redução de plásticos e a compostagem de resíduos orgânicos. Essas ações visam minimizar o impacto ambiental e promover um futuro mais verde. Vamos todos contribuir para um planeta mais saudável! |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O corpo da notícia é obrigatório e deve ter no máximo 250 caracteres."

  Scenario: Editar uma notícia existente
    Given existe uma noticia cadastrada no sistema com ID "1"
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | title    | Novo titulo    |
      | subtitle | Novo subtitulo |
      | body     | Novo conteudo  |
    Then o sistema retorna um status code 200
    And a resposta contera uma noticia com title "Novo titulo"

  Scenario: Tentar editar uma notícia que nao existe
    When o usuario faz uma requisição PUT para "/news/866" com os dados:
      | title    | Novo titulo    |
      | subtitle | Novo subtitulo |
      | body     | Novo conteudo  |
    Then o sistema retorna um status code 404
    And a resposta contera uma mensagem de erro "Notícia não encontrada"

  Scenario: Tentar editar uma notícia co ID invalido
    When o usuario faz uma requisição PUT para "/news/alo" com os dados:
      | title    | Novo titulo    |
      | subtitle | Novo subtitulo |
      | body     | Novo conteudo  |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "ID inválido"

  Scenario: Tentar editar uma notícia com titulo vazio
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | subtitle | Novo subtitulo |
      | body     | Novo conteudo  |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O título é obrigatório e deve ter no máximo 50 caracteres."

  Scenario: Tentar editar uma notícia com titulo com uma quantidade de caracteres acima do limite
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | title    | RU UFPE adota medidas sustentavelmente muito grande para nao caber no limite de caracteres do titulo |
      | subtitle | Novo subtitulo                                                                                       |
      | body     | Novo conteudo                                                                                        |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O título é obrigatório e deve ter no máximo 50 caracteres."

  Scenario: Tentar editar uma notícia com subtitulo vazio
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | title | Novo titulo   |
      | body  | Novo conteudo |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O subtítulo é obrigatório e deve ter no máximo 100 caracteres."

  Scenario: Tentar editar uma notícia com subtitulo com uma quantidade de caracteres acima do limite
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | title    | Novo titulo                                                                                                     |
      | subtitle | Restaurante universitário implementa práticas ecológicas em todas as suas unidades, visando a sustentabilidade. |
      | body     | Novo conteudo                                                                                                   |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O subtítulo é obrigatório e deve ter no máximo 100 caracteres."

  Scenario: Tentar editar uma notícia com corpo vazio
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | title    | Novo titulo    |
      | subtitle | Novo subtitulo |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O corpo da notícia é obrigatório e deve ter no máximo 250 caracteres."

  Scenario: Tentar editar uma notícia com corpo com uma quantidade de caracteres acima do limite
    When o usuario faz uma requisição PUT para "/news/1" com os dados:
      | title    | Novo titulo                                                                                                                                                                                                                                                                                                          |
      | subtitle | Novo subtitulo                                                                                                                                                                                                                                                                                                       |
      | body     | A sustentabilidade é um tema crucial nos dias de hoje. O RU UFPE está implementando práticas eco-friendly, como a redução de plásticos e a compostagem de resíduos orgânicos. Essas ações visam minimizar o impacto ambiental e promover um futuro mais verde. Vamos todos contribuir para um planeta mais saudável! |
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "O corpo da notícia é obrigatório e deve ter no máximo 250 caracteres."

  Scenario: Excluir uma notícia com sucesso
    Given existe uma noticia cadastrada no sistema com ID "1"
    When o usuario faz uma requisição DELETE para "/news/1"
    Then o sistema retorna um status code 200
    And a resposta contera uma mensagem "Notícia deletada com sucesso."

  Scenario: Tentar excluir uma notícia que nao existe
    When o usuario faz uma requisição DELETE para "/news/866"
    Then o sistema retorna um status code 404
    And a resposta contera uma mensagem de erro "Notícia não encontrada"

  Scenario: Tentar excluir uma notícia co ID invalido
    When o usuario faz uma requisição DELETE para "/news/alo"
    Then o sistema retorna um status code 400
    And a resposta contera uma mensagem de erro "ID inválido"
