# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin


@storage_var
func message_storage() -> (res: felt):
end


@external 
func update_message{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(new_message: felt):
    message_storage.write(new_message)
    return ()
end

@view
func read_message{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: felt):
    let (res) = message_storage.read()
    return (res)
end
