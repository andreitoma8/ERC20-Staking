from brownie import MyStakeableToken, accounts, config


def main():
    account = accounts.add(config["wallets"]["from_key"])
    my_token = MyStakeableToken.deploy(
        "MyStakeableToken", "MST", {"from": account}, publish_source=True
    )
