# AULOTTO
This script is suitable to generate games for NSW lotto, including:
  - OZ Lotto
  - PowerBall
  - Saturday Lotto
  
Usage: test [options]
    
    -g, --game number                ticket number
    
    -t, --type number                game type
    
    -d, --debug                      debug mode
    
    
    type 1 : PowerBall
    Type 2: Saturday Lotto
    any other type number: OZ Lotto
    
ruby nsw-lotto.rb -t 1 -g 1
