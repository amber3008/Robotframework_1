import smtplib
from io import StringIO
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText

from email import encoders
import os
import socket



def send_mail_no_attachment(server, from_user, from_password, to, subject, text):
    msg = MIMEMultipart()
    msg['From'] = from_user
    msg['To'] = to
    msg['Subject'] = subject

    msg.attach(MIMEText(text))

    mailServer = smtplib.SMTP(server,587)
    mailServer.ehlo()
    mailServer.starttls()
    mailServer.ehlo()
    mailServer.login(from_user, from_password)
    mailServer.sendmail(from_user, to, msg.as_string())
    mailServer.close()