// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProtocol {
    function getInterestRate(address token) external view returns (uint256);
}

contract Project {
    address public owner;
    mapping(string => address) public protocols;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function registerProtocol(string memory name, address protocolAddress) external onlyOwner {
        protocols[name] = protocolAddress;
    }

    function getBestRate(address token, string[] memory protocolNames) external view returns (string memory bestProtocol, uint256 bestRate) {
        bestRate = 0;
        bestProtocol = "";

        for (uint256 i = 0; i < protocolNames.length; i++) {
            address protocolAddr = protocols[protocolNames[i]];
            if (protocolAddr != address(0)) {
                uint256 rate = IProtocol(protocolAddr).getInterestRate(token);
                if (rate > bestRate) {
                    bestRate = rate;
                    bestProtocol = protocolNames[i];
                }
            }
        }
    }

    function getProtocolRate(address token, string memory protocolName) external view returns (uint256) {
        address protocolAddr = protocols[protocolName];
        require(protocolAddr != address(0), "Protocol not registered");
        return IProtocol(protocolAddr).getInterestRate(token);
    }
}

