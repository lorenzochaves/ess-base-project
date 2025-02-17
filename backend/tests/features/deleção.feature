# # Deletar Contas de Usuários Comuns
# Feature: Deletar contas de usuários comuns
#   As um administrador
#   I want poder deletar contas de usuários comuns
#   So that possa garantir que contas desativadas ou inativas sejam removidas do sistema, respeitando um período de recuperação de 30 dias.

# # GUI Scenarios

# Scenario: Deletar conta de usuário com sucesso
#   Given o administrador "Lorenzo" está logado no sistema
#   And o usuário comum "João Silva" está listado na tela de gerenciamento de usuários
#   When o administrador seleciona o usuário "João Silva"
#   And seleciona a opção "Excluir conta"
#   And confirma a deleção da conta de usuário com a opção "Excluir Conta"
#   Then a mensagem "Conta excluída com sucesso!" é exibida confirmando a deleção
#   And o administrador "Lorenzo" é redirecionado para a tela de alunos cadastrados

# Scenario: Tentativa de deletar conta sem confirmação
#   Given o administrador "Lorenzo" está logado no sistema
#   And o usuário comum "Maria Oliveira" está listado na tela de gerenciamento de usuários
#   When o administrador seleciona o usuário "Maria Oliveira"
#   And clica na opção "Excluir conta"
#   Then o sistema exibe uma tela pedindo confirmação da ação
#   And o administrador não consegue excluir a conta sem confirmar a ação

# Scenario: Tentar deletar conta após o período de recuperação
#   Given o administrador "Lorenzo" está logado no sistema
#   And o usuário comum "Carlos Almeida" teve sua conta deletada há mais de 30 dias
#   When o administrador tenta recuperar ou deletar a conta de "Carlos Almeida"
#   Then o sistema exibe uma mensagem informando que a conta não pode mais ser recuperada
#   And o administrador "Lorenzo" é redirecionado para a tela de alunos com contas desativadas

# # Service Scenarios

# Scenario: Deletar conta de usuário com sucesso
#   Given o administrador "Lorenzo" está logado no sistema
#   And o usuário "João Silva" existe no banco de dados
#   When o administrador envia uma solicitação para deletar a conta de "João Silva"
#   Then o sistema desativa a conta de "João Silva"
#   And a conta de "João Silva" será marcada como "Desativada" no banco de dados
#   And a exclusão é registrada no histórico com as informações "Data", "Hora" e "Nome do Administrador" com os valores "16/12/2024", "08:00", "Lorenzo" respectivamente

# Scenario: Tentar deletar conta após o período de recuperação
#   Given o administrador "Lorenzo" está logado no sistema
#   And o usuário "Carlos Almeida" teve sua conta deletada há mais de 30 dias
#   When o administrador tenta recuperar ou deletar a conta de "Carlos Almeida"
#   Then o sistema retorna um erro informando que os dados de "Carlos Almeida" foram permanentemente excluídos
#   And não é possível realizar qualquer ação sobre a conta de "Carlos Almeida"
