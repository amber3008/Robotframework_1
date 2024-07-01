import win32com.client as win32

class SendEmail:
    def sendEmail(self):
        olApp = win32.Dispatch('Outlook.Application')
        olNS = olApp.GetNameSpace('MAPI')

        # construct email item object
        mailItem = olApp.CreateItem(0)
        mailItem.Subject = 'Hello 12368uuyt77687'
        #mailItem.BodyFormat = 1
        #mailItem.Body = 'Hello There576577'
        mailItem.To = 'amber.bhatnagar@amdocs.com'
        mailItem.Sensitivity  = 2
        mailItem.BodyFormat = 2
        mailItem.HTMLBODY = "<HTML><H2>fytfytf The body of this 7687h message will appear in HTML.</H2><BODY>Type the message text here. </BODY></HTML>"
        # optional (account you want to use to send the email)
        # mailItem._oleobj_.Invoke(*(64209, 0, 8, 0, olNS.Accounts.Item('<email@gmail.com')))
        #mailItem.Display()
        #mailItem.Save()
        mailItem.Send()