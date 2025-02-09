const express = require('express');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 4001;

// Importação das rotas modularizadas
const pratosRouter = require('./routes/gerenciaPratos');
const categoriesRouter = require('./routes/gerenciaCategorias.js');
const buscasRouter= require('./routes/buscas.js');
const mostViewedRouter= require('./routes/mostViewed.js');
//const usersRouter = require('./src/routes/gerenciaUsuarios.js');
//const reviewsRouter = require('./src/routes/reviews');

// Montagem das rotas
app.use('/dishes', pratosRouter);
app.use('/categories', categoriesRouter);
app.use('/search', buscasRouter);
app.use('/most-viewed', mostViewedRouter);
//app.use('/users', usersRouter);
//app.use('/reviews', reviewsRouter);

// Inicialização do servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
