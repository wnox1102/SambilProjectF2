import ssl
import sys
import json
import random
import time
import paho.mqtt.client as mqtt
import paho.mqtt.publish
import numpy as np
import datetime
import psycopg2 as psy
import pandas as pd

conn=psy.connect(host = 'localhost', user= 'postgres', password ='caballoalfabetico', dbname= 'Sambil')

knownPeople = []
peopleInside = []
peopleSitting = []
peopleInStore = []

#Aux lists for car's simulation
parkingCars = []
queueDrivers = []
knownCars = []

def on_connect():
    print("Pub connected!")

def main():
    client = mqtt.Client("Publisher", False)
    client.qos = 0
    client.connect(host="localhost")

    #Database variables
    numAccess = queryNumAccess()
    storeBeaconID = queryStoreBeaconID()
    tableBeaconID = queryTableBeaconID()
    currentTime = datetime.datetime.now().replace(hour=8, minute=0)

    days = 31

    #The main loop!
    while(days > 0):
        #This is while the mall is still open
        while(currentTime.hour < 22):
            if(int(np.random.uniform(0,3)) == 0): #Get some car in
                pubCarEntrance(client, currentTime)
            if(int(np.random.uniform(0,2)) != 0):
                pubEntrance(client,numAccess,currentTime)
                currentTime = currentTime + datetime.timedelta(minutes=1)
            if(int(np.random.uniform(0,3)) == 0):
                pubStores(client,storeBeaconID,currentTime)
                print()
            if(int(np.random.uniform(0,3)) == 0):
                pubTables(client,tableBeaconID,currentTime)
                currentTime = currentTime + datetime.timedelta(minutes=1)

            currentTime = currentTime + datetime.timedelta(minutes=6)
            #time.sleep(0.2)

        #At this point, the mall is closing and we start to get people out 
        while((len(peopleInside) + len(peopleInStore) + len(peopleSitting) + len(parkingCars)) > 0):
            ran = np.random.uniform(0, len(peopleInside))
            while(ran > 0):
                cameraID = int(np.random.uniform(1 , numAccess - 1))
                payload = leavingMall(cameraID, currentTime)

                if(payload["time"] != "null"):
                    client.publish("Sambil/Camaras/Salida", json.dumps(payload), qos=0)
                    print("Saliendo  (C.C.)   --> ", end='')
                    print(payload)
                ran -= 1

            ran = np.random.uniform(0, len(parkingCars))
            while(ran > 0):
                data = drivingOut(currentTime)
                payload = data[0]
                payload2 = data[1]

                if(payload["time"] != "null"):
                    print("Saliendo  (C.C.)   --> ", end='')
                    print(payload)
                    client.publish("Sambil/Camaras/Saliendo", json.dumps(payload), qos=0)

                    print("Saliendo  (C.C.)   --> ", end='')
                    print(payload2)
                    client.publish("Sambil/Estacionamiento/Saliendo", json.dumps(payload2), qos=0)

                ran -= 1

            ran = np.random.uniform(0, len(peopleSitting))
            while(ran > 0):
                tableUser = stadingUp()

                payload = {
                    "beaconID": str(tableUser[1]),
                    "macAddress": str(tableUser[0][0]),
                    "time": str(currentTime)
                }

                client.publish("Sambil/Mesa/Parado", json.dumps(payload), qos=0)
                print("Parado  (Mesa)   --> ", end='')
                print(payload)
                ran -= 1

            ran = np.random.uniform(0, len(peopleInStore))
            while(ran > 0):
                storeUser = leavingStore(client, currentTime)

                payload = {
                    "beaconID": str(storeUser[1]),
                    "macAddress": str(storeUser[0][0]),
                    "time": str(currentTime)
                }
                currentTime += datetime.timedelta(minutes=5)

                if(storeUser[0] != "null"): #Beacons only detect users with smartphones
                    client.publish("Sambil/Tienda/Saliendo", json.dumps(payload), qos=0)
                
                print("Saliendo  (Tienda)   --> ", end='')
                print(payload)
                ran -= 1

            #time.sleep(0.1)
        days -= 1
        currentTime = datetime.timedelta(days=1) + currentTime.replace(hour=8, minute=0)


