const express = require('express');
const router = express.Router();
const { categories } = require('../database/categorias.js');
const { dishes } = require('../database/pratos.js'); // Importamos pratos para validação de dependências

// Rota para obter os 5 pratos mais vistos (mínimo 20 views)
router.get('/', (req, res) => {
    // Filtra os pratos que possuem pelo menos 20 visualizações
    const filteredDishes = dishes.filter(d => d.views >= 20);
  
    // Ordena os pratos do maior para o menor número de visualizações
    const sortedDishes = filteredDishes.sort((a, b) => b.views - a.views);
  
    // Retorna os 5 primeiros pratos da lista
    const top5Dishes = sortedDishes.slice(0, 5);
  
    // Responde com os pratos mais vistos
    res.send(top5Dishes);
  });

  module.exports = router