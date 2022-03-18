from brownie import MyToken, accounts, config


def main():
    account = accounts.add(config["wallets"]["from_key"])
    my_token = MyToken.deploy(
        "MyStakeableToken", "MST", {"from": account}, publish_source=True
    )
