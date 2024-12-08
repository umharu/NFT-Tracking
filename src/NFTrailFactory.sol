// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/Laboratory.sol";




contract NFTrailFactory is Ownable{
    
    // Cuenta que recibe la comision cada vez que se crea un contrato por laboratorio
    address payable public feeAccount;
    uint private feePercent;

    event EthersRecividos(string _infoEtherRecibidos);


    constructor() Ownable(msg.sender) {
        feePercent = 50000000000000000;
        feeAccount = payable(msg.sender);
    }


    receive() external payable {
        emit EthersRecividos("Se han recibido y transferidos nuevos ethers");
    }


    // Almacenamiento de la informacion del Factory
    mapping (address => address) public laboratory_contracts;


    // Emision de los nuevos smart contracts
    function Factory(string memory _name, string memory _symbol) public payable  {
        require(msg.value == feePercent, "Debe pagar una comision de 1 Ether para crear el contrato");
        feeAccount.transfer(msg.value);

        address addr_personal_contract = address(new Laboratory(msg.sender, _name, _symbol));
        laboratory_contracts[msg.sender] = addr_personal_contract;
    }


    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }


}


// Contract address =  0x642679449A2FBD295432bBD5a7691E412491A190

