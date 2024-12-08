// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";




contract Laboratory is ReentrancyGuard, Ownable, ERC721URIStorage {


    // Contador de NFT vinculados al medicamento.
    uint256 public drugs_count;
    address payable current_owner;
    

    /*
        @title: "struct Coordinates"

        @notice: las coordenadas serviran para geolocalizar el momento en el que cambian de "owner" seran 
                    almacenadas sin coma, por ejemplo en google maps cuando buscas una direccion 
                    un posible resultado es ( -34.664729, -58.728193 ), siguiendo este ejemplo entonces:

        @params:  latitud => se guardara sin coma el resultado osea, "-34664729"
        @params:  longitud => se guardara sin coma el resultado osea, "-58728193"
        @params:  decimales => guardara los decimales que tiene "longitud" y "latitud" en este caso 6 como los guarda Google Maps

        La explicacion a esto es, con el valor de decimales, el frontend de la Dapp podra entender que esos valores tienen 
            tantos decimales para poder parsear la cordenada a su formato original.
    */

    struct Coordinates {
        int256 latitude;
        int256 longitude;
        int256 decimals;
    }

    // Estructura del NFT vinculado al medicamento.
    struct ItemProperties{
        uint tokenId;
        uint price;
        uint product_code;
        uint creation_date;
        uint expiration_date;
        string entity_name;
        address[] owners_history;
        Coordinates[] coordinate_history;
    }

    mapping(uint => ItemProperties) public Drugs;



    event ItemCreated (
        uint tokenId,
        address indexed owner,
        uint price,
        string laboratory_name,
        uint creation_onChain
    );


    event SoldItem(
        uint tokenId,
        address indexed old_owner,
        address indexed new_owner,
        uint price_sold,
        string new_entity,
        uint sold_datetime
    );

    error PriceCannotBeZero();
    error InitialValuesCannotBeInvalid();
    error ErrorWhenChangingOwner();
    error InsufficientBalanceToChange();
    error OnlyOwnerCanChangeThePrice();



    modifier onlyCurrentOwner(uint256 _tokenId) {
        require(msg.sender == ownerOf(_tokenId), OnlyOwnerCanChangeThePrice());
        _;
    }


    constructor (
        address _initialOwner,
        string memory _name, 
        string memory _symbol
        ) 

        ERC721 (_name, _symbol)
        Ownable (_initialOwner)

        {

        }



    function makeDrug(

            string memory uri, 
            uint _price,
            uint _product_code,
            uint _creation_date, // <-- Este valor tiene que ser proporcionado en segundos desde la fecha que se emitio
            uint _calculated_expiration_date, // <- Este valor depende de "creation_date" y se le tiene que sumar en segundos para calcular la fecha de vencimiento
            string memory _laboratory_name,
            int _latitude,
            int _longitude,
            int _decimals
            )
                public
                nonReentrant  //  <== Modificadores de funciones
                onlyOwner
            {
                require(_price > 0, PriceCannotBeZero());
                require(_product_code > 0, InitialValuesCannotBeInvalid());
                require(_creation_date > 0, InitialValuesCannotBeInvalid());
                require(_calculated_expiration_date > 0, InitialValuesCannotBeInvalid());
                require(bytes(_laboratory_name).length > 0, InitialValuesCannotBeInvalid());

                drugs_count++;
                _safeMint(msg.sender, drugs_count);
                _setTokenURI(drugs_count, uri);


                ItemProperties storage newDrug = Drugs[drugs_count];

                newDrug.tokenId = drugs_count;
                newDrug.price = _price;
                newDrug.product_code = _product_code;
                newDrug.creation_date = _creation_date;
                newDrug.expiration_date = _creation_date + _calculated_expiration_date;
                newDrug.entity_name = _laboratory_name;
                newDrug.owners_history.push(msg.sender);
                newDrug.coordinate_history.push(Coordinates({
                    latitude: _latitude,
                    longitude: _longitude,
                    decimals: _decimals
                }));

                current_owner = payable(msg.sender);

                emit ItemCreated(
                    drugs_count,
                    msg.sender,
                    _price,
                    _laboratory_name,
                    block.timestamp
                );
            }

}