# Declare this file as a StarkNet contract.
%lang starknet

from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Account struct
struct Account:
    member isOpen: felt
    member balance: felt
end


# Mapping named accounts_storage that holds the account details for each user using his address
@storage_var
func accounts_storage(address: felt) -> (account: Account):
end


# Keeps a counter of the number of accounts 
@storage_var
func number_of_accounts() -> (res: felt):
end



# Returns the user's account
@view
func get_account{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: Account):
    let (sender_address) = get_caller_address()
    let (res) = accounts_storage.read(sender_address)

    return (res)
end

@view
func accounts_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: felt):
    let (res) = number_of_accounts.read()

    # assert res > 0
    return (res)
end

# Creates an account for the user
@external
func open_account{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (sender_address) = get_caller_address()
    # checks if the user already has an account
    let (user_account) = accounts_storage.read(sender_address)
    assert user_account.isOpen = 0
    let (n_accs) = number_of_accounts.read()

    accounts_storage.write(sender_address, Account(isOpen=1, balance=0))
    number_of_accounts.write(n_accs + 1)
    return ()
end

@external
func deposit_funds{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(amount: felt):
let (sender_address) = get_caller_address()
    # checks if the user already has an account
    let (user_account) = accounts_storage.read(sender_address)
    assert user_account.isOpen = 1


end