#Publisher's Methods
def pubEntrance(client, numAccess, currentTime):
    cameraID = int(np.random.uniform(1 , numAccess - 1))

    if((int(np.random.uniform(0,3)) != 1) or (len(peopleInside) == 0)):
        if(int(np.random.uniform(0,5)) == 1 and len(knownPeople) > 0): #Random to get someone known inside
            payload = enteringMallAgain(cameraID, currentTime)
        else:
            payload = enteringMall(cameraID, currentTime)
        topic = "Entrada"
    else:
        payload = leavingMall(cameraID, currentTime)
        topic = "Salida"

    if(payload["time"] != "null"):
        client.publish("Sambil/Camaras/" + topic, json.dumps(payload), qos=0)
        print(topic + "  (C.C.)   --> ", end='')
        print(payload)

def pubCarEntrance(client, currentTime):
    if((int(np.random.uniform(0,3)) != 1) or (len(parkingCars) == 0)):
        if((int(np.random.uniform(0,5) == 0) and (len(knownPeople) > 0))): #Probably you know the person
            data = knownDrivingIn(currentTime)
            payload = data[0]
            payload2 = data[1]
            newCar = data[2]
        else:
            newCar = True
            payload = drivingIn(currentTime)

            ran = np.random.uniform(1,5)
            currentTime += datetime.timedelta(minutes=ran)

            payload2 = enteringMall(4, currentTime)
            
        #Validation to see if there is really someone parking
        if(payload["time"] != "null"):
            print("Entrando  (C.C.)   --> ", end='')
            print(payload)
            client.publish("Sambil/Estacionamiento/Entrada", json.dumps(payload), qos=0)

            print("Entrando  (C.C.)   --> ", end='')
            print("-----------------------------------------------------------------------------------------------------")
            print(payload2)
            print("-----------------------------------------------------------------------------------------------------")

            client.publish("Sambil/Camaras/Entrada", json.dumps(payload2), qos=0)

            driver = [payload2["macAddress"], payload2["gender"], int(payload2["age"])]

            #This is like "parking" the car inside a list
            parkingCars[len(parkingCars)-1].append(driver)

            if(driver[0] != "null" and newCar):
                knownCars.append([payload["numberPlate"], driver[0]])
    
    else:
        data = drivingOut(currentTime)
        payload = data[0]
        payload2 = data[1]

        if(payload["time"] != "null"):
            print("Saliendo  (C.C.)   --> ", end='')
            print(payload)
            client.publish("Sambil/Camaras/Saliendo", json.dumps(payload), qos=0)

            print("Saliendo  (C.C.)   --> ", end='')
            print(payload2)
            client.publish("Sambil/Estacionamiento/Saliendo", json.dumps(payload2), qos=0)

def pubStores(client, storeBeaconID, currentTime):
    if(len(peopleInside) > 0):

        if(int(np.random.uniform(0,3)) == 1 and len(peopleInStore) > 0): #Get someone out of store
            storeUser = leavingStore(client, currentTime)
            topic = "Saliendo"

        else: #Get someone in
            storeUser = enteringStore(storeBeaconID)
            topic = "Entrando"
        
        payload = {
            "beaconID": str(storeUser[1]),
            "macAddress": str(storeUser[0][0]),
            "time": str(currentTime)
        }

        if(storeUser[0] != "null"): #Beacons only detect users with smartphones
            client.publish("Sambil/Tienda/" + topic, json.dumps(payload), qos=0)

        print(topic + " (Tienda) --> ", end='')
        print(payload)

