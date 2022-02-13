pragma solidity ^0.4.19;
import "./zombiehelper.sol";
import "./safemath.sol";

contract ZombieAttack is ZombieHelper {

    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    using SafeMath for uint256;
    // 난수 생성
    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    // 공격 함수
    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        //승리시
        if (rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            // ??
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else { //패배시
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
        }
    _triggerCooldown(myZombie);
    }

}
