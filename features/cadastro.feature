Feature: Criar e editar usuários
As a administrador do sistema
I want to cadastrar,editar ou remover uma conta com os dados de um possível usuário no sistema
So that eu posso me comunicar com outros usuários

GUI Scenario: Cadastro com sucesso
Given estou na página "Cadastro",
When Eu preencho o “nome” com “Rafael Vaqueiro”, o “e-mail” com “vaca@email.com”, o “senha” com “vaqueijada123”,
And Eu clico em "Cadastrar",
Then uma mensagem pedindo para que confirme o cadastro no e-mail do usuário “vaca@email.com” aparece
And Ele confirma o cadastro no e-mail
And o Usuário é redirecionado para a página “inicio” 