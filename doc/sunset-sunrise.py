import ephem
import datetime
 
obs = ephem.Observer()
obs.lat = '38.8'
obs.long= '-75.2'
 
start_date = datetime.datetime(2008, 1, 1)
end_date = datetime.datetime(2008, 12, 31)
td = datetime.timedelta(days=1)
 
sun = ephem.Sun()
 
sunrises = []
sunsets = []
dates = []
 
date = start_date
while date < end_date:
    date += td
    dates.append(date)
    obs.date = date
 
    rise_time = obs.next_rising(sun).datetime()
    sunrises.append(rise_time)
 
    set_time = obs.next_setting(sun).datetime()
    sunsets.append(set_time)

To plot day length in hours over the course of a year, first run the above code. Then (assuming you have matplotlib):
from pylab import *
daylens = []
for i in range(len(sunrises)):
    timediff = sunsets[i] - sunrises[i]
    hours = timediff.seconds / 60. / 60.  # to get it in hours
    daylens.append(hours)
 
plot(dates, daylens)
 
# if you have an older version of matplotlib, you may need
# to convert dates into numbers before plotting:
# dates = [date2num(i) for i in dates]
 
xlabel('Date')
ylabel('Hours')
title('Day length in 2008')
show()
