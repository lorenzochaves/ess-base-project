const express = require('express');
const router = express.Router();

const { dishes } = require('../database/pratos_aux.js'); // Pratos populares
const { categories } = require('../database/categorias_aux.js'); // Categorias de pratos
const { news } = require('../database/noticias_aux.js'); // Notícias populares

// Função para validar categoria
const isValidCategory = (category) =>
  categories.some(c => c.name.toLowerCase() === category.toLowerCase());

// Função para calcular a diferença em dias entre duas datas
const getDaysDifference = (dateString) => {
  const publicationDate = new Date(dateString); // Data de criação do conteúdo
  const now = new Date(); // Data atual
  const timeDifference = now - publicationDate; // Diferença em milissegundos
  const daysDifference = timeDifference / (1000 * 60 * 60 * 24); // Converte para dias
  return Math.floor(daysDifference); // Retorna o número inteiro de dias
};

// Função para calcular a popularidade ajustada pelo tempo
const calculateAdjustedPopularity = (views, daysDifference) => {
  if (daysDifference === 0) return views; // Evita divisão por zero
  return views / daysDifference; // Popularidade ajustada
};

// Função para ordenar conteúdos por popularidade ajustada
const sortByAdjustedPopularity = (contents) => {
  return contents.sort((a, b) => {
    const daysDifferenceA = getDaysDifference(a.publicationDate);
    const daysDifferenceB = getDaysDifference(b.publicationDate);
    const adjustedPopularityA = calculateAdjustedPopularity(a.views, daysDifferenceA);
    const adjustedPopularityB = calculateAdjustedPopularity(b.views, daysDifferenceB);
    return adjustedPopularityB - adjustedPopularityA; // Ordena em ordem decrescente
  });
};

// Função para limitar o número de itens retornados
const limitResults = (contents, limit = 5) => contents.slice(0, limit);

// Rota para exibir lista de itens em alta
router.get('/em-alta', (req, res) => {
  const { category } = req.query;

  let filteredContents = [];

  // Se uma categoria for fornecida, filtra os conteúdos por categoria
  if (category) {
    if (category.toLowerCase() === 'noticias') {
      filteredContents = news;
    } else if (category.toLowerCase() === 'pratos') {
      filteredContents = dishes;
    } else if (isValidCategory(category)) {
      filteredContents = dishes.filter(item => item.category.toLowerCase() === category.toLowerCase());
    } else {
      // Se a categoria não for válida, retorna um array vazio com status 200
      return res.status(200).json([]);
    }
  } else {
    // Se nenhuma categoria for fornecida, mescla pratos e notícias
    filteredContents = [...dishes, ...news];
  }

  // Ordena os conteúdos por popularidade ajustada
  const sortedContents = sortByAdjustedPopularity(filteredContents);

  // Limita o número de itens retornados
  const limitedContents = limitResults(sortedContents);

  // Retorna os conteúdos filtrados e ordenados
  res.status(200).json(limitedContents);
});

module.exports = router;