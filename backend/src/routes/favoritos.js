const express = require('express');
const router = express.Router();
const { dishes } = require('../database/pratos.js');

const userFavorites = {}; // Objeto para armazenar os favoritos por usuário

// Middleware para validar usuário (como não há autenticação, recebemos um ID simples)
const validateUser = (req, res, next) => {
    const { userId } = req.body;
    if (!userId) {
        return res.status(400).send({ error: 'Usuário não identificado' });
    }
    if (!userFavorites[userId]) {
        userFavorites[userId] = []; // Inicializa a lista de favoritos do usuário
    }
    req.userId = userId;
    next();
};

// Rota para adicionar um prato aos favoritos
router.post('/add', validateUser, (req, res) => {
    const { dishId } = req.body;
    const dish = dishes.find(d => d.id === parseInt(dishId));

    if (!dish) {
        return res.status(404).send({ error: 'Prato não encontrado' });
    }

    if (userFavorites[req.userId].includes(dishId)) {
        return res.status(409).send({ error: 'Prato já está nos favoritos' });
    }

    userFavorites[req.userId].push(dishId);
    res.status(201).send({ message: 'Prato adicionado aos favoritos', favorites: userFavorites[req.userId] });
});

// Rota para visualizar os pratos favoritos do usuário
router.get('/list', validateUser, (req, res) => {
    const favoriteDishes = userFavorites[req.userId].map(id => dishes.find(d => d.id === id));
    res.send(favoriteDishes);
});

// Rota para remover um prato dos favoritos
router.delete('/remove', validateUser, (req, res) => {
    const { dishId } = req.body;
    userFavorites[req.userId] = userFavorites[req.userId].filter(id => id !== parseInt(dishId));
    res.send({ message: 'Prato removido dos favoritos', favorites: userFavorites[req.userId] });
});

// Rota para organizar favoritos (reordenar manualmente)
router.put('/reorder', validateUser, (req, res) => {
    const { orderedIds } = req.body;
    
    if (!Array.isArray(orderedIds) || orderedIds.some(id => !userFavorites[req.userId].includes(id))) {
        return res.status(400).send({ error: 'Ordem inválida' });
    }

    userFavorites[req.userId] = orderedIds;
    res.send({ message: 'Lista de favoritos reordenada', favorites: userFavorites[req.userId] });
});

module.exports = router;