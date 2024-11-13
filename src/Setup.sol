// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {MembershipFactory} from "./dao/MembershipFactory.sol";
import {CurrencyManager} from "./dao/CurrencyManager.sol";

import {MembershipERC1155} from "./dao/tokens/MembershipERC1155.sol";

import {MockERC20} from "./MockERC20.sol";

import {DAOConfig, DAOInputConfig, TierConfig, DAOType, TIER_MAX} from "./dao/libraries/MembershipDAOStructs.sol";
contract User {
    function proxy(
        address target,
        bytes memory data
    ) public returns (bool succes, bytes memory error) {
        return target.call(data);
    }
}
contract Setup {
    MembershipFactory factory;
    CurrencyManager manager;
    MembershipERC1155 implementation;
    User user;
    bool isSetup;
    address newDao;
    string ensName;
    MockERC20 currency;
    address us = address(0x1234);

    constructor() public {
        manager = new CurrencyManager();
        implementation = new MembershipERC1155();
        factory = new MembershipFactory(
            address(manager),
            address(us),
            "url",
            address(implementation)
        );

        currency = new MockERC20();
        currency.approve(address(factory), type(uint256).max);
    }

    function _createNEwDaoMemeber(
        DAOInputConfig memory daoConfig,
        TierConfig[] memory tierConfigs
    ) internal {
        if (!isSetup) {
            // store name for testing
            ensName = daoConfig.ensname;
            daoConfig.currency = address(currency);
            manager.addCurrency(daoConfig.currency);
            newDao = factory.createNewDAOMembership(daoConfig, tierConfigs);
            assert(newDao != address(0));
            isSetup = true;
        }
    }

    function _updateDAOMembership(TierConfig[] memory tierConfigs) internal {
        factory.updateDAOMembership(ensName, tierConfigs);
    }

    function _joinDao(uint256 tierIndex) internal {
        if (isSetup) {
            factory.joinDAO(newDao, tierIndex);
        }
    }


function _upgradeTier(uint256 tierIndex) internal {
        if (isSetup) {
            factory.upgradeTier(newDao, tierIndex);
        }
    }


    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}
