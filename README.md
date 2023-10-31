# Rock, Paper, Scissors Smart Contract

This is a Solidity smart contract for playing the game of Rock, Paper, Scissors on the Ethereum blockchain. Players can create games, join existing games, and make moves. The contract automatically determines the winner and handles the transfer of funds accordingly.

## Contract Details

- **Contract Name:** `RockPaperScissors`
- **Compiler Version:** `Solidity >= 0.8.0`

## Contract Overview

The `RockPaperScissors` contract manages games and their participants. It allows players to create new games with a specified bet amount, join existing games, and make their moves. Once both players have made their moves, the contract determines the winner and transfers the funds accordingly.

## Events

### `GameCreated`

- Emits when a new game is created.
- Parameters:
  - `creator`: Address of the game creator.
  - `gameNumber`: The unique game number.
  - `bet`: The bet amount for the game.

### `GameStarted`

- Emits when a game is started with two players.
- Parameters:
  - `players`: Array of two player addresses.
  - `gameNumber`: The game number.

### `GameComplete`

- Emits when a game is completed.
- Parameters:
  - `winner`: Address of the winner. (If there's a tie, the winner address is `0x0`)
  - `gameNumber`: The game number.

## Storage

- `playersList`: An array that stores the addresses of players in each game.

## Struct

- `Game`: Defines the game structure with the following fields:
  - `creator`: Address of the game creator.
  - `participant`: Address of the game participant.
  - `bet`: The bet amount for the game.
  - `moveCreator`: The move made by the creator (1 for Rock, 2 for Paper, 3 for Scissors).
  - `moveParticipant`: The move made by the participant (1 for Rock, 2 for Paper, 3 for Scissors).
  - `isComplete`: A boolean to check if the game is complete.

## Mappings

- `games`: Maps game numbers to their respective `Game` structures.
- `gameCounter`: Tracks the total number of games created.

## Functions

### `createGame`

- Allows a user to create a new game with a specified bet amount and a participant.
- Requirements:
  - The bet amount must be greater than zero.
  - A game with the same number must not already exist.
  - The participant address must be valid.
- Emits a `GameCreated` event.

### `joinGame`

- Allows a user to join an existing game by providing the game number and matching the bet amount.
- Requirements:
  - The game number must be valid.
  - The game must exist.
  - The game must not be completed.
  - The sender must be the designated participant.
  - The sent value must match the game's bet amount.
- Emits a `GameStarted` event.

### `makeMove`

- Allows a player to make a move in a game.
- Requirements:
  - The game number must be valid.
  - The game must exist.
  - The game must not be completed.
  - The sender must be either the creator or participant of the game.
  - The move number must be between 1 and 3 (Rock, Paper, or Scissors).
- If both players have made their moves, this function triggers `determineWinner`.

### `determineWinner` (Private)

- Determines the winner of a game based on the moves made by the players.
- Handles the transfer of funds to the winner.
- Emits a `GameComplete` event with the winner's address.

---

This smart contract enables users to play the classic game of Rock, Paper, Scissors in a secure and transparent manner on the Ethereum blockchain. Players can create and join games, make their moves, and see the outcome of each game. The contract automatically handles the transfer of funds to the winner.