def pubTables(client, tableBeaconID, currentTime):
    if(len(peopleInside) > 0):

        if(int(np.random.uniform(0,3)) == 1 and len(peopleSitting) > 0):
            tableUser = stadingUp()
            topic = "Parado"
        else:
            tableUser = sitting(tableBeaconID)
            topic = "Sentado"

        payload = {
            "beaconID": str(tableUser[1]),
            "macAddress": str(tableUser[0][0]),
            "time": str(currentTime)
        }

        print(topic + "   (Mesa)   --> ", end='')
        print(payload)

        client.publish("Sambil/Mesa/" + topic, json.dumps(payload), qos=0)

def pubSales(client, buyer, currentTime):
    if(int(np.random.uniform(0,1)) == 0):
        avgPrice = 150
        stdPrice = 100

        price = round(np.random.normal(avgPrice, stdPrice),2)
        while(price <= 0):
            price = round(np.random.normal(avgPrice, stdPrice),2)

        payload = buying(buyer, price, currentTime)

        if(buyer[0] != "null" and len(buyer[0]) == 3):
            counter = 0
            while(counter < len(knownPeople)):
                if(buyer[0][0] == knownPeople[counter][0]):
                    knownPeople[counter].append(payload["personID"])
                    knownPeople[counter].append(payload["name"])
                    knownPeople[counter].append(payload["lastname"])
                    break
                counter += 1

        print("Compra   (Tienda)   --> ", end='')
        print(payload)

        client.publish("Sambil/Tienda/Compra", json.dumps(payload), qos=0)


#People's Actions
def enteringMall(cameraID, currentTime):
    gender = int(np.random.uniform(0, 2))

    if(gender == 1):
        gender = "M"
    else:
        gender = "F"

    minAge = 0
    if(cameraID == 4):
        macAddress = queueDrivers.pop()
        minAge = 18
    elif(int(np.random.uniform(0,4)) != 1):
        macAddress = str(getMacAddress())
        minAge = 9
    else:
        macAddress = "null"

    age = int(np.random.normal(35,15))

    while((age < minAge) or (age > 90)):
        age = int(np.random.normal(35,15))

    person = [macAddress,gender,age]

    payload = {
        "cameraID": str(cameraID),
        "gender": str(person[1]),
        "age": str(person[2]),
        "macAddress": str(person[0]),
        "time": str(currentTime)
    }
    
    peopleInside.append(person)

    if(macAddress != "null"):
        knownPeople.append(person)

    return payload

def leavingMall(cameraID, currentTime):
    people = peopleInside[int(np.random.uniform(0, len(peopleInside)))]

    counter = 0
    hasACar = False
    while(counter < len(parkingCars)):
        print(parkingCars[counter])
        if((people[0] == parkingCars[counter][1][0]) and (people[1] == parkingCars[counter][1][1]) and (people[2] == parkingCars[counter][1][2])):
            hasACar = True
            break
        counter += 1

    if(hasACar):
        print(people)
        currentTime = "null"
    else:
        peopleInside.remove(people)

    payload = {
        "cameraID": str(cameraID),
        "macAddress": str(people[0]),
        "time": str(currentTime)
    }
    
    return payload

def enteringMallAgain(cameraID, currentTime):
        person = random.choice(knownPeople)
        counter = 0
        gettingKnownPeople = True

        while(counter < len(peopleInside) or counter < len(peopleInStore) or counter < len(peopleSitting)):
            if(counter < len(peopleInside)):
                if(person[0] == peopleInside[counter][0]):
                    gettingKnownPeople = False
                    break

            if(counter < len(peopleInStore)):
                if(person[0] == peopleInStore[counter][0][0]):
                    gettingKnownPeople = False
                    break

            if(counter < len(peopleSitting)):
                if(person[0] == peopleSitting[counter][0][0]):
                    gettingKnownPeople = False
                    break
            counter += 1
            
            
        if(gettingKnownPeople):
            peopleInside.append(person)
        else:
            currentTime = "null"

        payload = {
            "cameraID": str(cameraID),
            "gender": str(person[1]),
            "age": str(person[2]),
            "macAddress": str(person[0]),
            "time": str(currentTime)
        }

        return payload

