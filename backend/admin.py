import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate('path/to/credentials.json/')


from firebase_admin import db

ref = db.reference
