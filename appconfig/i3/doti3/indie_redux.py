import urllib2
import re
import datetime

get = urllib2.urlopen('https://www.restauracekathmandu.cz/denni-menu')
html = get.read()
response = re.sub(r'\<.*?\>', '', html)
response = response.replace("&nbsp;","")
response = response[response.find("menu / Daily menu"):response.find("Ke ka")]
response = response.split("\n",2)[2];
day = datetime.datetime.today().weekday()
if day == 0:
    response = response[response.find("MONDAY"):response.find("TUESDAY")]
    #    response = response[:response.rfind('\n')]
elif day == 1:
    response = response[response.find("TUESDAY"):response.find("WEDNESDAY")]
    #    response = response[:response.rfind('\n')]
elif day == 2:
    response = response[response.find("WEDNESDAY"):response.find("THURSDAY")]
    #    response = response[:response.rfind('\n')]
elif day == 3:
    response = response[response.find("THURSDAY"):response.find("FRIDAY")]
    #    response = response[:response.rfind('\n')]
elif day == 4:
    response = response[response.find("FRIDAY"):-1]
else:
    response = "No Indian on the weekends!!!!"

response = response.replace('1.', '\n1.', 1)
response = response.replace('2.', '\n2.', 1)
response = response.replace('3.', '\n3.', 1)
response = response.replace('4.', '\n4.', 1)
response = response.replace('5.', '\n5.', 1)
response = response.replace('6.', '\n6.')

chic = response[response.find("3."):-1]
chic = chic.partition("\n")[0]
chic = chic[chic.find("/"):chic.find("  ")]
chic = chic[1:]

pork = response[response.find("4."):-1]
pork = pork.partition("\n")[0]
pork = pork[pork.find("/"):pork.find("  ")]

print(chic+pork)
