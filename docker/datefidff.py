#!/usr/bin/env python
from datetime import datetime
import sys

if len(sys.argv) != 2:
    print 'Date must be the only argument!'
    print 'Example ./datediff.py "Jun 11 12:48:00 2017 GMT"'
    sys.exit(2)

now = datetime.now()
time = datetime.strptime(sys.argv[1], '%b %d %H:%M:%S %Y %Z')
tdelta = time - now
print(tdelta.days)
