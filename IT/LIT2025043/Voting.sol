//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Voting{
address owner;
uint public total_votes;
uint public total_candidates;
uint public result;
bool public candidates_set=false;
bool public voting_open=false;
bool public result_declared=false;
uint more_votes_index;
struct Candidates{
    string candidate_name;
    uint candidate_index;
    uint candidate_votes;
}
Candidates[] public candidates;
mapping(address => bool) public hasVoted;

constructor(uint _total_candidates){
owner=msg.sender;
total_candidates=_total_candidates;
}
modifier onlyOwner{
        require(msg.sender == owner, "Not contract owner");
        _;
    }
function set_candidates(string memory _name,uint _index) onlyOwner public{
    require(candidates_set==false,"Candidates are already set");
     require(candidates.length < total_candidates, "All candidates already added");
     candidates.push(Candidates(_name,_index,0));
     if (candidates.length == total_candidates) {
        candidates_set = true;
        voting_open = true;
    }
}
function put_vote(uint _candidate_no) public {
    require(!hasVoted[msg.sender], "You have already voted");
    require(candidates_set==true,"Candidates are not set");
    require(voting_open==true,"Voting not Open");
    require(_candidate_no<candidates.length,"Invalid Candidate");
    candidates[_candidate_no].candidate_votes+=1;
    total_votes++;
    hasVoted[msg.sender] = true;
}
function close_voting() public onlyOwner{
require(voting_open==true,"Voting already Closed");
voting_open=false;
}
function view_votes(uint _candidate_index) view public returns(uint) {
return candidates[_candidate_index].candidate_votes;   
}
function declare_winner() public onlyOwner returns(string memory){
require(voting_open==false, "voting is still open");
result_declared=true;
more_votes_index = 0;
for(uint i=0;i<candidates.length;i++)
    {
        if(candidates[more_votes_index].candidate_votes<candidates[i].candidate_votes) {
            more_votes_index=i;
         } 
    }
    return candidates[more_votes_index].candidate_name;
}
}
