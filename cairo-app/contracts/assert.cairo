%lang starknet

# Function that 
@external
func demo_assert(guess : felt) :
    const a = 7

    tempvar b
    # verifies if the guess is 7
    assert a = guess
    # assigns 5 to variable b
    assert b = 5
    # verifies if the guess is 5
    assert b = guess

    return ()
end
