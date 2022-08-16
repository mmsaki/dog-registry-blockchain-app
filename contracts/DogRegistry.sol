// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.6;
contract DogRegistry {
    
    
    address payable public owner;
    uint totalamount =0;
    
    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
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
    struct brokerReport{
        string dogName; // Male Parent
        string dogBreed;
        string remarks;
        string birthDate;
        uint256 litterSizeProduced;
        litterOwnerReport processedReport;
    }
   
    // Maps address of respective Stakeholders to true
    mapping(address=>bool) isDogBreeder;
    mapping(address=>bool) isLitterOwner;
    mapping(address=>bool) isBroker;
    mapping(address=>bool) isVeterinarianDoctor;
   
    // Map Stakeholders address to ID
    mapping(address=>string) dogBreederMapping;
    mapping(address=>string) litterOwnerMapping;
    mapping(address=>string) brokerMapping;
    mapping(address=>string) veterinarianDoctorMapping;
   
    //Events
    event dogBreederAddition(address dogBreederAddress,string dogBreederID);
    event litterOwnerAddition(address litterOwnerAddress,string litterOwnerID);
    event brokerAddition(address brokerAddress,string brokerID);
    event veterinarianDoctorAddition(address inspectoAddress,string inspectoID);
    //Modifiers
    modifier onlyDogBreeder(address dogBreeder){
        require(isDogBreeder[dogBreeder]);
        _;
    }
    modifier onlyVeterinarianDoctor(address veterinarianDoctor){
        require(isDogBreeder[veterinarianDoctor]);
        _;
    }
    modifier onlyBroker(address broker){
        require(isBroker[broker]);
        _;
    }
    modifier onlyLitterOwner(address litterOwner){
        require(isLitterOwner[litterOwner]);
        _;
    }
    
    mapping(address=>mapping(string=>qualityReport)) qualityReports; // mapping of dogBreeders address to litterID and report
    mapping(address=>mapping(address => mapping(string=>litterOwnerReport))) litterOwnerReports;
    mapping(string => string) lotToBatch;
    mapping(address=>mapping(string=>brokerReport)) brokerReports;
   
    function addDogBreeder(address _dogBreeder,string memory _dogBreederID) public {
        isDogBreeder[_dogBreeder] = true;
        dogBreederMapping[_dogBreeder] = _dogBreederID;
        emit dogBreederAddition(_dogBreeder,_dogBreederID);
    }
    function addLitterOwner(address _litterOwner,string memory _litterOwnerID) public {
        isLitterOwner[_litterOwner] = true;
        litterOwnerMapping[_litterOwner] = _litterOwnerID;
        emit litterOwnerAddition(_litterOwner,_litterOwnerID);
    }
    function addVeterinarianDoctor(address _veterinarianDoctor,string memory _veterinarianDoctorID) public {
        isVeterinarianDoctor[_veterinarianDoctor] = true;
        veterinarianDoctorMapping[_veterinarianDoctor] = _veterinarianDoctorID;
        emit veterinarianDoctorAddition(_veterinarianDoctor,_veterinarianDoctorID);
    }
    function addBroker(address _broker,string memory _brokerID) public {
        isBroker[_broker] = true;
        brokerMapping[_broker] = _brokerID;
        emit brokerAddition(_broker,_brokerID);
    }
    function addQualityReport(address _dogBreeder,address _veterinarianDoctor,string memory _litterID,string memory _remarks,uint256 _litterSize, uint256 _healthy) public {
        qualityReports[_dogBreeder][_litterID].veterinarianDoctor = _veterinarianDoctor;
        qualityReports[_dogBreeder][_litterID].remarks = _remarks;
        qualityReports[_dogBreeder][_litterID].healthy = _healthy;
        qualityReports[_dogBreeder][_litterID].litterSize = _litterSize;
    }
    function getQualityReport(address _dogBreeder,string memory _litterID) public view returns(
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
    function addLitterReport(address _litterOwner,address _dogBreeder, string memory _litterID,string memory _remarks, string memory _receivedShipment) public {
        litterOwnerReports[_litterOwner][_dogBreeder][_litterID].remarks = _remarks;
        litterOwnerReports[_litterOwner][_dogBreeder][_litterID].receivedShipment = _receivedShipment;
        litterOwnerReports[_litterOwner][_dogBreeder][_litterID].qualityreport = qualityReports[_dogBreeder][_litterID];
    }
    function getLitterOwnerReport(address _litterOwner,address _dogBreeder,string memory _litterID) public view returns(
        string memory _remarks,
        string memory _receivedShipment
        ){
        _remarks = litterOwnerReports[_litterOwner][_dogBreeder][_litterID].remarks;
        _receivedShipment = litterOwnerReports[_litterOwner][_dogBreeder][_litterID].receivedShipment;
    }
    function BatchtoLot(string memory _dameID,string memory _litterID) public{
        lotToBatch[_dameID] = _litterID;
    }
    function addBrokerReport(address _broker, address _litterOwner, address _dogBreeder,
        string memory _remarks,
        string memory _dogBreed,
        string memory _dogName,
        string memory _birthDate,
        uint256 _litterSize,
        string memory _dameID
    ) public {
        brokerReports[_broker][_dameID].dogName = _dogName;
        brokerReports[_broker][_dameID].remarks = _remarks;
        brokerReports[_broker][_dameID].dogBreed = _dogBreed;
        brokerReports[_broker][_dameID].birthDate = _birthDate;
        brokerReports[_broker][_dameID].litterSizeProduced = _litterSize;
        brokerReports[_broker][_dameID].processedReport = litterOwnerReports[_litterOwner][_dogBreeder][lotToBatch[_dameID]];
    }
    function getBrokerReport(address _broker,string memory _dameID) public view returns(
        string memory _dogName,
        string memory _remarks,
        string memory _dogBreed,
        string memory _birthDate,
        uint256 _litterSize
        ){
            _dogName = brokerReports[_broker][_dameID].dogName;
            _remarks = brokerReports[_broker][_dameID].remarks;
            _dogBreed = brokerReports[_broker][_dameID].dogBreed;
            _birthDate = brokerReports[_broker][_dameID].birthDate;
            _litterSize = brokerReports[_broker][_dameID].litterSizeProduced;
        }
   
}