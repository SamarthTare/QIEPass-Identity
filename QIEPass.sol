// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QIEPass is ERC721, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("QIE Identity Pass", "QID") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = tokenCounter;
        _safeMint(to, tokenId);
        tokenCounter++;
    }

    // The Soulbound Logic: Block transfers
    // Ye function token ko ek wallet se dusre wallet bhejne se rokta hai
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        
        // Agar mint nahi ho raha (from 0x0) aur burn nahi ho raha (to 0x0), 
        // toh iska matlab transfer ho raha hai -> ERROR dedo.
        if (from != address(0) && to != address(0)) {
            revert("Soulbound: This identity badge cannot be transferred");
        }
        
        return super._update(to, tokenId, auth);
    }
}