# AULOTTO
This script is suitable to generate games for NSW lotto, including:
  - OZ Lotto
  - PowerBall
  - Saturday Lotto
  
Usage: nsw-lotto [options]

    -g, --game number                ticket number
    
    -t, --type number                game type, 1:powerball, 2:ozlotto, any number: monday/wednsday/saturday lotto

    -d, --debug                      debug mode  
    

example:    
ruby nsw-lotto.rb -t 1 -g 1 -d

results are generated into a html file. I am using nginx to host it, you can see the result at : https://lotto.52dayday.com .

I am writing this script cause I want to combin the Ruby Learning with something interesting. 
Gambling is not the purpose of this script and actually there is no secret algorithm for NSW lotto inside this script.
All the number-pick-up things are handled by Ruby Standard Library.

Good luck in playing NSW Lotto. Finger Crossed! Have Fun!
