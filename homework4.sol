// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract ProposalContract {
    // ****************** Data ***********************

    //Owner
    address owner;

    uint256 private counter;

    struct Proposal 
    {
        string title; //Title of the proposal
        string description; // Description of the proposal
        uint256 approve; // Number of approve votes
        uint256 reject; // Number of reject votes
        uint256 pass; // Number of pass votes
        uint256 totalVoteToEnd; // When the total votes in the proposal reaches this limit, proposal ends
        bool currentState; // This shows the current state of the proposal, meaning whether if passes of fails
        bool isActive; // This shows if others can vote to our contract
    }

    mapping(uint256 => Proposal) proposalHistory; // Recordings of previous proposals

    address[] private votedAddresses; 

    //constructor
    constructor() 
    {
        owner = msg.sender;
        votedAddresses.push(msg.sender);
    }

    modifier onlyOwner() 
    {
        require(msg.sender == owner);
        _;
    }

    modifier active() 
    {
        require(proposalHistory[counter].is_active == true);
        _;
    }

    modifier newVoter(address _address) 
    {
        require(!isVoted(_address), "Address has already voted");
        _;
    }


//     // ****************** Execute Functions ***********************


    function setOwner(address new_owner) external onlyOwner 
    {
        owner = new_owner;
    }

    function create(string calldata _title, string calldata _description, uint256 _totalVoteToEnd) external onlyOwner 
    {
        counter += 1;
        proposalHistory[counter] = Proposal(_title, _description, 0, 0, 0, _totalVoteToEnd, false, true);
    }
    

    function vote(uint8 choice) external active newVoter(msg.sender)
    {
        Proposal storage proposal = proposalHistory[counter];
        uint256 total_vote = proposal.approve + proposal.reject + proposal.pass;

        votedAddresses.push(msg.sender);

        if (choice == 1) {
            proposal.approve += 1;
            proposal.current_state = calculateCurrentState();
        } else if (choice == 2) {
            proposal.reject += 1;
            proposal.current_state = calculateCurrentState();
        } else if (choice == 0) {
            proposal.pass += 1;
            proposal.current_state = calculateCurrentState();
        }

        if ((proposal.total_vote_to_end - total_vote == 1) && (choice == 1 || choice == 2 || choice == 0)) {
            proposal.is_active = false;
            votedAddresses = [owner];
        }
    }


    function calculateCurrentState() private view returns(bool) 
    {
        Proposal storage proposal = proposalHistory[counter];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        
        if (approve > reject) 
            return true;
        else 
            return false;
    }

}
