// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0 < 0.9.5;

contract Lottery{

    address public manager;
    address payable[] public participants;
    

    constructor (){
        manager = msg.sender;
    }
    receive() external payable{
        require(msg.value == 0.01 ether,"You have to send 0.01 Ether");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager,"You don't have permission to check balance");
        return address(this).balance;
    }

    function random() public view returns (uint) {
        // sha3 and now have been deprecated
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
        // convert hash to integer

    }

    function pickWinner() public{
        require(msg.sender == manager,"You have no right");
        require(participants.length>=3,"No winner");

        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner=participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }



}


