# AULOTTO
This script is suitable to generate games for NSW lotto, including:
  - OZ Lotto
  - PowerBall
  - Saturday Lotto
  
Usage: nsw-lotto [options]
    -g, --game number                ticket number
    -t, --type number                game type, 1:powerball, 2:monday/wednsday/saturday lotto, any number: ozlotto(default lotto)
    -d, --debug                      debug mode  
    
    type 1:   PowerBall
    Type 2:   Monday/Tuesday/Saturday Lotto
    any other type number: OZ Lotto
    
ruby nsw-lotto.rb -t 1 -g 1
