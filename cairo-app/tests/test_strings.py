"""contract.cairo test file."""
import os

import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "strings.cairo")



# Enables modules.
@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

# Reusable to save testing time.
@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/strings.cairo")
    return starknet, contract


@pytest.mark.asyncio
async def test_updateMessage(contract_factory):
  # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet, contract = contract_factory

    await contract.update_message(new_message=55).invoke()
    response = await contract.read_message().call()
    print(response.result)
    assert response.result == 55
