Esta es la segunda parte de la serie "La odisea StarkNet", en la cual repasamos . Antes de seguir leyendo, asegúrate de leer [la primera parte](https://awdawd) para aprender qué es StarkNet, que son las ZK-proofs y aprender sobre las differentes herramientas que necesitamos para empezar a desarrollar aplicaciones en StarkNet.

Este artículo es una introducción a Cairo, el lenguage utilizado para escribir programas y smart contracts en StarkNet, y vamos a ver como interactuar con un contrato desde una aplicación web utilizando la libreria de Javascript de ArgentX.

Puedes encontrar todos el código de este artículo, incluyendo contratos y la aplicación web, en [el siguiente repositorio en GitHub](https://github.com/uF4No/starknet-cairo-odyssey).

## Introdución a Cairo

Cairo es... dificil. El equipo de StarkWare ha creado [un repositorio con algunos ejercicios y ejemplos para empezar](https://github.com/starknet-edu/starknet-cairo-101), y aunque es bastante útil, la curva de aprendizaje de este lenguage es bastande dura.

![Cairo for StarkNet developers](./img/cairo-hell.png)

Asi que, empezemos desde cero, y vamos a revisar unas cuantas cosas antes de empezar a escribir la primera linea de código.

### Qué es felt?

`felt` significa "Field element" y **es el único tipo de dato en Cairo**. Simplificando, es un entero sin simbolo que es capáz de almacenar hasta 76 decimales. Podemos utilizarlo también para almacenar direcciones de contratos.

### Strings o cadenas de texto

**Actualmente Cairo no tiene soporte para strings.** Podemos almacenar pequeñas cadenas de texto en un `felt` pero se guardaran con su correspondiente valor:

```php
#  = 448378203247
let hello_string = 'hello'
```

### Matrices (arrays)

Para utilizar matrices en Cairo, necesitamos crear un puntero que apunte al primer elemento del array utilizando `felt*` y `alloc()`.

Para añadir nuevos elementos al array, utilizaremos `assert` (más información sobre este método después) y el puntero creado anteriormente. Aqui tienes un ejemplo:

```php
%lang starknet
%builtins range_check

# import para utilizar alloc
from starkware.cairo.common.alloc import alloc

# view function that returns a felt and
# has range_check_ptr as an implicid argument
@view
func array_demo(index : felt) -> (value : felt):
    # Creates el puntero al principio del array
    let (my_array : felt*) = alloc()

    # guarda 3 como primer elemento en el array
    assert [felt_array] = 3
    # guarda 15 como el segundo elemento del array
    assert [felt_array + 1] = 15
    # guarda 33 como tercer elemento
    assert [felt_array + 2] = 33
    assert [felt_array + 9] = 18
    # Lee del array utilizando el indice recibido en la funcion
    let val = felt_array[index]
    return (val)
end
```

Si intentamos leer el valor de un indice no valido del array, nuestro programa fallara y lanzara el siguiente mensaje de error: **Unknown value for memory cell at address**.

Podemos utilizar arrays como parametros de funciones o devolverlos en las mismas, pero para ello tenemos que indicar tanto el array como su longitud. Para ello, hay que seguir la convención `nombre_del_array` y `nombre_del_array_len`. Aqui tienes un ejemplo:

```php
%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Function that receives an array as parameter, so it actually receives the array length and # the array itself
@external
func array_play(array_param_len : felt, array_param : felt*) -> (res: felt):
    # read first element of the array
    let first = array_param[0]
    # read last element of the array
    let last = array_param[array_param_len - 1]

    let res = first + last

    return (res)
end
```

Si no utilizamos los nombres correctos en las variables, el compilador nos dará el siguiente mensaje de error: **Array argument "array_param" must be preceded by a length argument named "array_param_len" of type felt.**

Puedes encontrar un ejemplo de [cómo usar arrays en un contrato Cairo en este enlace](https://github.com/uF4No/starknet-cairo-odyssey/cairo-examples/contracts/arrays.cairo).

### Structs y mappings

Los structs y mappings se declaran de manera muy similar a Solidity. Para definir un struct, utilizaremos la `struct` y `member` para cada uno de los atributos:

```php
# Account struct
struct Account:
    member isOpen: felt
    member balance: felt
end

```

Para crear un **mapping en Cairo** tenemos que definir los typos y usar `->` entre la clave y el valor. Por ejemplo, este es un mapping de `felt` y `struct`:

```php
# Mapping named "accounts_storage" that holds the account details for
# each user using his address as key
@storage_var
func accounts_storage(address: felt) -> (account: Account):
end
```

También podemos devolver structs desde una función. Puedes [encontrar un ejemplo en este contrato](https://github.com/uF4No/starknet-cairo-odyssey/cairo-examples/contracts/structs-mappings.cairo).

### Declarar variables

Podemos crear alias que apuntan a variables utilizando `let` o asignarles valores con `const`, `local` or `tempvar`.

- `const` se utiliza para definir constantes y su valor no se puede re asignar.
- `local` utilizado para declarar variables locales. Su valor tampoco se puede re asignar y además tendremos que añadir el método `alloc_locals` en la función en la que queramos utilizarlas.
- `tempvar` se utiliza para declarar variables temporales cuyo valor podemos re asignar.
- `let` se utiliza para declarar variables por valor or por referencia con otras varibles. Su valor se puede re asignar.

Aqui tienes unos ejemplos para entender como funciona cada una:

```php
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

```

Fíjate en que para reasignar una variable, tambien tenemos que indicar el tipo (`tempvar`, `let`)!

### Variables de almacenamiento: escribir y leer

Las variables de estado que solemos declarar en los smart contracts, se denominan variables de almacenamiento o "storage variables" en Cairo. Capara declararlas, debemos utilizar el decorador `@storage_var` y definir una función con el tipo. He aqui un ejemplo:

```php
# Keeps a counter of the number of accounts
@storage_var
func number_of_accounts() -> (res: felt):
end
```

Para leer y escribir datos en las variables de almacenamiento, tenemos que usar los métodos `read` y `write`, asegurándonos de que los tipos de datos que pasamos para escribir, son los mismos de los que hemos definido anteriormente.

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

### Qué es `{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}` aparece en cada método?

Si has leido algún contrato escrito en Cairo, probablemente habrás visto estas lineas multiples veces: `{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}`.

Estos son argumentos implicitos de las funciones y Cairo los necesita para poder acceder a las variables de estado. Además `range_check_ptr` se utiliza para comparar numeros. Recuerda incluir estos parametros en todas las funciones que accedan a variables de estado. Si no lo haces, el compilador te devolverá el siguiente error: **Unknown identifier 'syscall_ptr' ... Unknown identifier 'syscall_ptr'** 😉

![](./img/nile-compile-implicit-args.png)

### Aserciones

`assert` es un método super útil pero que puede usarse para propósitos complétamente diferentes:

- para comparar si el valor de dos variables es el mismo
- para asignar valor a una variable

Aqui tienes un ejemplo:

```php
%lang starknet

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

```

Para otro tipo de comparaciones, puedes importar otros métodos desde la libreria `starkware.cairo.common.math`, como por ejemplo `assert_not_zero`, `assert_in_range`, `assert_not_equal`, `assert_le` y `assert_lt`:

```php
%lang starknet

from starkware.cairo.common.math import (
  assert_not_equal,
        assert_in_range
        assert_not_zero,
        assert_lt,
        assert_le,
)

@external
func assertions_demo(a: felt, b: felt):

    assert_not_zero(a)
    assert_not_equal(b, a)
    assert_le(1, 100)
    assert_lt(b, 1)
    assert_in_range(b, 1, 60)

    return ()
end
```

### Funciones

Las funciones en los contratos se declaran utilizando los decoradores `@external` y `@view`. Las que declaramos como external se invocan por otros contratos o por usuarios y normalmente alteran variables de estado. Las funciones `view` solo leen variables de estado, no pueden alterarlo.

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

Debemos indicar los valores que vamos a devolver en nuestras funciones, incluso si la función no devuelve ningún valor.

### Estructura de un contrato

Los contratos escritos en Cairo tienen una estructura similar a los contratos escritos en otros lenguajes como Solidity:

1. definición del lenguaje `%lang starknet`
2. importación de librerias
3. structs and variables de estado
4. métodos y funciones

### Comunicación entre L1-L2

Una de las cosas que podemos hacer en Cairo es enviar mensajes entre StarkNet (L2) y Ethereum (L1). Para ello, necesitamos desplegar un contrato en StarkNet que utilize el método `send_message_to_l1` , que reibe como parámetros la dirección del contrato que va a recibir el mensaje en la L1, y los parametros o variables que querramos enviar.

Además, tendremos que desplegar el correspondiente contrato en Ethereum para capturar esos mensajes. Este contrato tendrá que implementar la interfaz [IStarknetCore](https://www.cairo-lang.org/docs/hello_starknet/index.html#starknet-alpha-on-mainnet) que provee los métodos `consumeMessageFromL2` y `sendMessageToL2`.

Puedes encontrar un tutorial paso a paso en [la documentación de Chainstack](https://docs.chainstack.com/tutorials/starknet/nft-contract-with-nile-and-l1-l2-reputation-messaging#prerequisites).

## Como interactuar con contratos

Puedes interactuar con contratos directamente desde [Voyager](https://voyager.online/), el explorador oficial de StarkNet.

Para interactuar con contratos desde una aplicación web, las librerias más comunes son starknet.js y @argent/get-starknet. La rpimera es una libreria que podemos utilizar tanto en un frontend como en un backend. Puedes encontrar la [documentación de su API aqui](https://www.starknetjs.com/docs/API/). La segunda, es un wrapper que ayuda a interactuar con wallets como ArgentX y Braavos, aunque utiliza `starknet.js` como dependencia.

### Ejemplo de aplicación web

En el [siguiente repositorio encontrarás](<(https://github.com/uF4No/starknet-cairo-odyssey/)>) una pequeña aplicación web contruida con Vue.js y @argent/get-starknet que te servirá como ejemplo para ver como interactuar con wallets y con un contrato desplegado en StarkNet.

![](./img/wallet.gif)

Aqui puedes ver como conectar con la wallet:

```js
import { connect } from '@argent/get-starknet'

let starknet = null

const connectWallet = async () => {
  starknet = await connect()
  console.log('startknet >>', starknet)

  if (!starknet) {
    throw Error(
      'User rejected wallet selection or silent connect found nothing'
    )
  }

  await starknet.enable()

  // Check if connection was successful
  if (starknet.isConnected) {
    console.log('starknet connected')
  } else {
    console.log('starknet wallet not connected')
  }
}
```

Una vez que nuestra aplicación está conectada con la wallet del usuario, podemos utilizarla para interactuar con nuestro contrato mediante los métodos `starknet.account.callContract` para funciones `@view` o `starknet.account.execute` para funciones `@external`. Ambos requiren los siguientes parámetros:

- `contractAddress`
- `entrypoint` el nombre de la función del contrato
- `calldata` un array con todos los parametros que queremos enviar (optional)

Aqui tienes un ejemplo de como usar ambas:

```js
const CONTRACT_ADDRESS =
  '0x07955c619cb22d08ece120ef4f5faa531318ac9934018ef28fdae9284b831b4d'

// Reads from the chain using callContract
const getUserNumber = async () => {
  try {
    const res = await starknet.provider.callContract({
      contractAddress: CONTRACT_ADDRESS,
      entrypoint: 'get_number',
    })
    console.log('res', res)
    savedNumber.value = Number(`${res.result[0]}`)
  } catch (error) {
    console.error(error)
  }
}

// Writes on-chain using execute
const saveNumber = async () => {
  try {
    const trxDetails = await starknet.account.execute({
      contractAddress: CONTRACT_ADDRESS,
      entrypoint: 'save_number',
      calldata: [userNum.value],
    })
    console.log('trxDetails', trxDetails)
  } catch (error) {
    console.error(error)
  }
}
```

## Librerias de Python

Si prefieres utilizar Python, [StarkNet.py](https://github.com/software-mansion/starknet.py) es la libreria para ti. Tiene todos los métodos que necesitas para interactuar con contratos y la blockchain

## Conclusión

Espero que este artículo te ayude a perderle el miedo a Cairo y te empuje a desarrollar aplicaciones en StarkNet.

Las soluciones de capa 2 (L2s) son cada vez más populares y StarkNet es una de las más populares. Hay hackathons casi cada mes y el equipo de StarkWare ha lanzado [StarkGate](https://starkgate.starknet.io/), un bridge que permite enviar ETH y otros tokens desde Ethereum mainnet a Starknet.
