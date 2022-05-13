%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# state variable
@storage_var
func number_storage() -> (n: felt):
end

# function that updates the state
@external
func update_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(n: felt):
    number_storage.write(n)
    return ()
end

# function to read the state
@view
func check_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: felt):
    let (res) = number_storage.read()
    return (res)
end
