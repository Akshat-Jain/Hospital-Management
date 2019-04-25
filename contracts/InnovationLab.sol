pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;
contract InnovationLab {
    
    constructor() payable public {
        
    }
    
    struct Doctor {
        string doctorName;
        string doctorDoB;
        string doctorId;
    }
    
    struct Patient {
        string patientName;
        string patientDoB;
        string patientId;
    }
    
    struct medicalRecord {
        string prescription;
        string diagnosis;
        string[] medicines;
        uint[] quantity;
    }
    
    mapping (address => uint) character;
    mapping (address => Doctor) doctors_details;
    mapping (address => Patient) patients_details;
    mapping (string => string) idCheck; // aadhaar => dob
    mapping (string => medicalRecord[]) medical_records; //aadhaar
    
    modifier doctorOnly(){
        require(character[msg.sender]==1);
        _;
    }
    
    modifier patientOnly(){
        require(character[msg.sender]==2);
        _;
    }
    
    function hash(string memory _x) internal pure returns(bytes32) {
        return keccak256(abi.encodePacked(_x));
    }
    
    function doctorFirstLogin(string memory _x, Doctor memory y) public {
        require(hash(_x)==hash("Doctor"));
        require(character[msg.sender]==0);
        character[msg.sender] = 1;
        idCheck[y.doctorId] = y.doctorDoB;
        doctors_details[msg.sender] = y;
    }
    
    function patientFirstLogin(string memory _x, Patient memory y) public {
        require(hash(_x)==hash("Patient"));
        require(character[msg.sender]==0);
        character[msg.sender] = 2;
        idCheck[y.patientId] = y.patientDoB;
        patients_details[msg.sender] = y;
    }
    
    
    function readPatientDetails() public view patientOnly returns(Patient memory) {
        return patients_details[msg.sender];
    }
    
    function readDoctorDetails() public view doctorOnly returns(Doctor memory) {
        return doctors_details[msg.sender];
    }
    
    function readMedicalRecord(string memory _patientDoB, string memory _patientId) public view returns(medicalRecord[] memory) {
        if(character[msg.sender]==1){
            require(hash(idCheck[_patientId]) == hash(_patientDoB));
            return medical_records[_patientId];
        }
        else if(character[msg.sender]==2){
            require(hash(patients_details[msg.sender].patientId) == hash(_patientId));
            require(hash(patients_details[msg.sender].patientDoB) == hash(_patientDoB));
            return medical_records[_patientId];
        }
    }
    
    function writeMedicalRecord(string memory _patientDoB, string memory _patientId, medicalRecord memory y) doctorOnly public {
        require(hash(idCheck[_patientId]) == hash(_patientDoB));
        medical_records[_patientId].push(y);
    }

    // testInstance.set(23,{from:'0xddfc6d4c689a1d0e9322106234d3eba016bcd9c6'})
    // value = await testInstance.get.call({from:accounts[0]})
    // undefined
    // truffle(development)> value
    // <BN: 17>
    // truffle(development)> value.toNumber()

    // Our case
    // truffle develop
    // compile
    // migrate -reset
    // let instance = await InnovationLab.deployed()
    // let accounts = await web3.eth.getAccounts()
    // instance.doctorFirstLogin("Doctor",["dName1","dDob1","dId1"],{from:accounts[0]})
    // instance.readDoctorDetails(accounts[0],{from:accounts[0]})
    // instance.patientFirstLogin("Patient",["pName1","pDob1","pId1"],{from:accounts[1]})
    // instance.readPatientDetails(accounts[1],{from:accounts[1]})
    // instance.writeMedicalRecord("pDob1","pId1",["prescription1","diagnosis1",["med1","med2"],[10,20]],{from:accounts[0]})
    // instance.readMedicalRecord("pDob1","pId1",{from:accounts[0]})
    // instance.readMedicalRecord("pDob1","pId1",{from:accounts[1]})
    // instance.writeMedicalRecord("pDob1","pId1",["prescription2","diagnosis2",["med1","med2"],[15,25]],{from:accounts[0]})
    // instance.readMedicalRecord("pDob1","pId1",{from:accounts[1]})



}