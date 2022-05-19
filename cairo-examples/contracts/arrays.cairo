%lang starknet
%builtins range_check

# import to use alloc
from starkware.cairo.common.alloc import alloc

from starkware.cairo.common.cairo_builtins import HashBuiltin


# view function that returns a felt and
# has range_check_ptr as an implicid argument
@view
func array_read{range_check_ptr}(index : felt) -> (value : felt):
    # Creates a pointer to the start of an array.
    let (my_array : felt*) = alloc()

    # sets 1 as the value of the first element of the array
    assert [my_array] = 1
    # sets 2 as the value of the second element of the arrat
    assert [my_array + 1] = 2
   assert [my_array + 2] = 3
   assert [my_array + 3] = 4
   assert [my_array + 4] = 5
   assert [my_array + 5] = 6
   assert [my_array + 6] = 7
   assert [my_array + 7] = 8
   assert [my_array + 8] = 9
   assert [my_array + 9] = 10
   assert [my_array + 15] = 16
   

    # reads the array at the selected index.
    let val = my_array[index]
    return (val)
end


# Function that receives an array as parameter
@external
func array_play{syscall_ptr : felt*,range_check_ptr
    }(array_param_len : felt, array_param : felt*) -> (res: felt):
    # read first element of the array
    let first = array_param[0]
    # read last element of the array
    let last = array_param[array_param_len - 1]

    let res = first + last

    return (res)
end
