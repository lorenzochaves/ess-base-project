// backend/src/database/historicoBuscas.js

let historico = [];

// Função para salvar uma busca no histórico
const salvarBusca = (termo, filtros) => {
  const busca = {
    termo,
    filtros,
    data: new Date().toISOString() // Data e hora da busca
  };

  // Adiciona a busca ao início do array (últimas buscas primeiro)
  historico.unshift(busca);

  // Mantém apenas as últimas 100 buscas (evita crescimento excessivo)
  if (historico.length > 100) {
    historico = historico.slice(0, 100);
  }
};

// Função para obter o histórico de buscas
const getHistorico = () => historico;

// Função para limpar o histórico de buscas
const limparHistorico = () => {
  historico = [];
};

// Função para remover uma busca específica do histórico
const removerBusca = (index) => {
  if (index >= 0 && index < historico.length) {
    historico.splice(index, 1);
  }
};

module.exports = { salvarBusca, getHistorico, limparHistorico, removerBusca };