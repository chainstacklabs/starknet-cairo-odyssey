# Starket and Cairo Odyssey

This repo contains first steps, tips and learnings to use StarkNet and create smart contracts using Cairo.

The two articles have been published in the [Chainstack blog](https://chainstack.com/):

- [A StarkNet odyssey: Overview and developer tools](https://chainstack.com/starknet-developer-introduction-part-1)
- [A StarkNet odyssey: Escaping Cairo hell](https://chainstack.com/starknet-cairo-developer-introduction-part-2/)

## Cairo code samples

You can find differe contracts with examples in the `cairo-examples` folder. Make sure to follow instructions to setup your development environment, explained in [the first article](https://chainstack.com/starknet-developer-introduction-part-1/).

The `cairo-examples` is a Nile project so it's recommended to install it as well.

### Run tests

The test files in the `cairo-examples//tests/` folder can be run using `pytest`, for examples `pytest ./tests/test_secretNumber.py`

## Web app example

The `webapp` folder contains a Vue.js application to showcase how to interact with a contract deployed in StarkNet. Check out the [Numbers](./webapp/src/components/Numbers.vue) component to see how to connect to a wallet call contract methods.

![](./img/wallet.gif)

The app uses `@argent/get-starknet` library.
