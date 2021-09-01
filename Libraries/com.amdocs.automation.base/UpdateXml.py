from random import randrange


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

        with open('C:/Users/amberb/PycharmProjects/Halo-Gamma/xmls/requests/notifyRequest.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{sorId}',sorid)
            contents = contents.replace('{proId}', strProj)
            contents = contents.replace('{orderType}', orderType)
            contents = contents.replace('{aType}', type2)

        # write to a file
        with open('C:/Users/amberb/PycharmProjects/Halo-Gamma/xmls/requests/notifyRequest.xml', "w") as write_file:
            write_file.write(contents)

        print(sorid)
        a.append(sorid)
        a.append(strProj)
        return a


    def getSorProjId(self):
        return a

    def pushDecomposeXml(self,b):
        self.b=b

        # read from a file

        with open('C:/Users/amberb/PycharmProjects/Halo-Gamma/xmls/requests/decomposeSalesOrderRequest.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{$sorId$}',b[0])
            contents = contents.replace('{$projId$}',b[1])


        # write to a file
        with open('C:/Users/amberb/PycharmProjects/Halo-Gamma/xmls/requests/decomposeSalesOrderRequest.xml', "w") as write_file:
            write_file.write(contents)

    def updateMorSg(self, acsmOrderId,mismOrderid,sorid,strProj,sgId):
        self.acsmOrderId = acsmOrderId
        self.mismOrderid = mismOrderid
        self.sorid = sorid
        self.strProj = strProj
        self.sgId = sgId
        with open('C:/Users/amberb/PycharmProjects/Halo-Gamma/xmls/requests/MOR_SG_OLD.txt', "rt") as read_file:
            contents = read_file.read()
            contents = contents.replace('{$sorId$}', sorid)
            contents = contents.replace('{$projId$}', strProj)
            contents = contents.replace('{$sgId$}', sgId)
            contents = contents.replace('{$oaIdAc$}', acsmOrderId)
            contents = contents.replace('{$oaId$}', mismOrderid)

        # write to a file
        with open('C:/Users/amberb/PycharmProjects/Halo-Gamma/xmls/requests/MOR_SG_OLD.xml', "w") as write_file:
            write_file.write(contents)