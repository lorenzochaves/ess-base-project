const express = require('express');
const pratos = express.Router();
const { dishes } = require('../database/pratos.js');


// Rota para listar pratos
pratos.get('/', (req, res) => {
  res.send(dishes);
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
    res.send(dish);
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});

// Rota para adicionar um prato
pratos.post('/', (req, res) => {
  const { name, description, category, ingredients } = req.body;
  const newDish = {
    id: dishes.length + 1,
    name,
    description,
    category,
    ingredients
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


