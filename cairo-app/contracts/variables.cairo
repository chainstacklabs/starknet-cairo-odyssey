%lang starknet

# persistent state variable
@storage_var
func storage_variable() -> (res : felt):
end

func variable_examples{}():
  # required to use local variables
  alloc_locals

  # creating alias by value
  let a = 5
  let b = 3

  # creating alias by reference. x value is 5
  let x = a

  # constant, can not be re assigned
  const ten = 10

  # res is 15 here, 5 * 3
  tempvar res = a * b

  # local varible. c is 15
  local c = ten + a

  # re-assign aliased variable
  let b = 2

  # re-assign tempvar. res is 10 here, 5 * 2
  tempvar res = a * b

  return ()

end
