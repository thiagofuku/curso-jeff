//SPDX-License-Identifier: CC-BY-4.0
pragma solidity 0.8.20;

contract AluguelContract {

    struct Aluguel {
        string locatario;
        string locador;
        uint256 valor;
    }
    
    mapping(uint256 => Aluguel) public listaAlugueis;

    string public locatario;
    string public locador;
    uint256[] valoresAluguel;

    uint256 constant numeroMaximoLegalDeAlgueisParaMulta = 3;

    constructor(string memory _locador, string memory _locatario, uint256 _valor)  {

        for (uint256 i = 0; i < 36; i++) {
            Aluguel memory aluguel = Aluguel(
                _locador,
                _locatario,
                _valor
            );
            listaAlugueis[i] = aluguel;
        }

    }

    modifier validaMulta(uint256 multa) {
        require(multa < 1000, "A multa deve ser menor que 1000");
        _;
    }
 
    function calcularReceitaTotal()
        external
        view
        returns (uint256)
    {
        uint256 valoresTotais;
        for (uint256 i = 0; i < 36; i++) {
            valoresTotais += listaAlugueis[i].valor;
        }
        return valoresTotais;
    }

    function gerarMulta(uint256 posicao, uint256 valorMulta)
        external
        validaMulta(valorMulta) 
        returns (string memory)
    {
        listaAlugueis[posicao].valor += valorMulta;
        return "Multa gerada";
    }

    function buscarAluguelPorPosicao(uint256 posicao)
        external
        view
        returns (Aluguel memory)
    {
        return listaAlugueis[posicao];
    }
    
}