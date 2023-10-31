pragma solidity ^0.8.0;

contract RockPaperScissors {
  event GameCreated(address creator, uint gameNumber, uint bet);
  event GameStarted(address[] players, uint gameNumber);
  event GameComplete(address winner, uint gameNumber);
  
  address[][] public playersList;
  
  struct Game {
    address creator;
    address payable participant;
    uint bet;
    uint moveCreator;
    uint moveParticipant;
    bool isComplete;
  }
  
  mapping(uint => Game ) public games;
  uint public gameCounter;
  

  function createGame(address payable participant) public payable {
    require (msg.value > 0, "Bet amount must be greater than zero");
    require (games[gameCounter].creator == address(0), "Game with this number already exists");
    require (participant != address(0), "Invalid participant address");
    
    games[gameCounter] = Game({
      creator: msg.sender,
      participant: participant,
      bet: msg.value,
      moveCreator: 0,
      moveParticipant: 0,
      isComplete: false
    });
    
    emit GameCreated(msg.sender, gameCounter, msg.value);
    gameCounter++;
    
  }

  function joinGame(uint gameNumber) public payable {
    require (gameNumber < gameCounter, "Invalid Game Number");
    Game storage game = games[gameNumber];
    require (game.creator != address(0),"Game does not exist!");
    require (!game.isComplete, "Game has been played");
    require (msg.sender == game.participant, "You are not the participant of this game");
    require (msg.value == game.bet, "Invalid bet amount");
    
    address[] memory players = new address[](2);
    players[0] = game.creator;
    players[1] = game.participant;
    playersList.push(players);
    emit GameStarted(players, gameNumber);
  }

  function makeMove(uint gameNumber, uint moveNumber) public { 
    require (gameNumber < gameCounter, "Invalid game Number");
    Game storage game = games[gameNumber];
    require (game.creator != address(0), "Game does not exist");
    require (!game.isComplete, "Game has been played");
    require (msg.sender == game.creator || msg.sender == game.participant, "you dont play in this game");
    require (moveNumber >= 1 && moveNumber <= 3, "Invalid move number");
    
    if (msg.sender == game.creator) {
      game.moveCreator = moveNumber;
    } else {
      game.moveParticipant = moveNumber;
    }
    
    if (game.moveCreator > 0 && game.moveParticipant > 0) {
      determineWinner(gameNumber);
    }
  }
  
  function determineWinner(uint gameNumber) private {
    Game storage game = games[gameNumber];
    uint moveCreator = game.moveCreator;
    uint moveParticipant = game.moveParticipant;
    
    if (moveCreator == moveParticipant) {
      payable(game.creator).transfer(game.bet);
      payable(game.participant).transfer(game.bet);
      emit GameComplete(address(0), gameNumber); // tie    
    } else if (
      (moveCreator == 1 && moveParticipant == 3) ||
      (moveCreator == 2 && moveParticipant == 1) ||
      (moveCreator == 3 && moveParticipant == 2)
    ) {
      payable(game.creator).transfer(game.bet * 2);
      emit GameComplete(game.creator, gameNumber);
    } else {
      payable(game.participant).transfer(game.bet * 2);
      emit GameComplete(game.participant, gameNumber);
    }
    
    game.isComplete = true;
  }  
}