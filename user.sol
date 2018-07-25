// solidity compiler version
// use solidity --version
// https://solidity.readthedocs.io/en/v0.4.24/layout-of-source-files.html#version-pragma
pragma solidity ^0.4.21;

// import library file  
// https://solidity.readthedocs.io/en/v0.4.24/layout-of-source-files.html#importing-other-source-files
// we should use libraries for common utility functions
//  source https://github.com/ethereum/dapp-bin/tree/master/library
// Library only compiled once and used again and again
import "stringUtils.sol";


contract userRecords {

    // enum type variable to store user gender
    enum genderType { male, female }
    // Actual user object which we will store
    // This similar to model/schema file in our Restful-app-backend 
    struct user{
        string name;
        genderType gender;
    }
    
    // user object
    // you can also declare it public to access it from outside contract
    // https://solidity.readthedocs.io/en/v0.4.24/contracts.html#visibility-and-getters
    user user_obj;
    // Internal function to conver genderType enum from string
    function getGenderFromString(string gender) internal returns (genderType) {
        if(StringUtils.equal(gender, "male")) {
            return genderType.male;
        } else {
            return genderType.female;
        }
    }
    // Internal function to conver genderType enum to string
    function getGenderToString(genderType gender) internal returns (string) {
        if(gender == genderType.male) {
            return "male";
        } else {
            return "female";
        }
    }

    // set user public function 
    // This is similar to persisting object in db.
    function setUser(string name, string gender) public {
        genderType gender_type = getGenderFromString(gender);
        user_obj = user({
            name:name, gender: gender_type
        });
    }

    // get user public function 
    // This is similar to getting object from db.
    function getUser() public returns (string, string) {
        return (
            user_obj.name, getGenderToString(user_obj.gender)
        );
    }
}
