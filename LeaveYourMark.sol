pragma solidity ^0.6.0;
// Can also provide solidity versiona as a range
// Syntax : >=0.6.0 <0.9.0

contract LeaveYourMark {
    string public githubAddress = "https://github.com/Sagar-FL/P1_blockchain";

    // struct YourMark {
    //     string name;
    //     string intro;
    // }

    mapping(string => string) public ourMarks;

    // two type of variable
    // 1. storage
    // 2. memory
    function addYourMark(string memory name, string memory introAbtYou) public {
        ourMarks[name] = introAbtYou;
    }

    // two type os state retrivals
    // 1. view
    // 2. pure
    // this works similar to ourMarks mapping defined above.
    // Just created explicit function to show the usage of returns and views
    function retriveMark(string memory name) public view returns(string memory) {
        return ourMarks[name];
    }
}
