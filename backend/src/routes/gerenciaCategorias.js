const express = require('express');
const router = express.Router();
const { categories } = require('../database/categorias.js');
const { dishes } = require('../database/pratos.js'); // Importamos pratos para validação de dependências

let nextCategoryId = 9;

// Função para validar se o ID é um número válido
const isValidId = (id) => !isNaN(id) && Number.isInteger(parseFloat(id));

// Validação de categoria existente
const findCategoryById = (id) => categories.find(c => c.id === parseInt(id));

// Rota para listar todas as categorias
router.get('/', (req, res) => {
  res.send(categories);
});

// Rota para obter detalhes de uma categoria
router.get('/:id', (req, res) => {

  const id = req.params.id;
  if (!isValidId(id)) {
    return res.status(400).send({ error: 'ID inválido' });
  }

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

  if (name.length < 2) {
    return res.status(400).send({ error: 'Nome deve ter pelo menos 2 caracteres' });
  }

  if (name.length > 50) {
    return res.status(400).send({ error: 'Nome não pode ter mais que 50 caracteres' });
  }

  if (description && description.length > 200) {
    return res.status(400).send({ error: 'Descrição não pode ter mais que 200 caracteres' });
  }

  if (categories.some(c => c.name.toLowerCase() === name.toLowerCase())) {
    return res.status(409).send({ error: 'Categoria já existe' });
  }

  const newCategory = {
    id: nextCategoryId++,
    name,
    description: description || ''
  };

  categories.push(newCategory);
  res.status(201).send(newCategory);
});

// Rota para editar uma categoria
router.put('/:id', (req, res) => {

    const id = req.params.id;

    if (!isValidId(id)) {
      return res.status(400).send({ error: 'ID inválido' });
    }

    const categoryId = parseInt(req.params.id);
    const { name, description } = req.body;
  
    // Validações
    if (!name) {
      return res.status(400).send({ error: 'Nome da categoria é obrigatório' });
    }
    if (name.length < 2) {
    return res.status(400).send({ error: 'Nome deve ter pelo menos 2 caracteres' });
  }

  if (name.length > 50) {
    return res.status(400).send({ error: 'Nome não pode ter mais que 50 caracteres' });
  }

  if (description && description.length > 200) {
    return res.status(400).send({ error: 'Descrição não pode ter mais que 200 caracteres' });
  }
  
    // Encontra a categoria pelo ID
    const category = findCategoryById(categoryId);
    if (!category) {
      return res.status(404).send({ error: 'Categoria não encontrada' });
    }
  
    // Verifica se o novo nome já existe (ignorando a própria categoria)
    const nameExists = categories.some(
      c => c.id !== categoryId && c.name.toLowerCase() === name.toLowerCase()
    );
    if (nameExists) {
      return res.status(409).send({ error: 'Já existe uma categoria com esse nome' });
    }
  
    // Atualiza a categoria
    category.name = name;
    category.description = description || ''; // Mantém a descrição atual se não for fornecida
  
    res.status(200).send(category);
  });

// Rota para deletar categoria
router.delete('/:id', (req, res) => {
  const id = parseInt(req.params.id);

  if (!isValidId(id)) {
    return res.status(400).send({ error: 'ID inválido' });
  }

  const categoryIndex = categories.findIndex(c => c.id === id);

  if (categoryIndex === -1) {
    return res.status(404).send({ error: 'Categoria não encontrada' });
  }

  const category = categories[categoryIndex];
  
  // Verifica se a categoria está sendo usada em algum prato
  const isCategoryInUse = dishes.some(d => d.category === category.name);
  if (isCategoryInUse) {
    return res.status(409).send({ 
      error: 'Não é possível excluir: categoria está vinculada a pratos' 
    });
  }

  categories.splice(categoryIndex, 1);
  res.status(204).send();
});

module.exports = router;
