// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libs/Base64.sol";

contract NFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string private baseSvg =
    "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] private faces = [
    unicode"😍",
    unicode"😅",
    unicode"😫",
    unicode"🧙🏼‍♂️",
    unicode"😈",
    unicode"👽"
  ];
  string[] private actions = [
    unicode"👅",
    unicode"🙏",
    unicode"🙈",
    unicode"🛵",
    unicode"💯",
    unicode"🏄🏼‍♂️"
  ];
  string[] private targets = [
    unicode"🍥",
    unicode"🍌",
    unicode"🪐",
    unicode"🌵",
    unicode"🦄",
    unicode"🐍"
  ];

  event NewNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721("TripleEmoji", "TRIMOJI") {
    console.log("This is my NFT contract. Whoa!");
  }

  function pickRandomFace(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson.
    uint256 rand = random(
      string(abi.encodePacked("FIRST_EMOJI", Strings.toString(tokenId)))
    );
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % faces.length;
    return faces[rand];
  }

  function pickRandomAction(uint256 tokenId)
    public
    view
    returns (string memory)
  {
    uint256 rand = random(
      string(abi.encodePacked("SECOND_EMOJI", Strings.toString(tokenId)))
    );
    rand = rand % actions.length;
    return actions[rand];
  }

  function pickRandomTarget(uint256 tokenId)
    public
    view
    returns (string memory)
  {
    uint256 rand = random(
      string(abi.encodePacked("THIRD_EMOJI", Strings.toString(tokenId)))
    );
    rand = rand % targets.length;
    return targets[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function make() public {
    uint256 newItemId = _tokenIds.current();

    string memory face = pickRandomFace(newItemId);
    string memory action = pickRandomAction(newItemId);
    string memory target = pickRandomTarget(newItemId);
    string memory combinedEmoji = string(
      abi.encodePacked(face, action, target)
    );

    string memory finalSvg = string(
      abi.encodePacked(baseSvg, combinedEmoji, "</text></svg>")
    );

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            // We set the title of our NFT as the generated word.
            combinedEmoji,
            '", "description": "A generous collection of emoji triplets.", "image": "data:image/svg+xml;base64,',
            // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
            Base64.encode(bytes(finalSvg)),
            '"}'
          )
        )
      )
    );

    string memory finalTokenURI = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(
      string(
        abi.encodePacked("https://nftpreview.0xdev.codes/?code=", finalTokenURI)
      )
    );
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenURI);

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    _tokenIds.increment();

    emit NewNFTMinted(msg.sender, newItemId);
  }
}
