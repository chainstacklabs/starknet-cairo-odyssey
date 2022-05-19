"""contract.cairo test file."""
import os

import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "miniBank.cairo")



# Enables modules.
@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

# Reusable to save testing time.
@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/miniBank.cairo")
    return starknet, contract


@pytest.mark.asyncio
async def test_createAccount(contract_factory):
  # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet, contract = contract_factory

    # opens account for user
    await contract.open_account().invoke()

    accounts_open = await contract.accounts_open().call()
    print(accounts_open)
    assert accounts_open.result.res == 1

    
