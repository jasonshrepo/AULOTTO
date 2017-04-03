# AULOTTO
This script is suitable to generate games for NSW lotto, including:
  - OZ Lotto
  - PowerBall
  - Saturday Lotto
  
Usage: nsw-lotto [options]

    -g, --game number                ticket number
    
    -t, --type number                game type, 1:powerball, 2:ozlotto, any number: monday/wednsday/saturday lotto

    -m  --method number              method type, 1: all number used at least once, other: DEC method. default is 0

    -d, --debug                      debug mode  
    

example:    
ruby nsw-lotto.rb -t 1 -g 1 -m 1

results are export to local-file: lotto-result.txt

I am writing this script cause I want to combin the Ruby Learning with something interesting. 
Gambling is not the purpose of this script and actually there is no secret algorithm for NSW lotto inside this script.
All the number-pick-up things are handled by Ruby Standard Library.

Good luck in playing NSW Lotto. Finger Crossed! Have Fun!
