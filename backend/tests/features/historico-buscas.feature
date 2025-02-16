# language: pt

Funcionalidade: Histórico e Busca de Pratos

  Como um usuário do sistema
  Eu quero poder buscar pratos e gerenciar meu histórico de buscas
  Para que eu possa encontrar pratos específicos e manter registro de minhas pesquisas

  Contexto:
    Dado que o histórico de buscas está vazio
    E que o sistema possui os seguintes pratos cadastrados:
      | nome                  | categoria  | nota | visualizacoes | descricao                                                        |
      | Frango à Parmegiana  | Aves       | 4.2  | 1000         | Filé de frango empanado coberto com molho de tomate e queijo    |
      | Lasanha de Carne     | Italiana   | 4.5  | 376          | Camadas de massa intercaladas com molho de carne e queijo        |
      | Salada Caesar        | Saladas    | 4.0  | 500          | Salada clássica com alface, croutons e molho Caesar             |
      | Sushi Variado        | Japonês    | 4.8  | 253          | Seleção de sushi com peixes frescos e arroz temperado           |
      | Feijoada            | Brasileira | 4.7  | 250          | Prato tradicional brasileiro com feijão preto e carnes          |
      | Risoto de Cogumelos | Italiana   | 4.3  | 145          | Risoto cremoso preparado com cogumelos frescos                  |
      | Tacos de Carne      | Carnes Premium    | 4.1  | 12           | Tortilhas de milho recheadas com carne temperada                |
      | Bolo de Chocolate   | Sobremesas | 4.6  | 925          | Bolo macio e úmido com cobertura de chocolate                   |


  # Cenários de Busca Básica
  @historico
  Cenário: Buscar prato pelo nome exato
    Quando o usuário faz uma requisição GET para "/search?name=Feijoada"
    Então a resposta deve ser "200"
    E a resposta deve conter 1 prato
    E o prato deve ter nome "Feijoada"
    E o histórico de buscas deve conter as seguintes buscas:
      | termo    | filtros |
      | Feijoada | {}      |

  @historico
  Cenário: Buscar prato por parte do nome
    Quando o usuário faz uma requisição GET para "/search?name=Frango"
    Então a resposta deve ser "200"
    E a resposta deve conter 1 prato
    E o prato deve ter nome "Frango à Parmegiana"
    E o histórico de buscas deve conter as seguintes buscas:
      | termo  | filtros |
      | Frango | {}      |

  # Cenários de Busca com Filtros
  @historico
  Cenário: Buscar pratos por categoria
    Quando o usuário faz uma requisição GET para "/search?category=Italiana"
    Então a resposta deve ser "200"
    E a resposta deve conter 2 pratos
    E os pratos devem ser da categoria "Italiana"
    E o histórico de buscas deve conter as seguintes buscas:
      | termo | filtros                    |
      |       | { "category": "Italiana" } |

  @historico
  Cenário: Buscar pratos com nota mínima
    Quando o usuário faz uma requisição GET para "/search?minNota=4.5"
    Então a resposta deve ser "200"
    E a resposta deve conter 4 pratos
    E todos os pratos devem ter nota maior ou igual a 4.5
    E o histórico de buscas deve conter as seguintes buscas:
      | termo | filtros              |
      |       | { "minNota": "4.5" } |

  @historico
  Cenário: Buscar pratos com intervalo de notas
    Quando o usuário faz uma requisição GET para "/search?minNota=4.0&maxNota=4.5"
    Então a resposta deve ser "200"
    E a resposta deve conter 5 pratos
    E todos os pratos devem ter nota entre 4.0 e 4.5
    E o histórico de buscas deve conter as seguintes buscas:
      | termo | filtros                                    |
      |       | { "minNota": "4.0", "maxNota": "4.5" }    |

  
  @historico
  Cenário: Buscar pratos por visualizações mínimas
    Quando o usuário faz uma requisição GET para "/search?minViews=500"
    Então a resposta deve ser "200"
    E a resposta deve conter 3 pratos
    E todos os pratos devem ter mais de 500 visualizações
    E o histórico de buscas deve conter as seguintes buscas:
      | termo | filtros                |
      |       | { "minViews": "500" }  |

  # Cenários de Busca Complexa
  @historico
  Cenário: Buscar pratos com múltiplos filtros
    Quando o usuário faz uma requisição GET para "/search?category=Italiana&minNota=4.3&maxViews=400"
    Então a resposta deve ser "200"
    E a resposta deve conter 2 pratos
    E os pratos devem atender a todos os critérios
    E o histórico de buscas deve conter as seguintes buscas:
      | termo | filtros                                                           |
      |       | { "category": "Italiana", "minNota": "4.3", "maxViews": "400" }  |

  @historico
  Cenário: Buscar pratos com nome e filtros
    Quando o usuário faz uma requisição GET para "/search?name=La&category=Italiana&minNota=4.0"
    Então a resposta deve ser "200"
    E a resposta deve conter 1 pratos
    E os pratos devem ter "La" no nome
    E o histórico de buscas deve conter as seguintes buscas:
      | termo | filtros                                            |
      | La    | { "category": "Italiana", "minNota": "4.0" }      |

  # Cenários de Erro
  @historico
  Cenário: Buscar prato inexistente
    Quando o usuário faz uma requisição GET para "/search?name=PratoInexistente"
    Então a resposta deve ser "404"
    E a mensagem de erro deve ser "Nenhum prato encontrado com esses filtros"
    E o histórico de buscas deve conter as seguintes buscas:
      | termo            | filtros |
      | PratoInexistente | {}      |

  @historico
  Cenário: Buscar com nota máxima inválida
    Quando o usuário faz uma requisição GET para "/search?maxNota=6.0"
    Então a resposta deve ser "400"
    E a mensagem de erro deve ser "Nota máxima deve ser entre 0 e 5"

  # Cenários de Histórico
  @historico
  Cenário: Verificar limite de 100 buscas no histórico
    Dado que o histórico contém 100 buscas antigas
    Quando o usuário faz uma requisição GET para "/search?name=Lasanha"
    Então a resposta deve ser "200"
    E o histórico deve conter exatamente 100 buscas
    E a busca mais recente deve ter termo "Lasanha"

  @historico
  Cenário: Remover busca específica do histórico
    Dado que o histórico de buscas contém as seguintes buscas:
      | termo    | filtros                    |
      | Lasanha  | { "category": "Italiana" } |
      | Feijoada | {}                         |
      | Sushi    | { "minNota": "4.5" }       |
    Quando o usuário faz uma requisição DELETE para "/search/historico/1"
    Então a resposta deve ser "204"
    E o histórico de buscas deve conter as seguintes buscas:
      | termo    | filtros                    |
      | Lasanha  | { "category": "Italiana" } |
      | Sushi    | { "minNota": "4.5" }       |

  @historico
  Cenário: Limpar histórico completo
    Dado que o histórico de buscas contém as seguintes buscas:
      | termo   | filtros                    |
      | Lasanha | { "category": "Italiana" } |
      | Frango  | { "minNota": "4.5" }       |
    Quando o usuário faz uma requisição DELETE para "/search/historico"
    Então a resposta deve ser "204"
    E o histórico de buscas deve estar vazio

  @historico
  Cenário: Tentar remover busca com índice inválido
    Dado que o histórico de buscas contém as seguintes buscas:
      | termo   | filtros                    |
      | Lasanha | { "category": "Italiana" } |
    Quando o usuário faz uma requisição DELETE para "/search/historico/999"
    Então a resposta deve ser "400"
    E a mensagem de erro deve ser "Índice inválido"

  @historico
  Cenário: Visualizar histórico vazio
    Quando o usuário faz uma requisição GET para "/search/historico"
    Então a resposta deve ser "200"
    E o corpo da resposta deve ser um array vazio