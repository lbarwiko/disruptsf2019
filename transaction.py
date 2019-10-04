# env FLASK_APP=transaction.py flask run

from flask import Flask
import pandas as pd
import numpy as np
import random
import json

app = Flask(__name__)

@app.route("/transactionData")

def transactionData(upto=23):
    
    dumdum = []
    random.seed(5)
    for j in range(0,24):
        dum = []
        for i in range(0,31):
            r = np.random.randint(0,200)
            dum.append(r) 
        dumdum.append(np.cumsum(dum))

    test = pd.DataFrame(np.array(dumdum))
    income = 4000
    
    return json.dumps({'spending':test.mean()[:upto].values.tolist(),
            'income':income,
            'cateogories':{'Clothing': 7, 'Fast Food': 23, 'Restaurants':10, 'Parking':8, 
                           'Groceries':22, 'Shopping':18, 'Pets':12}})

@app.route("/decision")
def decision(cost=500, upto=23):
    dumdum = []
    random.seed(5)
    for j in range(0,24):
        dum = []
        for i in range(0,30):
            r = np.random.randint(0,200)
            dum.append(r) 
        dumdum.append(np.cumsum(dum))

    test = pd.DataFrame(np.array(dumdum))

    saving = 500
    income = 4000
    loan = 900
    
    remain = saving + income - loan - test.mean()[len(test.mean())-1] - cost
    risk = saving + income - loan - (test.mean()+test.std())[len(test.mean())-1] - cost
    if (remain > 0) and (risk < 0):
        decision = {'decision': "Be cautious", 'reason':"You will likely over spend this month by -$" + str(abs(risk)) + "."}
    elif (remain > 0) and (risk > 0):
        decision = {'decision':"Yes", 'reason':"You will likely still have $"+ str(remain) +" left by the end of the month."}
    elif (remain < 0):
        decision = {'decision':"No", 'reason':"You will likely add -$"+str(abs(remain))+" amount of debt at the end of the month."}
    
    return json.dumps({'spending':test.mean()[:upto].values.tolist(),
            'income':4000,
            'decision': decision,
            'projection': (test.mean()[upto:].values + cost).tolist(),
            'cateogories':{'Clothing': 7, 'Fast Food': 23, 'Restaurants':10, 'Parking':8, 
                           'Groceries':22, 'Shopping':18, 'Pets':12}})