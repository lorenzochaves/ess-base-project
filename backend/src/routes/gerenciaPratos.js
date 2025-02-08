const express = require('express');
const router = express.Router();
const { dishes } = require('/backend/src/database/pratos.js');



// Rota para listar pratos
router.get('/', (req, res) => {
  res.send(dishes);
});

// Rota para obter detalhes de um prato
router.get('/:id', (req, res) => {
  const dish = dishes.find(d => d.id === parseInt(req.params.id));
  if (dish) {
    res.send(dish);
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});

// Rota para adicionar um prato
router.post('/', (req, res) => {
  const { name, description, category, ingredients, allergens } = req.body;
  const newDish = {
    id: dishes.length + 1,
    name,
    description,
    category,
    ingredients,
    allergens,
  };
  dishes.push(newDish);
  res.status(201).send(newDish);
});

// Rota para deletar um prato
router.delete('/:id', (req, res) => {
  const dishIndex = dishes.findIndex(d => d.id === parseInt(req.params.id));
  if (dishIndex !== -1) {
    dishes.splice(dishIndex, 1);
    res.status(204).send();
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});

module.exports = router;



let users = [{}];

const express = require('express');
const router = express.Router();
const { dishes } = require('../utils/database');

// Rota para listar pratos
router.get('/', (req, res) => {
  res.send(dishes);
});

// Rota para obter detalhes de um prato
router.get('/:id', (req, res) => {
  const dish = dishes.find(d => d.id === parseInt(req.params.id));
  if (dish) {
    res.send(dish);
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});

// Rota para adicionar um prato
router.post('/', (req, res) => {
  const { name, description, category, ingredients, allergens } = req.body;
  const newDish = {
    id: dishes.length + 1,
    name,
    description,
    category,
    ingredients,
    allergens,
  };
  dishes.push(newDish);
  res.status(201).send(newDish);
});

// Rota para deletar um prato
router.delete('/:id', (req, res) => {
  const dishIndex = dishes.findIndex(d => d.id === parseInt(req.params.id));
  if (dishIndex !== -1) {
    dishes.splice(dishIndex, 1);
    res.status(204).send();
  } else {
    res.status(404).send({ error: 'Prato não encontrado' });
  }
});

module.exports = router;


