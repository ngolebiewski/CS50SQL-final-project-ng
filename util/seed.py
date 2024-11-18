import sqlite3
from faker import Faker

fake = Faker()
Faker.seed(5151)
print(fake.name())

user_seeds = {}
for i in range(20):
    first = fake.first_name()
    last = fake.last_name()
    username = first[1] + last
    user_seeds[i] = {
        "first_name": first,
        "last_name": last,
        "username": username,
        "password": fake.password(),
        "mobile": fake.phone_number(),
        "email": fake.ascii_email(),
    } 
    
for n in user_seeds:
    print(user_seeds[n])
        #   , n["first_name"],n["last_name"],n["username"],n["password"], n["mobile"], n["email"])
    
# How to connect to sqlite3 database https://docs.python.org/3/library/sqlite3.html#sqlite3-tutorial
con = sqlite3.connect("../project/tourbiz.db")
cur = con.cursor()

cur.execute("""
    INSERT INTO "users" ("first_name","last_name","username","password","mobile","email")
    VALUES ('Nick', 'Nack', 'nicknack','pizza1234','123-456-7890','x@nicknack.nyc')
            """)


response = cur.execute("SELECT * FROM USERS")
print(response.fetchall())

con.close()
