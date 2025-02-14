let historico = [
    {
        "termo": "",
        "filtros": {
            "category": "Italiana"
        }
    },
    {
        "termo": "Lasanha",
        "filtros": {}
    }
];

// Função para salvar uma busca no histórico
const salvarBusca = (termo, filtros) => {
    const busca = {
        termo,
        filtros
    };
    historico.unshift(busca);
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


module.exports = { 
    salvarBusca, 
    getHistorico, 
    limparHistorico, 
    removerBusca,
    historico
};