const express = require('express');
const router = express.Router();
const { dishes } = require('../database/pratos.js');
const { salvarBusca, getHistorico, limparHistorico, removerBusca } = require('../database/historicoBuscas.js');




// Rota para buscar um prato pelo nome + filtros
router.get('/', (req, res) => {
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

  // Salvar a busca no histórico
  const filtros = { category, minNota, maxNota, minViews, maxViews };
  salvarBusca(name || '', filtros);

  // Retornar os pratos filtrados ou erro 404 se nenhum for encontrado
  if (filteredDishes.length > 0) {
    res.send(filteredDishes);
  } else {
    res.status(404).send({ error: 'Nenhum prato encontrado com esses filtros' });
  }
});

// Rota para obter o histórico de buscas
router.get('/historico', (req, res) => {
  const historico = getHistorico();
  res.send(historico);
});

// Rota para limpar o histórico de buscas
router.delete('/historico', (req, res) => {
    limparHistorico();
    res.status(204).send();
  });

  // Rota para remover uma busca específica do histórico
  router.delete('/historico/:index', (req, res) => {
    const index = parseInt(req.params.index);
    removerBusca(index);
    res.status(204).send();
  });

module.exports = router;