pragma solidity ^0.5.0;

contract WorldRecord {

    struct Country {
        string name;
        string leader;
        uint population;
    }
    
    Country[] public countries;

    uint public totalCountries;

    constructor() public {
        totalCountries = 0;
    }

    event CountryEvent(string countryName, string leader, uint population);
    event LeaderUpdated(string countryName, string leader);
    event CountryDelete(string countryName);

    function insert(string countryName, string leader, uint population) public returns (uint totalCountries) {
        Country memory newCountry = Country(countryName, leader, population);
        countries.push(newCountry);
        totalCountries++;
        //emit event
        emit CountryEvent(countryName, leader, population);
        return totalCountries;
    }

    function updateLeader(string countryName, string newLeader) public returns (bool success) {
        //This has a problem we need loop
        for(uint i - 0; i < totalCountries; i++){
            if(compareStrings(countries[i].name, countryName)){
                countries[i].leader = newLeader;
                emit LeaderUpdated(countryName, newLeader);
                return true;
            }
        }
        return false;
    }

    function deleteCountry(string countryName) public returns (bool success){
        require(totalCountries > 0);
        for(uint i = 0; i < totalCountries; i++){
            if(compareStrings(countries[i].name, countryName)){
                //pushing last into current array index which we're deleting
                countries[i] = countries[totalCountries-1];
                //delete last index
                delete countries[totalCountries-1];
                //total count decrease
                totalCountries--;
                //array length decrease
                countries.length--;
                //emit event
                CountryDelete(countryName);
                return true;
            }
        }
        return false;
    }

    function getCountry(string countryName) public view returns (string name, string leader, uint population){
        for(uint i = 0; i < totalCountries; i++){
            if(compareStrings(countries[i].name, countryName)){
                //emit event
                return (countries[i].name, countries[i].leader, countries[i].population);
            }
        }
        revert('country not found');
    }

    function compareStrings(string a, string b) internal pure returns (bool){
        return keccak256(a) == keccak256(b);
    }

    function getTotalCountries() public view returns (uint length){
        return countries.length;
    }
}