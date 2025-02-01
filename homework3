// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {

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

    function createProposal(string calldata _title, string calldata _description, uint256 _totalVoteToEnd) external 
    {
        counter += 1;
        proposalHistory[counter] = Proposal(_title, _description, 0, 0, 0, _totalVoteToEnd, false, true);
    }
}
