// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract DogRegistry {

    constructor() public payable { owner = msg.sender; }
    address payable owner;

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
   
    modifier onlyPuppyOwner(address puppyOwner){
        require(isPuppyOwner[puppyOwner] == true, "Only litter owner can call this function.");
        _;
    }
    
    struct puppyRegister {
        string puppyID;
        address dogBreeder;
        string dameID; 
        string sireID;
        string litterID;
        uint litterSize;
        string breed;
        string birthDate;
    }

    struct healthReport {
        string puppyID;
        address veterinarianDoctor;
        string veterinarianID;
        string remarks;
    }
    puppyRegister[] public dogIndex;
    healthReport[] public reportIndex;

    // Maps address of respective owners to true
    mapping(address=>bool) public isBroker;
    mapping(address=>bool) public isDogBreeder;
    mapping(address=>bool) public isVeterinarianDoctor;
    mapping(address=>bool) public isPuppyOwner;

    // Map everyone's address to IDs
    mapping(uint => address) public ownerToDog;
    mapping(address=>string) dogBreederID;
    mapping(address=>string) puppyOwnerID;
    mapping(address=>string) brokerID;
    mapping(address=>string) veterinarianDoctorID;
    mapping(address=>string) puppyID;
    mapping(string=>healthReport) healthReports; 
    
    mapping(uint=>string) seeDocRemarks;
    
    //Events
    event dogBreederAddition(address dogBreederAddress, string dogBreederID);
    event puppyOwnerAddition(address litterOwnerAddress, string litterOwnerID);
    event brokerAddition(address brokerAddress, string brokerID);
    event veterinarianDoctorAddition(address veterinarianAddress, string veterinarianID);
    event newPuppyAddition(address dogBreederAddress, string puppyID, uint dogIndex);
    event puppyReportAddition(string puppyID, string veterinarianID,  string remarks);
   
   function addBroker(address _broker,string memory _brokerID) public onlyOwner {
        isBroker[_broker] = true;
        brokerID[_broker] = _brokerID;
        emit brokerAddition(_broker,_brokerID);
    }

    function addDogBreeder(address _dogBreeder,string memory _dogBreederID) public onlyBroker(msg.sender) {
        isDogBreeder[_dogBreeder] = true;
        dogBreederID[_dogBreeder] = _dogBreederID;
        emit dogBreederAddition(_dogBreeder,_dogBreederID);
    }

    function addVeterinarianDoctor(address _veterinarianDoctor,string memory _veterinarianDoctorID) public onlyBroker(msg.sender) {
        isVeterinarianDoctor[_veterinarianDoctor] = true;
        veterinarianDoctorID[_veterinarianDoctor] = _veterinarianDoctorID;
        emit veterinarianDoctorAddition(_veterinarianDoctor,_veterinarianDoctorID);
    }

    function addPuppyOwner(address _puppyOwner,string memory _puppyOwnerID) public onlyBroker(msg.sender) {
        isPuppyOwner[_puppyOwner] = true;
        puppyOwnerID[_puppyOwner] = _puppyOwnerID;
        emit puppyOwnerAddition(_puppyOwner,_puppyOwnerID);
    }

    function addDog(
        string memory _puppyID,
        string memory _dameID, 
        string memory _sireID,
        string memory _litterID,
        uint _litterSize, 
        string memory  _breed,
        string memory _birthDate
        ) public onlyDogBreeder(msg.sender) {
        
        address _dogBreeder = msg.sender;        
        // Push input for the transactor into the dogs array. 
        //This will return the id of the dog in the list (returns the index possition in the array)
        // therefore we stroe it as an unsigned integer named id
        uint index = dogIndex.push(puppyRegister(_puppyID, _dogBreeder, _dameID, _sireID, _litterID, _litterSize, _breed, _birthDate));
        ownerToDog[index]= _dogBreeder;
        emit newPuppyAddition(_dogBreeder, _puppyID, index);
    }

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