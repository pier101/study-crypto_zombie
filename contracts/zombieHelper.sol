
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  // 레벨 업 비용
  uint levelUpFee = 0.001 ether;

  // 함수 제어자
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // 배포자(주인) 주소로 contract balance 송금
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  // 레벨 업 비용 수정 함수
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  // 레벨 업 함수
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level = zombies[_zombieId].level.add(1);
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  // 계정별 소유 좀비 수 반환
  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint256 i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}

/*
  ## 레슨 3 요약
    CryptoKitties 컨트랙트를 변경하는 방법
    onlyOwner를 이용해 핵심적인 함수를 보호하는 방법(함수 제어자 function modifier)
    가스와 가스 사용 최적화
    좀비에 레벨과 대기시간 개념을 적용
    좀비가 특정 레벨이 되면 좀비의 이름과 DNA를 재설정할 수 있는 함수 생성
    사용자의 좀비 군대를 반환하는 함수 생성
 */


