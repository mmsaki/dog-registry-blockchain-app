// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.5;

import "./DogNFT.sol";

contract DogRegistry is DogNFT {

    constructor() public payable { owner = msg.sender; }
    address payable owner;

    // Adding modifiers to restrict functions to specific entities
    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
        _;
    }

    modifier onlyBroker(address broker) {
        require(isBroker[broker] == true, "Only broker can call this function.");
        _;
    }

    modifier onlyDogBreeder(address dogBreeder){
        require(isDogBreeder[dogBreeder] == true, "Only breeder can call this function.");
        _;
    }
    modifier onlyVeterinarianDoctor(address veterinarianDoctor){
        require(isVeterinarianDoctor[veterinarianDoctor] == true, "Only veterinarian can call this function.");
        _;
    }
    
    struct healthReport {
        string puppyID;
        address veterinarianDoctor;
        string veterinarianID;
        string remarks;
    }

    healthReport[] public reportIndex;

    // Maps address of respective owners to true
    mapping(address=>bool) public isBroker;
    mapping(address=>bool) public isDogBreeder;
    mapping(address=>bool) public isVeterinarianDoctor;

    // Mapping to return designated IDs
    mapping(address=>string) public dogBreederID;
    mapping(address=>string) public brokerID;
    mapping(address=>string) public veterinarianDoctorID;
    mapping(uint=>string) public getPuppyID;
    // Mapping to return doctor reports 
    mapping(string=>healthReport) healthReports;
    mapping(uint=>string) seeDocRemarks;
    
    //Events that we will use in our app to track smart contract interactions
    event dogBreederAddition(address dogBreederAddress, string breederID);
    event brokerAddition(address brokerAddress, string brokerID);
    event veterinarianDoctorAddition(address veterinarianAddress, string vetID);
    event newPuppyAddition(address dogBreederAddress, string puppyID);
    event puppyReportAddition(string puppyID, string veterinarianID,  string remarks);
   
   // function that adds broker address and assigns an ID to the broker
   function addBroker(address _broker,string memory _brokerID) public onlyOwner {
        isBroker[_broker] = true;
        brokerID[_broker] = _brokerID;
        emit brokerAddition(_broker,_brokerID);
    }

    // function that adds a dog breeder and assigns an ID to the breeder
    function addDogBreeder(address _dogBreeder,string memory _dogBreederID) public onlyBroker(msg.sender) {
        isDogBreeder[_dogBreeder] = true;
        dogBreederID[_dogBreeder] = _dogBreederID;
        emit dogBreederAddition(_dogBreeder, _dogBreederID);
    }

    // Function that add a Veterinary Doctor and assigns an ID to the doctor
    function addVeterinarianDoctor(address _veterinarianDoctor,string memory _veterinarianDoctorID) public onlyBroker(msg.sender) {
        isVeterinarianDoctor[_veterinarianDoctor] = true;
        veterinarianDoctorID[_veterinarianDoctor] = _veterinarianDoctorID;
        emit veterinarianDoctorAddition(_veterinarianDoctor, _veterinarianDoctorID);
    }

    // Function that is used to register a dog
    function addDog(
        address dog_owner,
        string memory name,
        string memory breed,
        string memory dame,
        string memory sire, 
        uint256 initialAppraisalValue,
        string memory tokenURI,
        string memory tokenJSON
        ) public onlyDogBreeder(msg.sender) {
        registerDog(dog_owner, name, breed, dame, sire, initialAppraisalValue, tokenURI, tokenJSON);
        emit newPuppyAddition(dog_owner, breed);
    }

    // Function that only the Veterinary doctor can add a report on the dog
    function addPuppyReport(
        string memory _puppyID, 
        address _veterinarianDoctor,
        string memory _veterinarianID, 
        string memory _remarks
        ) public onlyVeterinarianDoctor(msg.sender) {
        
        uint index = reportIndex.push(healthReport(_puppyID, _veterinarianDoctor, _veterinarianID, _remarks));
        seeDocRemarks[index]=_remarks;
        emit puppyReportAddition(_puppyID, _veterinarianID, _remarks);
    }
}