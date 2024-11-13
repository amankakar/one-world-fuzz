## One world

**This Repo contain the Echidna based Fuzz test suite**

-   **Forge**: Fooundry based test cases can be found in `/test` dir.
-   **Echidna**: Echidna Based Fuzz test are added inside src dir. the `Setup.sol` file contain the setup code and `TestFactory.sol` contain test cases for various function of `MembershipFactory`.

### Run Test Suite

```shell
$ rm -rf corpus && rm -rf crytic-export && forge clean && forge build &&  echidna . --contract TestFactory  --config ./config.yaml
```

This Code Assumes that you already have echidna install and it is working fine.

