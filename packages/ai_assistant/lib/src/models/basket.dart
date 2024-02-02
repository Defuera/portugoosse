enum Basket {
  again, //: Move the word back to Box 1 (or keep it in Box 1 if it's already there).
  hard, // Move the word to the next box (Box 2 if it's currently in Box 1).
  good, // Move the word two boxes forward (to Box 3 if it's in Box 1).
  easy, // Move the word three boxes forward (to Box 4 if it's in Box 1).
}
