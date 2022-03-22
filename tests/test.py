from brownie import MyStakeableToken, accounts, chain

DECIMALS = 10 ** 18
HOUR_IN_SECONDS = 3600
HOURS_TO_PASS = 100
SECONDS_TO_PASS = HOURS_TO_PASS * HOUR_IN_SECONDS


def test_main():
    owner = accounts[0]
    token = MyStakeableToken.deploy("MyToken", "MT", {"from": owner})
    # Assert deposit balance
    stake_tx_1 = token.deposit(100000 * DECIMALS, {"from": owner})
    dep_info_1 = token.getDepositInfo(owner, {"from": owner})
    assert dep_info_1[0] == 100000 * DECIMALS
    # Assert rewards accumulation in time
    chain.mine(blocks=100, timedelta=SECONDS_TO_PASS)
    dep_info_2 = token.getDepositInfo(owner, {"from": owner})
    assert dep_info_2[1] == (dep_info_1[0] * 285 / 10000000) * HOURS_TO_PASS
    # Assert restake rewards
    restake_tx = token.stakeRewards({"from": owner})
    dep_info_3 = token.getDepositInfo(owner, {"from": owner})
    new_correct_balance = dep_info_2[0] + dep_info_2[1]
    assert dep_info_3[0] == new_correct_balance
    # Asserd rewards accumulation in time after rewards redelegation
    chain.mine(blocks=100, timedelta=SECONDS_TO_PASS)
    dep_info_4 = token.getDepositInfo(owner, {"from": owner})
    assert dep_info_4[1] == (dep_info_3[0] * 285 / 10000000) * HOURS_TO_PASS
    # Assert withdraw rewards
    balance_1 = token.balanceOf(owner, {"from": owner})
    claim_rewards_tx = token.claimRewards({"from": owner})
    balance_2 = token.balanceOf(owner, {"from": owner})
    assert balance_1 + dep_info_4[1] == balance_2
    # Assert withdraw all
    chain.mine(blocks=100, timedelta=SECONDS_TO_PASS)
    dep_info_5 = token.getDepositInfo(owner, {"from": owner})
    withdraw_all_tx = token.withdrawAll({"from": owner})
    dep_info_6 = token.getDepositInfo(owner, {"from": owner})
    assert dep_info_6[0] == 0 and dep_info_6[1] == 0
    balance_3 = token.balanceOf(owner, {"from": owner})
    assert balance_3 == balance_2 + dep_info_5[0] + dep_info_5[1]
