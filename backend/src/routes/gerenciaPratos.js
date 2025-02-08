const express = require('express');
const pratos = express.Router();
const { dishes } = require('../database/pratos.js');


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


