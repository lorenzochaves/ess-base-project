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

// Função para calcular a relevância de pratos (rating * views / dias)
const calculateDishRelevance = (dish) => {
  const daysDifference = getDaysDifference(dish.publicationDate);
  return (dish.rating * dish.views) / daysDifference;
};

// Função para calcular a relevância de notícias (views / dias)
const calculateNewsRelevance = (newsItem) => {
  const daysDifference = getDaysDifference(newsItem.publicationDate);
  return newsItem.views / daysDifference;
};

// Função para ordenar conteúdos por data de publicação (do mais recente para o mais antigo)
const sortByPublicationDate = (contents) => {
  return contents.sort((a, b) => new Date(b.publicationDate) - new Date(a.publicationDate));
};

// Função para ordenar pratos por relevância
const sortDishesByRelevance = (dishes) => {
  return dishes.sort((a, b) => {
    const relevanceA = calculateDishRelevance(a);
    const relevanceB = calculateDishRelevance(b);
    return relevanceB - relevanceA; // Ordena em ordem decrescente
  });
};

// Função para ordenar notícias por relevância
const sortNewsByRelevance = (news) => {
  return news.sort((a, b) => {
    const relevanceA = calculateNewsRelevance(a);
    const relevanceB = calculateNewsRelevance(b);
    return relevanceB - relevanceA; // Ordena em ordem decrescente
  });
};

// Função para limitar o número de itens retornados (entre 10 e 20)
const limitResults = (contents, min = 10, max = 20) => {
  const length = contents.length;
  if (length <= min) return contents.slice(0, min);
  if (length >= max) return contents.slice(0, max);
  return contents.slice(0, length);
};

// Rota para exibir conteúdos no feed
router.get('/feed', (req, res) => {
  const { filter, category } = req.query;

  // Filtro por novidades
  if (filter && filter.toLowerCase() === 'novidades') {
    const allContents = [...dishes, ...news]; // Mescla pratos e notícias
    const sortedContents = sortByPublicationDate(allContents); // Ordena por data de publicação
    const limitedContents = limitResults(sortedContents); // Limita entre 10 e 20 itens
    return res.status(200).json(limitedContents);
  }

  // Filtro por categoria
  if (filter && filter.toLowerCase() === 'categoria' && category) {
    if (category.toLowerCase() === 'pratos') {
      const sortedDishes = sortDishesByRelevance(dishes); // Ordena por relevância
      const limitedDishes = limitResults(sortedDishes); // Limita entre 10 e 20 itens
      return res.status(200).json(limitedDishes);
    } else if (category.toLowerCase() === 'noticia') {
      const sortedNews = sortNewsByRelevance(news); // Ordena por relevância
      const limitedNews = limitResults(sortedNews); // Limita entre 10 e 20 itens
      return res.status(200).json(limitedNews);
    } else {
      return res.status(400).json({ error: 'Categoria inválida' });
    }
  }

  // Caso nenhum filtro válido seja fornecido
  return res.status(400).json({ error: 'Filtro inválido ou não fornecido' });
});

module.exports = router;