import sqlite3
from faker import Faker

fake = Faker()
Faker.seed(5151)
print(fake.name())

user_seeds = {}
for i in range(20):
    first = fake.first_name()
    last = fake.last_name()
    username = first[0] + last
    user_seeds[i] = {
        "first_name": first,
        "last_name": last,
        "username": username,
        "password": fake.password(),
        "mobile": fake.phone_number(),
        "email": fake.ascii_email(),
    } 
    
# for n in user_seeds:
#     print(user_seeds[n])
        #   , n["first_name"],n["last_name"],n["username"],n["password"], n["mobile"], n["email"])
    
# How to connect to sqlite3 database https://docs.python.org/3/library/sqlite3.html#sqlite3-tutorial
con = sqlite3.connect("../project/tourbiz.db")
cur = con.cursor()

# cur.execute("""
#     INSERT INTO "users" ("first_name","last_name","username","password","mobile","email")
#     VALUES ('Nick', 'Nack', 'nicknack','pizza1234','123-456-7890','x@nicknack.nyc')
#             """)

for n in user_seeds:
    first_name = user_seeds[n]["first_name"]
    last_name = user_seeds[n]["last_name"]
    username = user_seeds[n]["username"]
    password = user_seeds[n]["password"]
    mobile = user_seeds[n]["mobile"]
    email = user_seeds[n]["email"]
    
    print(f"Adding {first_name} {last_name}")
    
    cur.execute("""
        INSERT INTO "users" ("first_name","last_name","username","password","mobile","email")
        VALUES (?,?,?,?,?,?)""",
        (first_name, last_name, username, password, mobile, email)
        )
    
response = cur.execute("SELECT * FROM USERS")
print(response.fetchall())
con.commit()
con.close()
