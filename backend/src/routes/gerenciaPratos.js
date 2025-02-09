const express = require('express');
const pratos = express.Router();
const { dishes } = require('../database/pratos.js');
const { categories } = require('../database/categorias.js');

let nextDishId = 9;

// Função para encontrar uma categoria pelo nome
const findCategoryByName = (name) => categories.find(c => c.name.toLowerCase() === name.toLowerCase());


// Rota para listar pratos
pratos.get('/', (req, res) => {
  res.send(dishes);
});

// Rota para obter os 5 pratos mais vistos (mínimo 20 views)
pratos.get('/most-viewed', (req, res) => {
  // Filtra os pratos que possuem pelo menos 20 visualizações
  const filteredDishes = dishes.filter(d => d.views >= 20);

  // Ordena os pratos do maior para o menor número de visualizações
  const sortedDishes = filteredDishes.sort((a, b) => b.views - a.views);

  // Retorna os 5 primeiros pratos da lista
  const top5Dishes = sortedDishes.slice(0, 5);

  // Responde com os pratos mais vistos
  res.send(top5Dishes);
});


// Rota para buscar um prato pelo nome + filtros
pratos.get('/search', (req, res) => {
  const { name, category, minNota, maxNota, minViews, maxViews } = req.query;

  let filteredDishes = [...dishes]; // Criar uma cópia do array original

  // Filtrar por nome (se informado)
  if (name) {
    filteredDishes = filteredDishes.filter(d => 
      d.name && d.name.toLowerCase().includes(name.toLowerCase())
    );
  }

  // Filtrar por categoria (se informado)
  if (category) {
    filteredDishes = filteredDishes.filter(d => 
      d.category && d.category.toLowerCase() === category.toLowerCase()
    );
  }

  // Filtrar por nota mínima (se informada)
  if (minNota) {
    filteredDishes = filteredDishes.filter(d => 
      d.rating !== undefined && d.rating >= parseFloat(minNota)
    );
  }

  // Filtrar por nota máxima (se informada)
  if (maxNota) {
    filteredDishes = filteredDishes.filter(d => 
      d.rating !== undefined && d.rating <= parseFloat(maxNota)
    );
  }

  // Filtrar por número mínimo de visualizações (se informado)
  if (minViews) {
    filteredDishes = filteredDishes.filter(d => 
      d.views !== undefined && d.views >= parseInt(minViews)
    );
  }

  // Filtrar por número máximo de visualizações (se informado)
  if (maxViews) {
    filteredDishes = filteredDishes.filter(d => 
      d.views !== undefined && d.views <= parseInt(maxViews)
    );
  }
  // Incrementar a quantidade de visualizações dos pratos encontrados
  filteredDishes.forEach(dish => {
    dish.views = (dish.views || 0) + 1;
  });
  // Retornar os pratos filtrados ou erro 404 se nenhum for encontrado
  if (filteredDishes.length > 0) {
    res.send(filteredDishes);
  } else {
    res.status(404).send({ error: 'Nenhum prato encontrado com esses filtros' });
  }
});



// Rota para obter detalhes de um prato
pratos.get('/:id', (req, res) => {
  const dish = dishes.find(d => d.id === parseInt(req.params.id));
  if (dish) {
    // Incrementar a quantidade de visualizações
    dish.views = (dish.views || 0) + 1;
    res.send(dish);
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});

// Rota para adicionar um prato
pratos.post('/', (req, res) => {
  const { name, description, categoryName, ingredients } = req.body;

  // Validações
  if (!name || !categoryName) {
    return res.status(400).send({ error: 'Nome do prato e nome da categoria são obrigatórios' });
  }

  const dishExists = dishes.some(dish => dish.name.toLowerCase() === name.toLowerCase());
  if (dishExists) {
    return res.status(409).send({ error: 'Já existe um prato com esse nome' });
  }

  // Verifica se a categoria já existe
  let category = findCategoryByName(categoryName);

  // Se a categoria não existir, mandar erro.
  if (!category) {
    return res.status(409).send({error: 'Essa categoria não existe.'})
  }

  // Cria o novo prato
  
  const newDish = {
    id: nextDishId++,
    name,
    description: description || '',
    categoryId: category.id, // Associa o prato à categoria
    ingredients: ingredients || [],
    rating: 0.0,
    views: 0

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


module.exports = pratos;


