#!/usr/bin/python

# easter.py
# Routines to calculate easter for any year.
# Author: Umesh Nair, March 23, 2008.

# This lists various algorithms to calculate the following:
# 1) Gregorian easter, followed by western churches, like Catholics and Potestants.
# 2) Julian easter, easter in Julian calendar.
# 3) Julian easter in Gregorian system, followed by eastern orthodox churches.  This
#    occurs on the same day as the Julian easter.

# --------------------------------------
# Gregorian Easter in Gregorian calendar
# --------------------------------------

# Gregorian Easter - Meeus algorithm
def gregorianEasterMeeus(year):
    a = year % 19
    b = year / 100
    c = year % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    l = (32 + 2 * e + 2 * (c / 4) - h - (c % 4)) % 7
    m = (a + 11 * h + 22 * l) / 451
    n = h + l - 7 * m + 114
    month = n / 31
    day = n % 31 + 1
    return [month, day]

# Gregorian Easter - Oudin algorithm
def gregorianEasterOudin(year):
    g = year % 19
    c = year / 100
    e = c - c / 4
    h = (e - (8 * c + 13) / 25 + 19 * g + 15) % 30
    if h == 29:
        i = h - 1
    elif h == 28:
        i = h - 1 + (21 - g) / 11
    else: # h = 0..27
        i = h
    j = (year + year / 4 + i + 2 - e) % 7
    l = i - j
    if l < 4:
        month = 3
        day = l + 28
    else:
        month = 4
        day = l - 3
    return [month, day]

# Since all the algorithms above give the same results (see tests below),
# The Meeus algorithm is used by default.
# Returns the gregorian easter date for any year.
def gregorianEaster(year):
  return gregorianEasterMeeus(year)


# --------------------------------
# Julian Easter in Julian calendar
# --------------------------------

# Julian Easter - Meeus algorithm
def julianEasterMeeus(year):
  a = year % 4
  b = year % 7
  c = year % 19
  d = (19 * c + 15) % 30
  e = (2 * a + 4 * b - d + 34) % 7
  f = d + e + 114
  month = f / 31
  day = f % 31 + 1
  return [month, day]

# Julian Easter - Oudin algorithm
def julianEasterOudin(year):
  g = year % 19
  i = (19 * g + 15) % 30
  j = (year + year / 4 + i) % 7
  l = i - j
  if l < 4:
    month = 3
    day = l + 28
  else:
    month = 4
    day = l - 3
  return [month, day]

# Since all the algorithms above give the same results (see tests below),
# The Meeus algorithm is used by default.
# Returns the gregorian easter date for any year.
def julianEaster(year):
  return julianEasterMeeus(year)

# -----------------------------------
# Julian Easter in Gregorian calendar
# -----------------------------------

# Julian easter day expressed as a Gregorian date
def julianEasterInGregorian(year):
  [m, d] = julianEaster(year)
  d += year / 100 - year / 400 - 2
  if m == 3 and d > 31:
    m = 4
    d -= 31
  elif m == 4 and d > 30:
    m = 5
    d -= 30
  return [m, d]

# --------------
# Test functions
# --------------

# Tests all the algorithms above.
def testEasterAlgorithms():
  error = 0
  startYear = 1700
  endYear = 2025
  for year in xrange(startYear, endYear):
    jem = julianEasterMeeus(year)
    jeo = julianEasterOudin(year)
    if (jem != jeo):
      print "\nERROR: year = ", year, " jem = ", jem, " jeo = ", jeo
      error = 1

    gem = gregorianEasterMeeus(year)
    geo = gregorianEasterOudin(year)
    if (gem != geo):
      print "\nERROR: year = ", year, " gem = ", gem, " geo = ", geo
      error = 1
    print '.',

  if error == 0:
    print "\nAll tests for years from ", startYear, " to ", endYear, " paased."

# A utility function to display a day in March, April or May.
def dateString(monthDayArray):
  months = ["Feb", "Mar", "Apr", "May"]
  return '%s %2d' % (months[monthDayArray[0] - 2], monthDayArray[1])

# Lists three types of Easter dates for years 2000 to 2025.
def listEasterDays():
  print '-' * 39
  print "Year", "   ", "Gregorian ", "Julian    ", "Orthodox"
  print '-' * 39
  for year in xrange(2000, 2026):
    print year, "   ", dateString(gregorianEaster(year)), "   ", dateString(julianEaster(year)), "   ", \
      dateString(julianEasterInGregorian(year))
  print '-' * 39

# Main program, if this is used as a stand-alone program
if __name__ == "__main__":
  import sys
  if len(sys.argv) > 1 and sys.argv[1] == "test":
    testEasterAlgorithms()
  else:
    listEasterDays()
