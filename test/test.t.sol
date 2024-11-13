// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {MembershipFactory} from "../src/dao/MembershipFactory.sol";
import {CurrencyManager} from "../src/dao/CurrencyManager.sol";

import {MembershipERC1155} from "../src/dao/tokens/MembershipERC1155.sol";

import {DAOConfig, DAOInputConfig, TierConfig, DAOType, TIER_MAX} from "../src/dao/libraries/MembershipDAOStructs.sol";

import {MockERC20} from "../src/MockERC20.sol";

import "forge-std/Test.sol";

contract TestFactory is Test {
    MembershipFactory factory;
    CurrencyManager manager;
    MembershipERC1155 implementation;
    bool isSetup;
    address newDao;
    string ensName;
    uint256 maxMemeber;

    MockERC20 currency;

    function setUp() public {
        manager = new CurrencyManager();
        implementation = new MembershipERC1155();
        factory = new MembershipFactory(
            address(manager),
            address(this),
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
        // store name for testing
        ensName = daoConfig.ensname;
        daoConfig.currency = address(currency);
        manager.addCurrency(daoConfig.currency);
        newDao = factory.createNewDAOMembership(daoConfig, tierConfigs);
    }

    function _updateDAOMembership(TierConfig[] memory tierConfigs) internal {
        factory.updateDAOMembership(ensName, tierConfigs);
    }

    function _prepareData()
        internal
        returns (DAOInputConfig memory, TierConfig[] memory)
    {
        DAOInputConfig memory daoConfig = DAOInputConfig({
            ensname: "testdao.eth",
            currency: address(this),
            maxMembers: 100,
            noOfTiers: 2,
            daoType: DAOType.PUBLIC // Assuming 0 represents a specific DAO type for testing
        });
        maxMemeber = daoConfig.maxMembers;

        // Assuming TierConfig is already defined somewhere in your contract
        TierConfig[] memory tierConfigs = new TierConfig[](2);
        tierConfigs[0] = TierConfig({
            amount: 50,
            minted: 0,
            price: 200000000,
            power: 0
        });
        tierConfigs[1] = TierConfig({
            amount: 50,
            minted: 0,
            price: 200000000,
            power: 0
        });
        return (daoConfig, tierConfigs);
    }

    function _prepareTire() internal view returns (TierConfig[] memory) {
        TierConfig[] memory tierConfigs = new TierConfig[](1);

        tierConfigs[0] = TierConfig({
            amount: 50,
            minted: 5,
            price: 200000000,
            power: 0
        });
        return tierConfigs;
    }
    function _newDaoStored() internal view {
        address _newDao = factory.userCreatedDAOs(address(this), ensName);
        assert(newDao == _newDao);
    }

    //     function _joinDao(uint256 tierIndex) internal{
    //     factory.joinDAO(newDao , tierIndex);
    //     // }
    // }

    function test_deploy() public {
        (
            DAOInputConfig memory daoConfig,
            TierConfig[] memory tierConfigs
        ) = _prepareData();
        _createNEwDaoMemeber(daoConfig, tierConfigs);
        _newDaoStored();
        tierConfigs = _prepareTire();
        _updateDAOMembership(tierConfigs);
    }

    function test_MaxMember() public {
        test_deploy();
        (
            ,
            DAOType daoType,
            address currency,
            uint256 maxMembers,
            uint256 noOfTiers
        ) = factory.daos(newDao);
        console.log("maxMember", maxMembers);
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