def enteringStore(storeBeaconID):
    beaconID = random.choice(storeBeaconID)

    ran = int(np.random.uniform(0, len(peopleInside)))
    storeUser = [peopleInside[ran], beaconID]

    peopleInside.remove(storeUser[0])
    peopleInStore.append(storeUser)

    return storeUser

def leavingStore(client, currentTime):
    storeUser = random.choice(peopleInStore)

    #Possible sale before getting out
    pubSales(client, storeUser, currentTime)

    peopleInStore.remove(storeUser)
    peopleInside.append(storeUser[0])

    return storeUser

def buying(buyer, price, currentTime):
    if(len(buyer[0])==3):
        correctData = False

        while(not correctData):
            personData = random.choice(dataPeople)
            if(buyer[0][1] == personData["gender"]):
                correctData = True
                age = buyer[0][2]
                personID = getPersonID(age)
        
        name = personData["first_name"]
        lastname = personData["last_name"]
    else:
        personID = buyer[0][3]
        name = buyer[0][4]
        lastname = buyer[0][5]

    #Case for random ID
    if(int(np.random.uniform(0,1)) == 0):
        randomPerson = random.choice(knownPeople)
        counter = 0
        inside = False
        while(counter < len(peopleInside)):
            if(randomPerson[0] == peopleInside[counter][0]):
                inside = True
            counter += 1
        if(len(randomPerson) > 3 and (not inside)):
            personID = randomPerson[3]

    payload = {
        "beaconID": str(buyer[1]),
        "macAddress": str(buyer[0][0]),
        "name": str(name),
        "lastname": str(lastname),
        "personID": str(personID),
        "time": str(currentTime),
        "price": str(price)
    }

    return payload

def sitting(tableBeaconID):
    beaconID = random.choice(tableBeaconID)

    ran = int(np.random.uniform(0, len(peopleInside)))
    tableUser = [peopleInside[ran], beaconID]
    peopleInside.remove(tableUser[0])

    peopleSitting.append(tableUser)

    return tableUser

def stadingUp():
    tableUser = random.choice(peopleSitting)
    peopleSitting.remove(tableUser)
    peopleInside.append(tableUser[0])

    return tableUser

def drivingIn(currentTime):

    if(int(np.random.uniform(0,201)) != 0):
        numberPlate = getNumberPlate()
    else:
        numberPlate = "null"

    if(int(np.random.uniform(0,4)) != 1):
        macAddress = str(getMacAddress())
    else:
        macAddress = "null"

    parkingCars.append([numberPlate])
    queueDrivers.append(macAddress)
    
    payload = {
        "numberPlate": str(numberPlate),
        "macAddress": str(macAddress),
        "time": str(currentTime)
    }

    return payload

def knownDrivingIn(currentTime):
    print("Known people in car is coming")
    newCar = False
    if(np.random.uniform(0,4) != 0): #A person who already has come with a car
        data = random.choice(knownCars)
        person = []
        counter = 0
        while(counter < len(knownPeople)):
            if(data[1][0] == knownPeople[counter][0]):
                person = knownPeople[counter]
                break
            counter += 1
        
        
        
        if(np.random.uniform(0,20)): #They could have another car
            numberPlate = getNumberPlate()
            newCar = True
        else:
            numberPlate = data[0]

    else: #Probably hasn't come with its car... Yet
        person = random.choice(knownPeople)
        numberPlate = getNumberPlate()
        newCar = True

    gettingKnownPeople = True
    while(counter < len(peopleInside) or counter < len(peopleInStore) or counter < len(peopleSitting)):
        if(counter < len(peopleInside)):
            if(person[0] == peopleInside[counter][0]):
                gettingKnownPeople = False
                break

        if(counter < len(peopleInStore)):
            if(person[0] == peopleInStore[counter][0][0]):
                gettingKnownPeople = False
                break

        if(counter < len(peopleSitting)):
            if(person[0] == peopleSitting[counter][0][0]):
                gettingKnownPeople = False
                break
        counter += 1

    payload = {
        "numberPlate": str(numberPlate),
        "macAddress": str(person[0]),
        "time": str(currentTime)
    }

    ran = np.random.uniform(1,5)
    currentTime += datetime.timedelta(minutes=ran)
    payload2 = {
        "cameraID": "4",
        "gender": str(person[1]),
        "age": str(person[2]),
        "macAddress": str(person[0]),
        "time": str(currentTime)
    }
    
    if(not gettingKnownPeople):
        payload["time"] = "null"

    personData = [payload, payload2, newCar]
    return personData

