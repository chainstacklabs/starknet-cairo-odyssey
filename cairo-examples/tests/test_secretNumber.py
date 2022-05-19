"""contract.cairo test file."""
import os

import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "secretNumber.cairo")



# Enables modules.
@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

# Reusable to save testing time.
@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/secretNumber.cairo")
    return starknet, contract


@pytest.mark.asyncio
async def test_saveNumber(contract_factory):
  # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet, contract = contract_factory

    # save number for user
    await contract.save_number(99).invoke()
    # retrieve number
    number = await contract.get_number().call()
    print(number)
    assert number.result.res == 99

     # save number for user
    await contract.save_number(33).invoke()

    # retrieve number
    number = await contract.get_number().call()
    print(number)
    assert number.result.res == 33



    
