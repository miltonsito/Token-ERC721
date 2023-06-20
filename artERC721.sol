// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

//Importamos smart contract
import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";



contract ArtToken is ERC721, Ownable {

      // Initial Statement

      //Smat contract constructor

      constructor(string memory _name, string memory _symbol) 
      ERC721 (_name , _symbol){}

      //NFT token counter
      uint256 COUNTER;

      //Precing NFT Token (Price of the artwork)
      uint256 fee = 5 ether;

      //Data structure with the properties of the  artwork
      struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
      }

      //Storage structure for keeping artwork
      Art[] public art_works;


      //Declaration of an event  
      event NewArtWork (address indexed owner, uint256 id, uint256 dna);

     // Help functions
     
     //Creation de random number (required for NFT propertions)
        function _createRandomNumber(uint256 _mod) internal view returns (uint256){
          bytes32 has_RamdomNumber = keccak256(abi.encodePacked(block.timestamp, msg.sender));
          uint256 RandomNumber = uint256(has_RamdomNumber);
          return RandomNumber %  _mod;
         }

      // NFT create token(Artwork)
      function _createArtWork(string memory _name) internal {
       uint8 randRarity = uint8(_createRandomNumber(1000));
       uint256 ranDna = _createRandomNumber(10**16);
       Art memory newArtWork = Art(_name, COUNTER, ranDna, 1, randRarity);
       art_works.push(newArtWork);
       _safeMint(msg.sender, COUNTER);
       emit NewArtWork (msg.sender, COUNTER, ranDna);
       COUNTER++;
      }

      //NFT token price update
      function updateFree(uint256 _fee) external onlyOwner {
      fee = _fee;
      }
      
      //Visualize the balance of the Smart contract   (ethers)
       function infoSmartContract() public view returns (address, uint256){
         address SC_adress = address(this);
         uint256 SC_money = address(this).balance / 10**18;
         return (SC_adress, SC_money);
       } 

     //Obteainig all createNT token (Artwork) 
     function getArtWorks() public view  returns (Art [] memory ){
     return art_works;
     }

     //Obteaning user's  NFT tokens 
     function getOwnerArworks(address _owner) public view returns (Art [] memory){
      Art [] memory result = new Art[] (balanceOf(_owner));
      uint256 owner_counter = 0;
      for (uint256 i = 0; i < art_works.length; i++){
        if (ownerOf(i) == _owner){
          result[owner_counter]  = art_works[i];
          owner_counter++;
        }
      }
    return result;
     }

     //Generation de NFT developement


     //NFT token payment 

     function  createRandomArtWork(string memory _name) public payable{
      require (msg.value >= fee);
      _createArtWork (_name);
      }
     // Extraction of ethers from the Smart Contract to the owner
     function withdraw() external payable onlyOwner{
       address payable _owner = payable (owner());
       _owner.transfer(address(this).balance);
     }
   
    //Level up NFT Token
    function levelUp(uint256 _artId) public {
      require (ownerOf(_artId) == msg.sender);
      Art storage  art = art_works[_artId];
      art.level++;
    }
     
}