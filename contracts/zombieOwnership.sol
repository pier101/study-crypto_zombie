//ERC721 구현
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

    using SafeMath for uint; //uint(uint256) 타입에 한해 safemath 라이브러리 사용가능
                                //오버 플로우/언더픞로우 발생가능 지점에 적용

    mapping (uint => address) zombieApprovals;

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        // 기존에 만들어진 zombieToOwner 쓰면 안되나?
        zombieApprovals[_tokenId] = _to; 
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(msg.sender == zombieApprovals[_tokenId]);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}
