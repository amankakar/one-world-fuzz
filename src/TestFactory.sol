// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Setup} from "./Setup.sol";
import {DAOConfig, DAOInputConfig, TierConfig, DAOType, TIER_MAX} from "./dao/libraries/MembershipDAOStructs.sol";
import {IMembershipERC1155} from "./dao/interfaces/IERC1155Mintable.sol";
import {MembershipERC1155} from "./dao/tokens/MembershipERC1155.sol";
contract TestFactory is Setup {
    uint256 maxMemeber;
    bool isMinted;
    // call
    function createNEwDaoMemeber() public {
        // if(daoConfig.maxMembers > 10) return;
        DAOInputConfig memory daoConfig = DAOInputConfig({
            ensname: "testdao.eth",
            currency: address(this),
            maxMembers: 150,
            noOfTiers: 3,
            daoType: DAOType.SPONSORED // Assuming 0 represents a specific DAO type for testing
        });
        maxMemeber = daoConfig.maxMembers;

        // Assuming TierConfig is already defined somewhere in your contract
        TierConfig[] memory tierConfigs = new TierConfig[](3);
        tierConfigs[0] = TierConfig({
            amount: 50,
            minted: 0,
            price: 1,
            power: 0
        });
        tierConfigs[1] = TierConfig({
            amount: 50,
            minted: 0,
            price: 1,
            power: 0
        });
        tierConfigs[2] = TierConfig({
            amount: 50,
            minted: 0,
            price: 1,
            power: 0
        });

        _createNEwDaoMemeber(daoConfig, tierConfigs);
        testNewDaoStored();
    }

    function testNewDaoStored() public view {
        if (isSetup) {
            address _newDao = factory.userCreatedDAOs(address(this), ensName);
            require(_newDao != address(0));
            test_maxMemberWill_neverIncrease();
        }
    }

    function updateDaoMemeberShip(TierConfig[] memory tierConfigs) public {
        if(tierConfigs.length <= 3){
        (, , , uint256 _maxMemebers, ) = factory.daos(newDao);
        maxMemeber = _maxMemebers;
        for (uint i = 0; i < tierConfigs.length; i++) {
            tierConfigs[i].price = i + 2;
        }
        _updateDAOMembership(tierConfigs);
        }
    }

    function test_maxMemberWill_neverIncrease() public view {
        (, , , uint256 _maxMemebers, ) = factory.daos(newDao);
        assert(_maxMemebers >= maxMemeber);
    }

    function test_JoinDao() public {
        if (isSetup) {
            (
                ,
                DAOType daoType,
                address _currency,
                uint256 maxMembers,
                uint256 noOfTiers
            ) = factory.daos(newDao);
            assert(_currency == address(currency));
            currency.approve(address(factory), type(uint256).max);
            _joinDao(noOfTiers - 1);
            uint256 bal = MembershipERC1155(newDao).balanceOf(
                address(this),
                noOfTiers - 1
            );
            assert(bal >= 1);
            isMinted=true;
        }
    }

    function test_upgradeTier() public {
        if(isMinted){
            (
                ,
                DAOType daoType,
                address _currency,
                uint256 maxMembers,
                uint256 noOfTiers
            ) = factory.daos(newDao);
                uint256 bal = MembershipERC1155(newDao).balanceOf(
                address(this),
                noOfTiers - 1
            );
            if(bal >0){
            _upgradeTier(noOfTiers-1);

                uint256 bal1 = MembershipERC1155(newDao).balanceOf(
                address(this),
                noOfTiers-1-1
            );
            assert(bal1 >= 1);


            }
        }
    }
}
