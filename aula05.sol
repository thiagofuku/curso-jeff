//SPDX-License-Identifier: CC-BY-4.0
pragma solidity 0.8.20;

contract ControleDePermissoes {
    address public locador;

    modifier apenasLocador() {
        require (msg.sender == locador, "Apenas locador");
        _;
    }

    constructor(){
        locador = msg.sender;
    }

}

contract AluguelContract is ControleDePermissoes {

    struct Aluguel {
        string locatario;
        string locador;
        uint256 valor;
        bytes32 identificadorUnicoDasPartes;
    }
    
    mapping(uint256 => Aluguel) public listaAlugueis;
    uint256[] valoresAluguel;

    constructor(string memory _locador, string memory _locatario, uint256 _valor)  {

        for (uint256 i = 0; i < 36; i++) {
            Aluguel memory aluguel = Aluguel(
                _locador,
                _locatario,
                _valor,
                keccak256(bytes(string.concat(_locador, _locatario)))
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
        apenasLocador
        returns (Aluguel memory)
    {
        return listaAlugueis[posicao];
    }

    function buscarIdentificacaoUnicaDasPartes(uint256 posicao)
        external
        view
        returns (bytes32)
    {
        return listaAlugueis[posicao].identificadorUnicoDasPartes;
    }
    
}