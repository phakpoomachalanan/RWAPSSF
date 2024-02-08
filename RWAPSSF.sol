// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./CommitReveal.sol";

contract RWAPSSF {
    struct Player {
        uint choice; // 0 - Rock, 1 - Fire , 2 - Scissors, 3 - Sponge, 4 - Paper, 5 - Air, 6 - Water, 7 - Undefined
        uint timestamp;
        uint playerNumber;
        address addr;
    }
    uint internal numPlayer = 0;
    uint internal reward = 0;
    mapping (uint => Player) private player;
    mapping (address => uint) private playersNumber;
    uint internal numInput = 0;
    uint internal timeLimit = 1 minutes;

    function reset() private {
        numPlayer = 0;
        reward = 0;
        numInput = 0;

        for(uint i = 0; i < 2; i++) {
            playersNumber[player[i].addr] = 0;
            player[i].choice = 7;
            player[i].timestamp = 0;
            player[i].playerNumber = 0;
            player[i].addr = address(0);
        }
    }

    function viewPlayer() public view returns(uint choice, uint timestamp, uint playerNumber, address addr){
        uint playerId = playersNumber[msg.sender];
        require(playerId != 0);
        Player memory temp = player[playerId];
        return (temp.choice, temp.timestamp, temp.playerNumber, temp.addr);
    }

    function viewGameStatus() public view returns(uint numberOfPlayer, uint gameReward, uint numberOfInput, uint canWithdrawAfter) {
        return (numPlayer, reward, numInput, timeLimit);
    }

    function addPlayer() public payable {
        require(numPlayer < 2);
        require(msg.value == 1 ether);
        require(playersNumber[msg.sender] == 0);

        reward += msg.value;
        numPlayer++;
        player[numPlayer].choice = 7;
        player[numPlayer].timestamp = block.timestamp;
        player[numPlayer].playerNumber = numPlayer;
        player[numPlayer].addr = msg.sender;
        playersNumber[msg.sender] = numPlayer;
    }

    function input(uint choice) public  {
        uint idx = playersNumber[msg.sender];
        require(numPlayer == 2);
        require(choice < 7);
        require(idx != 0);

        player[idx].choice = choice;
        numInput++;

        if (numInput == 2) {
            _checkWinnerAndPay();
        }
    }

    function withdraw() public payable {
        uint idx = playersNumber[msg.sender];
        require(player[idx].timestamp + timeLimit < block.timestamp);
        require(numPlayer == 1 || numInput == 1);
        
        payable(player[idx].addr).transfer(reward);
        reset();
    }

    function _checkWinnerAndPay() private {
        uint p0Choice = player[1].choice;
        uint p1Choice = player[2].choice;
        address payable account0 = payable(player[0].addr);
        address payable account1 = payable(player[1].addr);
        if ((p0Choice + 1) % 7 == p1Choice || (p0Choice + 2) % 7 == p1Choice || (p0Choice + 3) % 7 == p1Choice) {
            account0.transfer(reward);
        }
        else if ((p1Choice + 1) % 7 == p0Choice || (p1Choice + 2) % 7 == p0Choice || (p1Choice + 3) % 7 == p0Choice) {
            account1.transfer(reward);    
        }
        else {
            account0.transfer(reward / 2);
            account1.transfer(reward / 2);
        }

        reset();
    }
}
