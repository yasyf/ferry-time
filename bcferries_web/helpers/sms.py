import requests, os

CARRIERS = {
  "Bell": "txt.bell.ca",
  # "Fido": "sms.fido.ca",
  "Telus": "msg.telus.com",
  # "Koodo": "msg.telus.com",
  "Rogers": "sms.rogers.com",
  "Wind": "txt.windmobile.ca",
  "Virgin": "vmobile.ca"
}

def send_sms(number, message):
  endpoint = "https://api.mailgun.net/v2/{}/messages".format(os.getenv('EMAIL_DOMAIN'))
  auth = ('api', os.getenv("EMAIL_KEY"))
  data = {
    "from": "FerryTime <noreply@ferryti.me>",
    "subject": "FerryTime Alert",
    "text": message
  }
  for gateway in CARRIERS.values():
    data['to'] = "{number} <{number}@{gateway}>".format(number=number, gateway=gateway)
    requests.post(endpoint, auth=auth, data=data)
