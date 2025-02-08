const express = require('express');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 4001;

// Importação das rotas modularizadas
const dishesRouter = require('./src/routes/dishes');
const categoriesRouter = require('./src/routes/categories');
const usersRouter = require('./src/routes/users');
const reviewsRouter = require('./src/routes/reviews');

// Montagem das rotas
app.use('/dishes', dishesRouter);
app.use('/categories', categoriesRouter);
app.use('/users', usersRouter);
app.use('/reviews', reviewsRouter);

// Inicialização do servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
