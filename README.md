# AntiMartingaleSystem

### System to scale into a Position in a strong trend
- Input TradeID from BinX, and Time where VWAP should start

System:
    Adds to the position so that break even is at the VWAP line. You have the option to close all trades with a command. 
    SL gets automatically executed for all positions with tiny profits.





Idea of code:

- create exchagne object

- input symbol
- input VWAP starting time (1m precise)

- get trade direction, (total)amount, (average)price
- add ID to PositionList
- calc ATR
- nextVWAPLevel = 0.0

- every 1 minute (in its own actor)
	- update/create VWAP
	- if nextVWAPLevel == 0.0 or VWAP > (or <) nextVWAPLevel
		- nextVWAPLevel update
		- calculate newPosition size for BE = VWAP +/- ATR?
		- market order newPosition
		- add PositionId to PositionList
		- update all SL
		- update averagePrice with API (to be more precise)
		
- wait for 'stop' command
	- send a 'stop' to async actor that will exit every position
