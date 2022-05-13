"""contract.cairo test file."""
import os

import pytest
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "structs-mappings.cairo")


# The testing library uses python's asyncio. So the following
# decorator and the ``async`` keyword are needed.
@pytest.mark.asyncio
async def test_save__player_stats():
    """Test increase_balance method."""
    # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet = await Starknet.empty()

    # Deploy the contract.
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    # Invoke save_player_stats() 
    await contract.save_player_stats(player_number=10, points=33, rebounds=3, assists=5).invoke()

    statsTx = await contract.get_player_stats(player_number=10).call()
    print(statsTx)
    # Check the result 
    assert statsTx.result.res == (33, 5, 3)
