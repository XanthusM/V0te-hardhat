// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Vote {
    address public owner;
    mapping (uint => Candidate) public candidates;
    uint prizeAmount;
    uint votingId;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event AddVotingCandidate(uint votingId, address candidates);
    event VotingCreated(uint votingId);

    constructor(address[] memory candidates) {
    finishAt = block.timestamp + 3 days;
    }

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint proposalIndex;   // index of the voted proposal  //xx you can pack all attributes of the struct as uint16, bool, address~uint160, uint32, see https://dev.to/javier123454321/solidity-gas-optimizations-pt-3-packing-structs-23f4 можешь не переписывать код но сделать сноску что если газ будет критичен то возможна такая оптимизация но premature optimisation is the root of evil, https://wiki.c2.com/?PrematureOptimization
    }


    struct Candidate {
        uint id;
        string name;
        uint totalVotes;
    }


    function createVoting(address[] memory candidates) external onlyOwner {
    votingId = ++lastVotingId;
    require(votingFinishAt[votingId] == 0, "already exists");
    votingFinishAt[votingId] = block.timestamp + 3 days;
    require(candidates.length > 0, "empty array");
    mapping(address => bool) storage _candidates = votingCandidates[votingId];
    for (uint i = 0; i < candidates.length; i++) {
        _candidates[candidates[i]] = true;
        emit AddVotingCandidate(votingId, candidates[i]);
    }
    emit VotingCreated(votingId);
}


    function vote(uint proposal) public payable{  //xx define as external to save gas  //xx indentation space "payable {"
        Voter storage sender = voters[msg.sender];
        require(block.timestamp < finishAt, "already finished");
        require(msg.value == 1e18 / 100);  // 0.01 eth
        require(!sender.voted, "Already voted");
        require(msg.value >= 0.01 ether, "SMALL_ETH");  //xx double check see above
        sender.voted = true;
        sender.proposalIndex = proposal;

        prizeAmount += msg.value;  //xx im not sure if it's need because you always can do balance(address(this)) im not sure
    }


    function finalize(votingId) public view returns (uint winnerVoteId_, uint candidateId) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < candidates.length; p++) {  //xx this is bad, it can go out of gas! just track winningProposalVotes winningProposal and change it every time inside vote function, so you know the winning one on every step
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerVote(uint winnerVoteId_) public onlyOwner {
        winnerVoteId_ = Candidate[finalize(votingId)];
        payable(owner).call{value: prizeAmount/100 * 10}();
    }

    function withdrawFee() public onlyOwner {
        uint comissions = prizeAmount/100*10;
        owner.transfer(comissions);
    }
    
    function showCandidate() public view returns(address[] memory) {
        return candidates;
    }
}