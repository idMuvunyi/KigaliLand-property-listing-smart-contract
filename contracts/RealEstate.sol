pragma solidity ^0.8.4;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract RealEstate{
    // use method from library
    using SafeMath for uint256;

struct Property {
    uint256 price;
    address owner;
    string name;
    string description;
    string location;
    bool forSale;
}
// keep track of each property here (by Id)
mapping(uint256 => Property) public properties;

// unique ID for parcel of land
uint256[] public propertyIds;

// Create event to listen to every property sold
event PropertySold(uint256, propertyId);

// list the whole available properties for sale
function propertyListing(uint256 _propertyId, uint256 _price, string memory _name, string memory _description, string memory _location) public {

// update the entire struct with new vales provided by user on interface
Property memory newProperty = Property({
    price: _price,
    owner: msg.sender,
    name:_name,
    description:_description,
    location:_location,
    forSale: true
});

// update the property 
properties[_propertyId] = newProperty;
propertyIds.push(_propertyId);

}

// build funtionanality to buy one or more of the listed properties
function buyProperty(uint256 _propertyId) public payable{

    Property storage property = properties[_propertyId];

    // do some checks on property id requested by the buyer
    require(property.forSale, "Property is not for sale");
    require(property.price <= msg.value, "Your fund is not sufficient to buy this property");

    // else : buy the property
    property.owner = msg.sender;
    property.forSale = false;

    // then : send fund to the seller of the property
    payable(property.owner).transfer(property.price);

    // trigger the event to record this event happened
    emit PropertySold(_propertyId);

} 

}