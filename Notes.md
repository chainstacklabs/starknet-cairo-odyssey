# Resources

https://perama-v.github.io/cairo/by-example/ -- GOLD
https://perama-v.github.io/cairo/intro/

https://github.com/gakonst/awesome-starknet#tutorials
https://github.com/l-henri/starknet-cairo-101
https://hackmd.io/@RoboTeddy/BJZFu56wF
https://starknet.io/documentation/
https://starknet.io/what-is-starknet/

https://hackmd.io/@sambarnes/BJvGs0JpK - Full-Stack Starknet

# Starknet intro

As a wallet, it uses [ArgentX](https://chrome.google.com/webstore/detail/argent-x-starknet-wallet/dlcobpjiigpikoobohmabehhmhfoodbb/). It different from Metamaks in the way that when you create your wallet, it takes a while to actually deploy it to the L2 network.

## Starknet Nodes and Sequencers

Starknet nodes use the [pathfinder client](https://github.com/eqlabs/pathfinder#api) and they are similar to the nodes running GoEthereum although the exposed API only has methods to read from the blockchain as posting transactions is done via Sequencers.

There is a [GitHub issue in the Pathfinder client](https://github.com/eqlabs/pathfinder/issues/240) that aims to allow transactions to be submited to a node and then forward them to a Sequencer.

Sequencers are a special nodes that receives the transactions. These are currently run by Starknet but they'll be open sourced soon.

## How startknet works

When a transaction is submitted, it goes to a sequencer (currently centralized and closed-source).

The sequencer takes batches of transactions and generates two things:

- a list of changes caused by all the transactions in the batch (changes in storage, etc )
- a proof that, if all transactions included in the batch are executed successfully against the previous state of the network (StarkNet), the result will be the list of changes listed before.

**In StarkNet, the transactions are not recorded on chain, only the state changes are recorded on chain in L1.**

## How fees work in StarkNet

StarkNet fees are paid in ETH and the team released a [post about fees](https://community.starknet.io/t/fees-in-starknet-alpha/286) in which they indicate how StarkNet calculate fees for each transaction. In summary, it follows the "Computation is cheap. Writes are expensive." rule 😉

## Setting up the dev environment

Install Python 3.7 with `brew install python@3.7`. Now I can run Python scripts usin version 3.7 with `python3` in the terminal.

Install pip with `python3 get-pip.py` after [downloading the installation script from here](https://pip.pypa.io/en/latest/installation/#get-pip-py).

With Python configured, I go through [the official guide](https://www.cairo-lang.org/docs/quickstart.html).

Create a virtual environment with:

```
python3 -m venv ~/cairo_venv
source ~/cairo_venv/bin/activate
```

Install depenencies with `pip3 install ecdsa fastecdsa sympy` then `brew install gmp`.

Install the Cairo language with `pip3 install cairo-lang`

## Using Nile as Starknet toolkit

[Nile](https://github.com/OpenZeppelin/nile) which makes managing files and command line calls to StarkNet simple. To install it, run `pip install cairo-nile`

To bootstrap a new project with Nile, run `nile init`.

To compile the contract run `nile compile`. Compiled files will be in the `/artifacts` folder.

To run a local node, run `nile node`.

To run tests, use `pytest -s path/to/testfile`

To deploy a contract run `nile deploy contract --alias contract ` where the first "contract" is the contract file name and the second, the alias you want to save it with.

![](./nile-compile-deploy.png)

Once deployed, you can interact with the contract using `nile invoke` for @external functions or `nile call` for @view functions. For example `nile invoke bank createAccount`

![](/nile-4.png)

![](./nile-call-invoke.png)

To deploy to the StarkNet mainnet, use `nile deploy my_contract --alias my_contract --network mainnet`

## Coding with Cairo

**Recursion instead of loops**: The main reason for this is that the Cairo memory is immutable - once you write the value of a memory cell, this cell cannot change in the future. This is similar to pure functional languages, whose objects are also immutable, where you also have to replace loops with recursion for the same reason.

`assert <expr0> = <expr1>` verifies that two values are the same (as you may have expected), or assigns a value to a memory cell.

### Compile and run programs

To compile

```s
cairo-compile array_sum.cairo --output array_sum_compiled.json
```

To run programs:

```s
cairo-run --program=array_sum_compiled.json \
    --print_output --layout=small
```

|                    | Solidity                            | Cairo                      |
| ------------------ | ----------------------------------- | -------------------------- |
| Memory             | Mutable, variables can be re-writen | Inmutable                  |
| If conditional     | `if(size == 0){}`                   | `if size == 0:`            |
| Return in function | `return a`                          | `return (a)`               |
| Assertions         | `require(a == b)`                   | `assert <expr0> = <expr1>` |
