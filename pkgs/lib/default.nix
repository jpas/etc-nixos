{ lib
, ...
}:

{
  lib.testLibOverlay = x: trace "hello!" x
}
