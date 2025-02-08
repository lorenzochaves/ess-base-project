const express = require('express');
const router = express.Router();
const { categories } = require('../database/categorias.js');
const { dishes } = require('../database/pratos.js'); // Importamos pratos para validação de dependências

// Validação de categoria existente
const findCategoryById = (id) => categories.find(c => c.id === parseInt(id));

// Rota para listar todas as categorias
router.get('/', (req, res) => {
  res.send(categories);
});

// Rota para obter detalhes de uma categoria
router.get('/:id', (req, res) => {
  const category = findCategoryById(req.params.id);
  category ? res.send(category) : res.status(404).send({ error: 'Categoria não encontrada' });
});

// Rota para criar nova categoria
router.post('/', (req, res) => {
  const { name, description } = req.body;
  
  // Validações
  if (!name) {
    return res.status(400).send({ error: 'Nome da categoria é obrigatório' });
  }
  
  if (categories.some(c => c.name.toLowerCase() === name.toLowerCase())) {
    return res.status(409).send({ error: 'Categoria já existe' });
  }

  const newCategory = {
    id: categories.length + 1,
    name,
    description: description || ''
  };

  categories.push(newCategory);
  res.status(201).send(newCategory);
});

// Rota para deletar categoria
router.delete('/:id', (req, res) => {
  const categoryId = parseInt(req.params.id);
  const categoryIndex = categories.findIndex(c => c.id === categoryId);

  if (categoryIndex === -1) {
    return res.status(404).send({ error: 'Categoria não encontrada' });
  }

  // Verifica se a categoria está sendo usada em algum prato
  const isCategoryInUse = dishes.some(d => d.categoryId === categoryId);
  if (isCategoryInUse) {
    return res.status(409).send({ 
      error: 'Não é possível excluir: categoria está vinculada a pratos' 
    });
  }

  categories.splice(categoryIndex, 1);
  res.status(204).send();
});

module.exports = router;