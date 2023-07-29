//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

interface ERC1155 {
    
    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );

    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    event URI(
        string _value,
        uint256 indexed _id
    );

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;

    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}

interface ERC165 {

    function supportsInterface(bytes4 interfaceID) external pure returns (bool);

}

interface ERC1155TokenReceiver {

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns (bytes4);

    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns (bytes4);
}

interface ERC1155Metadata_URI {

    function uri(uint256 _id) external view returns (string memory);

}

contract MultiToken is ERC1155, ERC165, ERC1155Metadata_URI {

    // Contract Owner
    address payable private _contractOwner;
    
    // Multi-Token Identifiers (MTI): one identifier for each diferent token
    uint256 private constant MTI_1 = 0;
    uint256 private constant MTI_2 = 1;
    uint256 private constant MTI_3 = 2;

    // Supply control
    uint256[] public currentSupply = [50, 50, 50];

    // Token price
    uint256 public tokenPrice = 0.01 ether;

    // Balance control
    mapping(uint256 => mapping(address => uint256)) private _balances; // tokenId => (tokenOwner => balance)

    // Approval control
    mapping(address => mapping(address => bool)) private _approvals; // tokenOwner => (operator => isApproved)


    // CONTRACT FUNCTIONS ====================================================================================

    constructor() {
        _contractOwner = payable(msg.sender);
    }

    function mint(uint _id) external payable {
        
        require(_id < 3, "This token does not exists");
        require(currentSupply[_id] > 0, "Max supply reached");
        require(msg.value >= tokenPrice, "Insufficient payment");

        _balances[_id][msg.sender] += 1;
        currentSupply[_id] -= 1;

        emit TransferSingle(msg.sender, address(0), msg.sender, _id, 1);

        require(
            msg.sender.code.length == 0
            || ERC1155TokenReceiver(msg.sender).onERC1155Received(msg.sender, address(0), _id, 1, "")
                == ERC1155TokenReceiver.onERC1155Received.selector,
            "Unsafe recipient"
        );
    }

    function burn(address _from, uint _id) public {

        require(_from != address(0), "Invalid wallet address");
        require(_id < 3, "This token does not exists");
        require(_isApprovedOrOwner(_from, msg.sender), "Not authorized");
        require(_balances[_id][_from] > 0, "Insufficient balance");

        _balances[_id][_from] -= 1;

        emit TransferSingle(msg.sender, _from, address(0), _id, 1);
    }

    function _balanceOf(address _owner, uint256 _id) private view returns (uint256) {

        require(_id < 3, "This token does not exists");
        require(_owner != address(0), "Invalid wallet address");

        return _balances[_id][_owner];
    }

    function _isApprovedOrOwner(address _owner, address _spender) private view returns (bool) {
        return _owner == _spender || _approvals[_owner][_spender];
    }

    function _addressesVerifications(address _from, address _to) private view returns (bool) {
        
        require(_from != address(0) && _from != _to, "Invalid From address");
        require(_to != address(0), "Invalid To address");
        require(_isApprovedOrOwner(_from, msg.sender), "Not authorized");
        
        return true;
    }

    function _transfer(address _from, address _to, uint256 _id, uint256 _value) private returns (bool) {

        require(_id < 3, "This token does not exists");
        require(_value > 0, "Invalid value");
        require(_balances[_id][_from] >= _value, "Insufficient balance");

        _balances[_id][_from] -= _value;
        _balances[_id][_to] += _value;

        return true;
    }

    function withdraw() external {

        require(msg.sender == _contractOwner, "You do not have permission");

        uint256 amount = address(this).balance;
        (bool success,) = _contractOwner.call{value: amount}("");

        require(success == true, "Failed to withdraw");
    }

    // ERC1155 Implementation

    function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
        return _balanceOf(_owner, _id);
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
        
        require(_owners.length == _ids.length, "Owners x Ids length mismatch");

        uint256[] memory results = new uint256[](_owners.length);
        for (uint256 i = 0; i < _owners.length; i++) {
            results[i] = _balanceOf(_owners[i], _ids[i]);
        }

        return results;
    }
    
    function setApprovalForAll(address _operator, bool _approved) external {
        
        require(_operator != address(0), "Invalid operator address");

        _approvals[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {

        require(_owner != address(0), "Invalid owner address");
        require(_operator != address(0), "Invalid operator address");

        return _approvals[_owner][_operator];
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {

        _addressesVerifications(_from, _to);
        _transfer(_from, _to, _id, _value);

        emit TransferSingle(msg.sender, _from, _to, _id, _value);

        require(
            _to.code.length == 0
            || ERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _value, _data)
                == ERC1155TokenReceiver.onERC1155Received.selector,
            "Unsafe recipient"
        );
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {

        require(_ids.length == _values.length, "Ids x Values length mismatch");

        _addressesVerifications(_from, _to);

        for (uint256 i = 0; i < _ids.length; i++) {
            _transfer(_from, _to, _ids[i], _values[i]);
        }

        emit TransferBatch(msg.sender, _from, _to, _ids, _values);

        require(
            _to.code.length == 0
            || ERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _values, _data)
                == ERC1155TokenReceiver.onERC1155BatchReceived.selector,
            "Unsafe recipient"
        );
    }

    // ERC165 Implementation

    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return
            interfaceID == 0xd9b67a26       //ERC-1155
            || interfaceID == 0x0e89341c    //ERC-1155 Metadata URI
            || interfaceID == 0x01ffc9a7;   //ERC-165
    }

    // ERC1155Metadata_URI Implementation

    function uri(uint256 _id) external pure returns (string memory) {

        require(_id < 3, "This token does not exists");

        return string.concat("ipfs://hashaddresstoyoururi/", Strings.toString(_id),".json");
    }
}
