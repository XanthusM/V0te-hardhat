// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Vote {
    address public owner;
    bool public live;
    mapping (address => uint) public balance;
    mapping(address => bool) private Voted; // To check voters cast their votes before
    mapping (uint => Candidate) public candidates;
    uint private count;
    address payable prizeAmount;
    uint public amount;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event UpVote(string Candidate, uint upVoate);

    struct Candidate {
        uint id;
        string name;
        uint totalVotes;
    }

    // Candidator
    function addCandidator (string memory name) public onlyOwner {
        candidates[count] = Candidate(count, name, 0);
        count ++;
    }

    function upV0te(uint candidateId) public payable {
        amount = 0.01 ether;
        require(Voted[msg.sender] == false); // Voters should not cast their votes before
        require(msg.value >= 0.01 ether, "SMALL_ETH");
        candidates[candidateId].totalVotes++;
        Voted[msg.sender] = true;
        prizeAmount.transfer(amount);
        
        // emit event
        emit UpVote(candidates[candidateId].name, candidates[candidateId].totalVotes);
    }


    function finishV0te() public view returns (uint winnerVoteId_, uint candidateId) {
        uint winningVoteCount = 0;
        Candidate storage s = candidates[candidateId];
        for (uint v = 0; v < candidates[candidateId]; v++) {
            if (candidates[v].totalVotes > winningVoteCount) {
                winningVoteCount = candidates[v].totalVotes;
                winnerVoteId_ = v;
            }
        }
    }

    function winnerVote(uint winnerVoteId_) public onlyOwner {
        winnerVoteId_ = Candidate[finishV0te()].name;
        uint prizeForCandidate = prizeAmount/100*90;
        Candidate[finishV0te()].transfer(prizeForCandidate);
    }

    function withdrawComissions() public onlyOwner {
        uint comissions = prizeAmount/100*10;
        owner.transfer(comissions);
    }
    
    function showCandidate() public view returns(address[] memory) {
        return candidates;
    }
}