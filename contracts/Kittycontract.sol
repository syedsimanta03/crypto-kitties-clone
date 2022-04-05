//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./IERC721.sol";

contract Kittycontract is IERC721 {
    string constant name = "FillipKitties";
    string constant symbol = "FK";

    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;

    mapping(uint256 => address) kittyIndexToOwner;
    mapping(address => uint256) ownershipTokenCount;

    function balanceOf(address owner)
        external
        view
        override
        returns (uint256 balance)
    {
        return ownershipTokenCount[owner];
    }

    function totalSupply() public view override returns (uint256) {
        return kitties.length;
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        override
        returns (address)
    {
        return kittyIndexToOwner[_tokenId];
    }

    function transfer(address _to, uint256 _tokenId) public override {
        require(_to != address(0));
        require(_owns(msg.sender, _tokenId));

        _transfer(msg.sender, _to, _tokenId);
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        kittyIndexToOwner[_tokenId] = _to;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
        }

        // Emit the transfer event.
        emit Transfer(_from, _to, _tokenId);
    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
      return kittyIndexToOwner[_tokenId] == _claimant;
  }
}
