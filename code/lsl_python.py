import time
from random import random as rand

from pylsl import StreamInfo, StreamOutlet, local_clock

info = StreamInfo('python', 'EEG', 2, 100, 'float32', 'myuid34234')
outlet = StreamOutlet(info)

print("sending random samples")
time_now = local_clock()
while True:
    mysample = [rand(), rand()]
    outlet.push_sample(mysample)
    time.sleep(.01)

