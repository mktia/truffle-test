pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract IdeaFactory is Ownable {

  event NewIdea(uint id, string content);

  struct Idea {
    uint ideaId;
    string content;
    uint32 good;
  }

  Idea[] public ideas;

  mapping(uint => address) public ideaToOwner;

  function comeUpWithIdea(string _content) public returns (uint) {
    uint id = ideas.length;
    ideas.push(Idea(id, _content, 0));
    ideaToOwner[id] = msg.sender;
    emit NewIdea(id, _content);

    return id;
  }

  function getIdea(uint _id) public view returns (string) {
    return ideas[_id].content;
  }

  function getIdeaCount() public view returns (uint) {
    return ideas.length;
  }

  // function sayGoodForIdea()

}
