// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract DogRegistry {

    constructor() public payable { owner = msg.sender; }
    address payable owner;

    // This contract only defines a modifier but does not use
    // it: it will be used in derived contracts.
    // The function body is inserted where the special symbol
    // `_;` in the definition of a modifier appears.
    // This means that if the owner calls this function, the
    // function is executed and otherwise, an exception is
    // thrown.
    //Modifiers

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
    
    struct qualityReport{
        address veterinarianDoctor;
        uint256 litterSize;
        uint256 healthy; // takes in the number of healthy dogs in the litter
        string remarks;
    }
    struct litterOwnerReport{
        string remarks;
        string receivedShipment;
        qualityReport qualityreport;
    }
    struct puppyReport{
        address dogBreeder;
        string dameID; 
        string sireID;
        string litterID;
        uint litterSize;
        string birthDate;
        uint256 puppyID;
        // litterOwnerReport processedReport;
    }
   
    // Maps address of respective Stakeholders to true
    mapping(address=>bool) public isDogBreeder;
    mapping(address=>bool) public isPuppyOwner;
    mapping(address=>bool) public isBroker;
    mapping(address=>bool) public isVeterinarianDoctor;
    mapping(uint=>bool) public isPuppyID;
   
    // Map everyone's address to puppy
    mapping(address=>string) dogBreederMapping;
    mapping(address=>string) puppyOwnerMapping;
    mapping(address=>string) brokerMapping;
    mapping(address=>string) veterinarianDoctorMapping;
    mapping(uint=>string) puppyMapping;
   
    //Events
    event dogBreederAddition(address dogBreederAddress,string dogBreederID);
    event litterOwnerAddition(address litterOwnerAddress,string litterOwnerID);
    event brokerAddition(address brokerAddress,string brokerID);
    event veterinarianDoctorAddition(address veterinarianAddress,string veterinarianID);
    event newPuppyAddition(address dogBreederAddress, string puppyID);

  
    
    mapping(address=>mapping(string=>qualityReport)) qualityReports; // mapping of dogBreeders address to litterID and report
    mapping(address=>mapping(address => mapping(string=>litterOwnerReport))) litterOwnerReports;
    mapping(address=>mapping(string=>puppyReport)) puppyReports;
   
   function addBroker(address _broker,string memory _brokerID) public onlyOwner {
        isBroker[_broker] = true;
        brokerMapping[_broker] = _brokerID;
        emit brokerAddition(_broker,_brokerID);
    }

    function addDogBreeder(address _dogBreeder,string memory _dogBreederID) public onlyBroker(msg.sender) {
        isDogBreeder[_dogBreeder] = true;
        dogBreederMapping[_dogBreeder] = _dogBreederID;
        emit dogBreederAddition(_dogBreeder,_dogBreederID);
    }

    function addVeterinarianDoctor(address _veterinarianDoctor,string memory _veterinarianDoctorID) public onlyBroker(msg.sender) {
        isVeterinarianDoctor[_veterinarianDoctor] = true;
        veterinarianDoctorMapping[_veterinarianDoctor] = _veterinarianDoctorID;
        emit veterinarianDoctorAddition(_veterinarianDoctor,_veterinarianDoctorID);
    }

    function addPuppyOwner(address _puppyOwner,string memory _puppyOwnerID) public onlyBroker(msg.sender) {
        isPuppyOwner[_puppyOwner] = true;
        puppyOwnerMapping[_puppyOwner] = _puppyOwnerID;
        emit litterOwnerAddition(_puppyOwner,_puppyOwnerID);
    }
    
    // function addPuppy(address memory _dogBreeder, uint memory _dameID, uint memory _sireID, uint memory _litterID, uint memory _litterSize, uint memory _birthDate, uint memory _puppyID) public onlyDogBreeder(msg.sender) {
    //     puppyMapping[_dogBreeder] = _dogBreeder; 
    //     puppyMapping[_dameID] = _dameID;
    //     puppyMapping[_sireID] = _sireID;
    //     puppyMapping[_litterID] = _litterID;
    //     puppyMapping[_litterSize] = _litterSize;
    //     puppyMapping[_birthDate] = _birthDate;
    //     puppyMapping[_puppyID] = _puppyID;
    //     emit newPuppyAddition(_dogBreeder,_puppyID);
    // }

    function addQualityReport(address _dogBreeder,address _veterinarianDoctor,string memory _litterID,string memory _remarks,uint256 _litterSize, uint256 _healthy) public onlyVeterinarianDoctor(msg.sender) {
        qualityReports[_dogBreeder][_litterID].veterinarianDoctor = _veterinarianDoctor;
        qualityReports[_dogBreeder][_litterID].remarks = _remarks;
        qualityReports[_dogBreeder][_litterID].healthy = _healthy;
        qualityReports[_dogBreeder][_litterID].litterSize = _litterSize;
    }

    function getQualityReport(address _dogBreeder,string memory _litterID) public view returns (
        string memory _remarks,
        address _veterinarianDoctor,
        uint256 _healthy,
        uint256 _litterSize
        ){
        _remarks = qualityReports[_dogBreeder][_litterID].remarks;
        _veterinarianDoctor = qualityReports[_dogBreeder][_litterID].veterinarianDoctor;
        _healthy = qualityReports[_dogBreeder][_litterID].healthy;
        _litterSize = qualityReports[_dogBreeder][_litterID].litterSize;
    }

    // function getlitterOwnerReport(address _litterOwner,address _dogBreeder,string memory _litterID) public view returns(
    //     string memory _remarks,
    //     string memory _receivedShipment
    //     ){
    //     _remarks = litterOwnerReports[_litterOwner][_dogBreeder][_litterID].remarks;
    //     _receivedShipment = litterOwnerReports[_litterOwner][_dogBreeder][_litterID].receivedShipment;
    // }

    // function BatchtoLot(string memory _dameID,string memory _litterID) public {
    //     lotToBatch[_dameID] = _litterID;
    // }

    // function addBrokerReport(address _broker, address _litterOwner, address _dogBreeder,
    //     string memory _remarks,
    //     string memory _dogBreed,
    //     string memory _dogName,
    //     string memory _birthDate,
    //     uint256 _litterSize,
    //     string memory _dameID,
    //     uint256 _puppyID
    // ) public {
    //     brokerReports[_broker][_dameID].dogName = _dogName;
    //     brokerReports[_broker][_dameID].remarks = _remarks;
    //     brokerReports[_broker][_dameID].dogBreed = _dogBreed;
    //     brokerReports[_broker][_dameID].birthDate = _birthDate;
    //     brokerReports[_broker][_dameID].litterSizeProduced = _litterSize;
    //     brokerReports[_broker][_dameID].processedReport = litterOwnerReports[_litterOwner][_dogBreeder][lotToBatch[_dameID]];
    //     brokerReports[_broker][_dameID].puppyID = _puppyID;
    // }

    // function getBrokerReport(address _broker,string memory _dameID) public view returns(
    //     string memory _dogName,
    //     string memory _remarks,
    //     string memory _dogBreed,
    //     string memory _birthDate,
    //     uint256 _litterSize
    //     ){
    //         _dogName = brokerReports[_broker][_dameID].dogName;
    //         _remarks = brokerReports[_broker][_dameID].remarks;
    //         _dogBreed = brokerReports[_broker][_dameID].dogBreed;
    //         _birthDate = brokerReports[_broker][_dameID].birthDate;
    //         _litterSize = brokerReports[_broker][_dameID].litterSizeProduced;
    //     }
   
}