

const express = require('express');
const pratos = express.Router();
let { dishes } = require('../database/pratos.js');
const { categories } = require('../database/categorias.js');
const { randomInt } = require('crypto');

let initialdishes = dishes;
let nextDishId = 9;

// Função para encontrar uma categoria pelo nome
const findCategoryByName = (name) => categories.find(c => c.name.toLowerCase() === name.toLowerCase());

// Função para encontrar um prato pelo ID
const findDishById = (id) => dishes.find(d => d.id === parseInt(id));


// Rota para listar pratos
pratos.get('/', (req, res) => {
  res.send(dishes);
});


pratos.get('/best-rated', (req, res) => {
  const pratosOrdenados = dishes.sort((a, b) => b.rating - a.rating);
  
  const melhoresPratos = pratosOrdenados.slice(0, 5);

  res.send(melhoresPratos);
});

pratos.get('/best-rated/:number', (req, res) => {
  const number = parseInt(req.params.number, 10); // Obtém o número da URL e converte para inteiro

  if (isNaN(number) || number < 1 || number > 5) {
    return res.status(400).send({ error: "A posição deve estar entre 1 e 5" });
  }

  const pratosOrdenados = [...dishes].sort((a, b) => b.rating - a.rating); // Ordena por rating
  const pratoSelecionado = pratosOrdenados[number - 1]; // Pega o prato na posição desejada

  if (!pratoSelecionado) {
    return res.status(404).send({ error: "Nenhum prato encontrado para essa posição" });
  }

  res.send(pratoSelecionado);
});


// Rota para obter detalhes de um prato
pratos.get('/:id', (req, res) => {
  const dish = dishes.find(d => d.id === parseInt(req.params.id));
  if (dish) {
    // Incrementar a quantidade de visualizações
    dish.views = (dish.views || 0) + 1;
    res.send(dish);
  } else {
    res.status(400).send({ error: 'Prato não encontrado' });
  }
});


// Rota para editar um prato
pratos.put('/:id', (req, res) => {
  const dishId = parseInt(req.params.id);
  const { name, description, category, ingredients, rating, views } = req.body;

  // Validações
  if (!name) {
    return res.status(400).send({ error: 'Nome do prato é obrigatório' });
  }

  // Encontra o prato pelo ID
  const dish = findDishById(dishId);
  if (!dish) {
    return res.status(404).send({ error: 'Prato não encontrado' });
  }

  // Verifica se o novo nome já existe (ignorando o próprio prato)
  const nameExists = dishes.some(
    d => d.id !== dishId && d.name.toLowerCase() === name.toLowerCase()
  );
  if (nameExists) {
    return res.status(400).send({ error: 'Já existe um prato com esse nome' });
  }

  // Verifica se a nova categoria existe
  let categoryName = findCategoryByName(category);
  if (!categoryName) {
    return res.status(404).send({ error: 'Categoria não encontrada' });
  }

  // Atualiza o prato
  dish.name = name;
  dish.description = description || dish.description; // Mantém a descrição atual se não for fornecida
  dish.ingredients = ingredients || dish.ingredients; // Mantém os ingredientes atuais se não forem fornecidos
  dish.category = category; // Atualiza o ID da categoria

  res.status(200).send(dish);
});


// Rota para adicionar um prato
pratos.post('/', (req, res) => {
  const { name, description, category, ingredients, rating, views } = req.body;
  const namelength = name?.length;
  // Validações
  if (!name && !category) {
    return res.status(400).send({ error: 'Nome do prato e nome da categoria são obrigatórios' });
  }

  if (!name) {
    return res.status(400).send({ error: 'Nome do prato é obrigatório' });
  }

  if (namelength < 2){
    return res.status(400).send({ error: 'Nome do prato deve ter pelo menos 2 caracteres' });
  }

  if (namelength > 50){
    return res.status(400).send({ error: 'Nome do prato não pode ter mais que 50 caracteres' });
  }
  
  if (parseFloat(rating) < 0 || parseFloat(rating) > 5){
    return res.status(400).send({ error: 'Rating deve ser entre 0 e 5' });
  }

  if (parseFloat(views) < 0 ){
    return res.status(400).send({ error: 'Views não pode ser negativo' });
  }

  if (ingredients.length == 0 || !ingredients){
    return res.status(400).send({ error: 'Ingredientes são obrigatórios' });
  }



  const dishExists = dishes.some(dish => dish.name.toLowerCase() === name.toLowerCase());
  if (dishExists) {
    return res.status(400).send({ error: 'Já existe um prato com esse nome' });
  }

  // Verifica se a categoria já existe
  let categoryName = findCategoryByName(category);

  // Se a categoria não existir, mandar erro.
  if (!categoryName) {
    return res.status(400).send({error: 'Categoria não encontrada'})
  }

  // Define um número de visualizações artificial (ou 0 se não for passado)
  const viewsCount = views !== undefined ? views : 0;

  // Cria o novo prato
  const newDish = {
    id: nextDishId++,
    name,
    description: description || '',
    category: category, // Associa o prato à categoria
    ingredients: ingredients || [],
    rating: rating || 0,
    views: views || 0
  };

  dishes.push(newDish);
  res.status(201).send(newDish);
});

// Rota para deletar um prato
pratos.delete('/:id', (req, res) => {
  const dishIndex = dishes.findIndex(d => d.id === parseInt(req.params.id));
  if (dishIndex !== -1) {
    dishes.splice(dishIndex, 1);
    res.status(204).send();
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});


// pratos.post('/reset', (req, res) => {
//   dishes = initialdishes;
//   nextDishId = 9;
//   res.status(200).send(dishes);
// });


module.exports = pratos;


