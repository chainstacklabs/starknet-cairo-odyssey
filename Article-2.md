This is part two of the StarkNet odyssey series in which I explore the StarkNet L2 protocol. Make sure to [check part one of this series]() to get an overview of the protocol, understand what ZK-Proofs are and learn about all the different tools you need to start developing on StarkNet.

After we have installed all the dependencies, Cairo and Nile, we can bootstrap a new project with `nile init`. This will create a contract example and a test file.

## Smart contracts and programs with Cairo

Cairo is... well, Cairo is hell. The learning curve is super steep but every step is super rewarding.

CAIRO IS HELL IMAGE

## Cairo must known

### Contract structure

Contracts in Cairo have a similar structure to contracts writen in Solidity.

```php
# Declare this file as a StarkNet contract.
%lang starknet

# Imports
from starkware.cairo.common.cairo_builtins import HashBuiltin

# State variables, structs, etc

# Account struct
struct Account:
    member isOpen: felt
    member balance: felt
end

# Keeps a counter of the number of accounts
@storage_var
func number_of_accounts() -> (res: felt):
end

# Contract methods

# view function that returns the number of accounts from the storage variable
@view
func accountsOpen{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: felt):
    let (res) = number_of_accounts.read()
    return (res)
end

```

### WTF is felt?

`felt` stands for Field Element is the default data type in Cairo. In simple terms, it's used for integers with up to 76 decimals but it's also used store addresses.

### Strings

**Currently, Cairo does not support strings.** It supports, however, short strings of up to 31 characters stored in `felt`.

```php
[message] = 'hello!'
```

### Storage variables: read and write

Contract state variables are called storage variables in Cairo. To define them, we need to use the `@storage_var` decorator and declare them as functions as follows:

```php
# Keeps a counter of the number of accounts
@storage_var
func number_of_accounts() -> (res: felt):
end

```

In order to read and write to storage variables, we need to use the `read` and `write` methods, making sure that the data type that we pass matches with the data type defined in the storage variable:

```php
# Keeps a counter of the number of accounts
@storage_var
func number_of_accounts() -> (res: felt):
end


# Creates an account for the user
@external
func readWriteAccounts{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():

    // read number of accounts from storage
    let (n_accs) = number_of_accounts.read()

    // writes number of accounts in storage
    number_of_accounts.write(n_accs + 1)
    return ()
end

```

### Declaring variables

Variables can be aliased, using the `let` keyword, or evaluated, using the `const`, `local` or `tempvar` keywords.

- `const` used for constants, can not be re-assigned.
- `local` used for local variables. Can not be re-assigned and require adding `allow_locals` to the function
- `tempvar` used for temporary variables. They can be re-assigned.
- `let` used to create alias by value or by reference to another variables. Can be re-assigned.

Here are some examples of how to use them:

```php
%lang starknet

# persistent state variable
@storage_var
func storage_variable() -> (res : felt):
end

func variable_examples{}():
  // required to use local variables
  allow_locals

  // creating alias by value
  let a = 5
  let b = 3

  // creating alias by reference. x value is 5
  let x = a


  // constant, can not be re assigned
  const ten = 10

  // res is 15 here, 5 * 3
  tempvar res = a * b

  //local varible. c is 15
  local c = ten + a

  // re-assign aliased variable
  let b = 2

  // re-assign tempvar. res is 10 here, 5 * 2
  tempvar res = a * b

end
```

Notice that in order to re-assign a variable, you have to indicate the variable type (`tempvar`, `let`).

### Structs and Mappings

Structs are very similar to Solidity, we just have to define them with the `struct` keyword and define all its attributes:

```php
# Account struct
struct Account:
    member isOpen: felt
    member balance: felt
end

```

Mappings are also very similar:

```php
# Mapping named accounts_storage that holds the account details for
# each user using his address as key
@storage_var
func accounts_storage(address: felt) -> (account: Account):
end
```

### arrays, how to create one and return it

### Contract functions

Cairo contract functions are declared with the `@external` or `@view` decorators. External functions can be called by users or by other contracts while view functions are similar but they only query the contract state and do not alter it.

```php
# view function that returns the number of accounts from the storage variable
@view
func accountsOpen{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res: felt):
    let (res) = number_of_accounts.read()
    return (res)
end

# Creates an account for the user and updates the storage variable
@external
func openAccount{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (sender_address) = get_caller_address()
    # checks if the user already has an account
    let (user_account) = accounts_storage.read(sender_address)
    assert user_account.isOpen = 0
    let (n_accs) = number_of_accounts.read()

    accounts_storage.write(sender_address, Account(isOpen=1, balance=0))
    number_of_accounts.write(n_accs + 1)
    return ()
end
```

If you just got another WTF moment when reading `{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}`, let me explain. Those are implicid function arguments. they are used to access the state variables behind the scenes. In addition, `range_check_ptr` can be used to compare integers. Just remember to include them in your function declarations if you want to avoid the following error: **Unknown identifier 'syscall_ptr' ... Unknown identifier 'syscall_ptr'** 😉

![](./img/nile-compile-implicit-args.png)

### A basic contract with Nile

## Front end and dApps

There is a starknet.js library for the frontend that injects a starknet object similar to `window.ethereum`. In addition, the or "get-starknet" `npm i get-starknet`

```js
import {getStartknet} from "@argent/get-starknet"

const starknet = getStarknet({showModal: true})

const [userAccountAddress] = await starknet.enable({showModal: true})

if(starknet.isConnected){
  //if connected, we can interact with contracts and sign transactions
  starknet.signer.invokeFunction({...})
}else{
  // we can still use the provider to query the blockchain
  starknet.provider.callContract(...)
}

```