def drivingOut(currentTime):
    counterPeople = 0
    person = []
    dataInside = []
    while(counterPeople < len(parkingCars)):
        available = False
        person = random.choice(parkingCars)
        counter = 0
        while(counter < len(peopleInside)):
            if(person[1][0] == peopleInside[counter][0] and person[1][1] == peopleInside[counter][1] and person[1][2] == peopleInside[counter][2]):
                dataInside = peopleInside[counter]
                available = True
                break
            counter += 1

        if(available):
            break

        counterPeople += 1

    if(not available):
        currentTime = "null"
    else: 
        peopleInside.remove(dataInside)
        parkingCars.remove(person)

    payload = {
        "cameraID": "4",
        "macAddress": str(person[1][0]),
        "time": str(currentTime)
    }

    if(currentTime != "null"):
        ran = np.random.uniform(1,5)
        currentTime += datetime.timedelta(minutes=ran)

    payload2 = {
        "numberPlate": str(person[0]),
        "macAddress": str(person[1][0]),
        "time": str(currentTime)
    }

    data = [payload, payload2]
    return data


#Logical Methods
def getMacAddress():
    macAddress = ""
    counter = 0
    while(counter < 12):
        if(counter%2 != 1 and counter > 0):
            macAddress += ":"

        macAddress += str(random.choice('0123456789ABCDEF'))
        counter += 1

    return macAddress

def getPersonID(age):
    if(age > 70):
        personID = int(np.random.uniform(3000000,600000))
    elif(age <= 70 and age >= 61):
        personID = int(np.random.uniform(7000000,3000000))
    elif(age <= 60 and age >= 51):
        personID = int(np.random.uniform(9000000,7000000))
    elif(age <= 50 and age >= 41):
        personID = int(np.random.uniform(12000000,9000000))
    elif(age <= 40 and age >= 31):
        personID = int(np.random.uniform(15000000,12000000))
    elif(age <= 30 and age >= 21):
        personID = int(np.random.uniform(26000000,15000000))
    elif(age <= 20 and age >= 16):
        personID = int(np.random.uniform(30000000,26000000))      
    elif(age <= 15 and age >= 8):
        personID = int(np.random.uniform(36000000,30000000))
    else:
        personID = 0

    return personID

def getNumberPlate():
    numberPlate = ""
    counter = 0
    while(counter < 7):
        if(counter > 1 and counter < 5):
            numberPlate += str(random.choice('0123456789'))
        else:
            numberPlate += str(random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZ'))
        counter += 1
    return numberPlate

def getJsonData():
    with open('database.json') as json_file:  
        data = json.load(json_file)
        
    return data['nombres']

dataPeople = getJsonData()


#Query Methods
def queryNumAccess():
    sql='''SELECT *  
    FROM public.models_camara;'''
    df = pd.read_sql_query(sql, conn)
    camaras = df.count()[0]

    return camaras

def queryStoreBeaconID():
    sql='''select b."id" from models_beacon as b
    inner join models_tienda as t on t."fkbeacon_id"=b."id"'''
    df = pd.read_sql_query(sql, conn)
    Lista = []
    for index, row in df.iterrows():
        Lista.insert(index, row["id"])
    print(Lista)

    return Lista
    
def queryTableBeaconID():
    sql='''select b."id" from models_beacon as b
    inner join models_mesa as t on t."fkbeacon_id"=b."id"'''
    df = pd.read_sql_query(sql, conn)
    Lista = []
    for index, row in df.iterrows():
        Lista.insert(index, row["id"])
    print(Lista)

    return Lista

if __name__ == "__main__":
    main()
