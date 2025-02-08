const express = require('express');
const pratos = express.Router();
const { dishes, nextDishId } = require('../database/pratos.js');
const { categories } = require('../database/categorias.js');

// Função para encontrar uma categoria pelo nome
const findCategoryByName = (name) => categories.find(c => c.name.toLowerCase() === name.toLowerCase());


// Rota para listar pratos
pratos.get('/', (req, res) => {
  res.send(dishes);
});

// Rota para obter detalhes de um prato
pratos.get('/:id', (req, res) => {
  const dish = dishes.find(d => d.id === parseInt(req.params.id));
  if (dish) {
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

  // Verifica se a categoria já existe
  let category = findCategoryByName(categoryName);

  // Se a categoria não existir, cria uma nova
  if (!category) {
    category = {
      id: categories.length + 1,
      name: categoryName,
      description: ''
    };
    categories.push(category);
  }

  // Cria o novo prato
  nextDishId++
  const newDish = {
    id: nextDishId,
    name,
    description: description || '',
    categoryId: category.id, // Associa o prato à categoria
    ingredients: ingredients || []
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


