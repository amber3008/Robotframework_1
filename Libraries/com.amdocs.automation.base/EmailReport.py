import json
import csv
import os
#from pymsgbox import *
import glob
import datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os.path
import pandas as pd
import numpy as np
from csv import reader
import time
import logging
from datetime import date

# Configuration
header = 'Consolidated TFL Mobile App (Android) Sanity'
Receiver_Email = 'amber.bhatnagar@amdocs.com'
sender_email = 'amberb@amdocs.com'  # NTNET email id is required e.g. "ankhare@amdocs.com" instead of "ankit.khare@amdocs.com"
password = "MyWishesComeTrue#3008"
SMTP_SERVER = 'Inpnqrmail.corp.amdocs.com'
envs = ['PP1', 'PP3', 'PP4', 'Z2', 'Z1']


def color_negative_red(val):
    if val == "Pass":
        color = 'green' if val == "Pass" else 'black'
    else:
        color = 'red' if val == "Fail" else 'black'
    return 'color: %s' % color


def MOBILEAPP_Summary_API(start, end):
    Total_rows = end - start
    a = [0, 0, 'Pass']
    for i in range(start + 1, end + 1):
        if df.iloc[i]['Status'] == 'Pass':
            a[0] = a[0] + 1
        elif df.iloc[i]['Status'] == 'Fail':
            a[1] = a[1] + 1

    if a[0] + a[1] == 0:
        a[2] = 'No Run'
    elif Total_rows > a[0] + a[1]:
        a[2] = 'Partially Executed'
    elif Total_rows == a[0]:
        a[2] = 'Pass'
    else:
        a[2] = 'Fail'

    return a


# ---------------------------------MAIN-----------------------------------------
#os.chdir("CSVs/")
#list_of_files = glob.glob('*.csv')
#CSV_Path = max(list_of_files, key=os.path.getctime)

now = datetime.datetime.now().strftime("%d/%m/%Y-%H:%M:%S")
#df = pd.read_csv(CSV_Path)
#df = df.fillna(" ")

indexes = {}
#df = df.fillna(" ")

try:
    for i in envs:
        j = df[df['Scenario name'] == '***********TFL Android Mobile App' + i + '************'].index.item()
        print("Env found in CSV: " + i)
        if j > 0:
            df = df.drop(j - 1)
            df.reset_index(drop=True, inplace=True)

except:
    print("ENV NOT FOUND IN CSV: " + i)
    envs.remove(i)

#for i in envs:
#    j = df[df['Scenario name'] == '***********TFL Android Mobile App' + i + '************'].index.item()
#    indexes[j] = i

#html_df = df.style.hide_index().applymap(color_negative_red)
#html_df = html_df.set_table_attributes('border="1";text-align:"center"').set_properties(**{'text-align': 'inner'})

new_list = sorted(indexes.keys())
diff = []

for a in range(0, len(new_list)):
    if a < len(new_list) - 1:
        diff.append(new_list[a + 1] - new_list[a] - 1)
    elif a == len(new_list) - 1:
        diff.append(len(df) - new_list[a] - 1)

table_data = [['Sr.No.', 'Package', 'Status', 'Test Cases Executed', 'Test Cases Passed', 'Test Cases Failed']]
for i, j in zip(range(1, len(envs) + 1), sorted(indexes.keys())):
    table_data.append([
        i,
        'TFL Android Mobile App - ' + indexes[j],
        MOBILEAPP_Summary_API(j, j + diff[i - 1])[2],
        diff[i - 1],
        MOBILEAPP_Summary_API(j, j + diff[i - 1])[0],
        MOBILEAPP_Summary_API(j, j + diff[i - 1])[1]
    ])

df2 = pd.DataFrame(table_data)
new_header = df2.iloc[0]
df2 = df2[1:]
df2.columns = new_header
df2.style.set_table_styles(
    [{'selector': 'th',
      'props': [('background-color', 'black'), ('font color', '#FFFFFF')]}])
html_df1 = df2.style.hide_index().applymap(color_negative_red).set_table_attributes(
    'border="3";border-color="#660000";text-align:"center"r').set_properties(**{'text-align': 'inner'})

subject = header + " - " + now
message = "<br>***************************************************************************<br><i>**This is an automatically generated email. Please do not reply. </i><br>***************************************************************************<br>Hi All,<br><br>Below is the " + header + " Summary Report: <br><br>" + html_df1.render() + "<br><strong><u>Scenarios :</u></strong><br><br>" + html_df.render()

msg = MIMEMultipart()
msg['From'] = sender_email
msg['To'] = Receiver_Email
msg['Subject'] = subject
part = MIMEText(message, 'html')
msg.attach(part)
server = smtplib.SMTP(SMTP_SERVER, 587)
server.starttls()
server.login(sender_email, password)
msg = msg.as_string()
server.sendmail(sender_email, Receiver_Email.split(","), msg)
print("Email sent!")
server.quit()