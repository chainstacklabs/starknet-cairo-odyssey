# Declare this file as a StarkNet contract.
%lang starknet

from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func user_numbers(address: felt) -> (num: felt):
end

@external
func save_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(n: felt):
    alloc_locals
    let (sender_address) = get_caller_address()

    user_numbers.write(sender_address, n)
    return ()
end

@view
func get_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: felt):
    let (sender_address) = get_caller_address()
    
    let (res) = user_numbers.read(sender_address)

    return (res)
end
