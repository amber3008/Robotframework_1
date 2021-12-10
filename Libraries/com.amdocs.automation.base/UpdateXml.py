import random
from random import randrange
from robot.api import logger
import xml.etree.ElementTree as ET

ran=""
a=[]

class UpdateXml:
    def updateXml(self,orderType):
        self.orderType=orderType
        ran= str(randrange(100000))
        projid= randrange(100000)
        strProj=str(projid)
        type="MIS"
        type2="AVPN"

       # if orderType is type:
       #     id="1-ME"
       # elif orderType is type2:
       #     id="1-AVPN"
       # else:
       #     id="1-CPTM"

        id="1-ME"
        sorid = id+ran

        # read from a file

        with open('xmls/requests/notifyRequest.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{sorId}',sorid)
            contents = contents.replace('{proId}', strProj)
            contents = contents.replace('{orderType}', orderType)
            contents = contents.replace('{aType}', type2)

        # write to a file
        with open('xmls/requests/notifyRequest.xml', "w") as write_file:
            write_file.write(contents)

        print("SORID is : "+sorid)
        a.append(sorid)
        a.append(strProj)
        return a


    def getSorProjId(self):
        return a

    def pushDecomposeXml(self,b):
        self.b=b

        # read from a file

        with open('xmls/requests/decomposeSalesOrderRequest.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{$sorId$}',b[0])
            contents = contents.replace('{$projId$}',b[1])


        # write to a file
        with open('xmls/requests/decomposeSalesOrderRequest.xml', "w") as write_file:
            write_file.write(contents)

    def updateMorSg(self, acsmOrderId,mismOrderid,sorid,strProj,sgId):
        self.acsmOrderId = acsmOrderId
        self.mismOrderid = mismOrderid
        self.sorid = sorid
        self.strProj = strProj
        self.sgId = sgId
        with open('xmls/requests/MOR_SG_OLD.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{$sorId$}', sorid)
            contents = contents.replace('{$projId$}', strProj)
            contents = contents.replace('{$sgId$}', sgId)
            contents = contents.replace('{$oaIdAc$}', acsmOrderId)
            contents = contents.replace('{$oaId$}', mismOrderid)

        # write to a file
        with open('xmls/requests/MOR_SG_OLD.xml', "w") as write_file:
            write_file.write(contents)


    def updateSubmitJson(self,b):
        self.b=b

        # read from a file

        with open('xmls/requests/SubmitOrderActionReq.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{$orderId}',b)

        # write to a file
        with open('xmls/requests/SubmitOrderActionReq.json', "w") as write_file:
            write_file.write(contents)



    def updateXmlUni(self, isPmtu,isAdx, stateRegion1, stateRegion2):
        self.isAdx=isAdx;
        self.isPmtu=isPmtu;
        self.stateRegion1=stateRegion1;
        self.stateRegion2 = stateRegion2;



        # read from a file

        #with open('C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/requests/CNOD_UNI_NS.txt', "rt") as read_file:
        with open('xmls/requests/CNOD_UNI_NS.txt',"rt") as read_file:
            contents = read_file.read()

            if isPmtu in ['Y']:
                contents = contents.replace('<!--{$pmTu$}-->', "<characteristicValues>\r\n" +
			 				"                              <characteristicDefinition>\r\n" +
			 				"                                 <attributeCode>providerMtu</attributeCode>\r\n" +
			 				"                                 <attributeId>73423</attributeId>\r\n" +
			 				"                              </characteristicDefinition>\r\n" +
			 				"                              <value>5678</value>\r\n" +
			 				"                           </characteristicValues>")

            if stateRegion1 in ['Y']:
                contents = contents.replace('<!--stateRegion1-->', "Y")

            if stateRegion1 in ['O']:
                contents = contents.replace('<!--stateRegion1-->', "O")

            if stateRegion1 in ['N']:
                contents = contents.replace('<!--stateRegion1-->', "N")


            if stateRegion2 in ['Y']:
                contents = contents.replace('<!--stateRegion2-->', "Y")

            if stateRegion2 in ['O']:
                contents = contents.replace('<!--stateRegion2-->', "O")

            if stateRegion2 in ['N']:
                contents = contents.replace('<!--stateRegion2-->', "N")


            if isAdx in ['Y']:
                contents = contents.replace('<!--ADX-->', "<characteristicValues>\r\n" +
                                                "                              <characteristicDefinition>\r\n" +
                                                "                                 <attributeCode>fisArrangement</attributeCode>\r\n" +
                                                "                                 <attributeId>6040405</attributeId>\r\n" +
                                                "                              </characteristicDefinition>\r\n" +
                                                "                              <value>ADX</value>\r\n" +
                                                "                           </characteristicValues>")

        # write to a file
        #with open('C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/requests/CNOD_UNI_NS.xml', "w") as write_file:
        with open('xmls/requests/CNOD_UNI_NS.xml',"w") as write_file:
            write_file.write(contents)


        return a


    def updateXmlPTP(self):

        with open('C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/requests/CNOD_PTP_NS.txt', "rt") as read_file:
            contents =read_file.read()
            contents =contents.replace("<!--{$cvlan1$}-->",str(random.randint(100,999)))
            contents =contents.replace("<!--{$cvlan2$}-->",str(random.randint(100,999)))

            # write to a file
        with open('C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/requests/CNOD_PTP_NS.xml',"w") as write_file:
            write_file.write(contents)


        tree=ET.parse(open("C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/response/CNOD_UNI_NS_Response.xml","r"))
        root=tree.getroot()
        sr1=root[1][0][0][0][2][1][5].text
        sr2=root[1][0][0][0][3][1][5].text
        print(sr1+"   "+sr2)
        with open('C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/requests/CNOD_PTP_NS.txt', "rt") as read_file:
            contents =read_file.read()
            contents =contents.replace("<!--{$sr1$}-->",sr1)
            contents =contents.replace("<!--{$sr2$}-->",sr2)

            # write to a file
        with open('C:/Users/shivamte/PycharmProjects/robotframeworkautomation/xmls/requests/CNOD_PTP_NS.xml',"w") as write_file:
            write_file.write(contents)

        logger.info("output: ")



#obj=UpdateXml()

#obj.updateXmlPTP()




