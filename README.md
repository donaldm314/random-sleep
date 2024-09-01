# Call sleep with a random time.


## Usage:

```
random-sleep.sh MAX_DELAY[SUFFIX]
```
Where MAX_DELAY is an integer, optionally with the 
SUFFIX 's' for seconds (the default), 'm' for minutes, 
'h' for hours, or 'd' for days.

Sleeps for a random delay between 0 and MAX_DELAY, 
by calling sleep.

