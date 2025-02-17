const express = require('express');
const usuarios = express.Router();
const { users } = require('../database/users_list.js');

let nextUserId = 1;

// Função para encontrar um usuário pelo ID
const findUserById = (id) => users.find(u => u.id === parseInt(id));

// Rota para listar usuários
usuarios.get('/', (req, res) => {
  res.send(users);
});

// Rota para obter detalhes de um usuário
usuarios.get('/:id', (req, res) => {
  const user = findUserById(req.params.id);
  if (user) {
    res.send(user);
  } else {
    res.status(404).send({ error: 'Usuário não encontrado' });
  }
});

// Rota para criar um usuário
usuarios.post('/', (req, res) => {
  const { nome, login, senha } = req.body;

  // Validações
  if (!login){
    return res.status(400).send({error: 'Login não pode ser vazio'})
  }

  const userExists = users.some(user => user.login.toLowerCase() === login.toLowerCase());
  if (userExists) {
    return res.status(400).send({ error: 'Já existe um usuário com esse login' });
  }

  if (senha.length < 8) {
    return res.status(400).send({ error: 'A senha deve ter pelo menos 8 caracteres' });
  }

  // Cria o novo usuário
  const newUser = {
    id: nextUserId++,
    nome,
    login,
    senha
  };

  users.push(newUser);
  res.status(201).send(newUser);
});

// Rota para editar um usuário
usuarios.put('/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const { nome, login} = req.body;

  const user = findUserById(userId);
  if (!user) {
    return res.status(404).send({ error: 'Usuário não encontrado' });
  }

  // Verifica se o novo login já existe (ignorando o próprio usuário)
  const loginExists = users.some(
    u => u.id !== userId && u.login.toLowerCase() === login.toLowerCase()
  );
  if (loginExists) {
    return res.status(400).send({ error: 'Já existe um usuário com esse login' });
  }

  // Atualiza os campos do usuário
  user.nome = nome || user.nome;
  user.login = login || user.login;


  res.status(200).send(user);
});

module.exports = usuarios;