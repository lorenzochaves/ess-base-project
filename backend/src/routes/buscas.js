const express = require('express');
const router = express.Router();
const { dishes } = require('../database/pratos.js');
const { salvarBusca, getHistorico, limparHistorico, removerBusca } = require('../database/historicoBuscas.js');

// Validação de parâmetros
const validarParametros = (req, res, next) => {
  const { maxNota, minNota, maxViews, minViews } = req.query;

  if (maxNota && (isNaN(maxNota) || parseFloat(maxNota) > 5 || parseFloat(maxNota) < 0)) {
    return res.status(400).json({ error: 'Nota máxima deve ser entre 0 e 5' });
  }

  if (minNota && (isNaN(minNota) || parseFloat(minNota) > 5 || parseFloat(minNota) < 0)) {
    return res.status(400).json({ error: 'Nota mínima deve ser entre 0 e 5' });
  }

  if (maxViews && (isNaN(maxViews) || parseInt(maxViews) < 0)) {
    return res.status(400).json({ error: 'Número máximo de visualizações deve ser positivo' });
  }

  if (minViews && (isNaN(minViews) || parseInt(minViews) < 0)) {
    return res.status(400).json({ error: 'Número mínimo de visualizações deve ser positivo' });
  }

  next();
};

// Rota para buscar pratos
router.get('/', validarParametros, (req, res) => {
  const { name, category, minNota, maxNota, minViews, maxViews } = req.query;

  let filteredDishes = [...dishes];

  // Filtrar por nome
  if (name) {
    filteredDishes = filteredDishes.filter(d => 
      d.name && d.name.toLowerCase().includes(name.toLowerCase())
    );
  }

  // Filtrar por categoria
  if (category) {
    filteredDishes = filteredDishes.filter(d => 
      d.category && d.category.toLowerCase() === category.toLowerCase()
    );
  }

  // Filtrar por nota mínima
  if (minNota) {
    filteredDishes = filteredDishes.filter(d => 
      d.rating !== undefined && d.rating >= parseFloat(minNota)
    );
  }

  // Filtrar por nota máxima
  if (maxNota) {
    filteredDishes = filteredDishes.filter(d => 
      d.rating !== undefined && d.rating <= parseFloat(maxNota)
    );
  }

  // Filtrar por número mínimo de visualizações
  if (minViews) {
    filteredDishes = filteredDishes.filter(d => 
      d.views !== undefined && d.views >= parseInt(minViews)
    );
  }

  // Filtrar por número máximo de visualizações
  if (maxViews) {
    filteredDishes = filteredDishes.filter(d => 
      d.views !== undefined && d.views <= parseInt(maxViews)
    );
  }

  // Incrementar visualizações apenas se encontrou resultados
  if (filteredDishes.length > 0) {
    filteredDishes.forEach(dish => {
      const originalDish = dishes.find(d => d.id === dish.id);
      if (originalDish) {
        originalDish.views = (originalDish.views || 0) + 1;
      }
    });
  }

  // Salvar busca no histórico
  const filtros = {};
  if (category) filtros.category = category;
  if (minNota) filtros.minNota = minNota;
  if (maxNota) filtros.maxNota = maxNota;
  if (minViews) filtros.minViews = minViews;
  if (maxViews) filtros.maxViews = maxViews;
  
  salvarBusca(name || '', filtros);

  // Retornar resultados ou erro 404
  if (filteredDishes.length > 0) {
    res.send(filteredDishes);
  } else {
    res.status(404).send({ error: "Nenhum prato encontrado com esses filtros" });
  }
});

// Rota para obter o histórico
router.get('/historico', (req, res) => {
  const historico = getHistorico();
  res.send(historico);
});

// Rota para limpar o histórico
router.delete('/historico', (req, res) => {
  limparHistorico();
  res.status(204).send();
});

// Rota para remover uma busca específica
router.delete('/historico/:index', (req, res) => {
  const index = parseInt(req.params.index);
  if (index < 0 || index >= getHistorico().length) {
    return res.status(400).json({ error: 'Índice inválido' });
  }
  removerBusca(index);
  res.status(204).send();
});

module.exports = router;