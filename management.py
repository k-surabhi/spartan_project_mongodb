import json
from spartan import Spartan
from pymongo import MongoClient


class SpartanManagement:
    DATA_FILE_NAME = "data.json"
    DATA_FILE_READ_MODE = "r"
    DATA_FILE_WRITE_MODE = "w+"
    db=""

    Spartan_Trainees_Dict = {}

    def __init__(self):
        try:
            with open(self.DATA_FILE_NAME, self.DATA_FILE_READ_MODE) as data_file:
                self.Spartan_Trainees_Dict = json.load(data_file)
        except:
            pass


        try:
            self.client = MongoClient("mongodb://10.1.0.4:27017")
            self.db = self.client.spartandb
        except Exception as e:
            print("trying to create a connection to the database")

        
        print("hello")
        
    def add_trainee(self, id, f_name, l_name, b_year, b_month, b_day, course, stream):

        try:
            s = Spartan()
            s.spartan_id = id
            s.first_name = f_name
            s.last_name = l_name
            s.birth_year = b_year
            s.birth_month = b_month
            s.birth_day = b_day
            s.course = course
            s.stream = stream

            self.Spartan_Trainees_Dict = s.__dict__

            self.__update_json()
            self.db.employees.insert_one(self.Spartan_Trainees_Dict)
            #Database.insert(id, self.Spartan_Trainees_Dict)
            return "SUCCESS"

        except Exception as ex:
            print(str(ex))
            return str(ex)

    def remove_trainee(self, id):

        try:
            #self.Spartan_Trainees_Dict.pop(id, None)
            #self.__update_json()
            if not self.db.employees.find_one({"spartan_id": id}):
                    return "Error, ID not in database"
            self.db.employees.delete_one({"spartan_id" : id})
            return "SUCCESS"
        except Exception as ex:
            print(str(ex))
            return str(ex)

    def get_trainee(self, id):

        try:
            with open(self.DATA_FILE_NAME, self.DATA_FILE_READ_MODE) as data_file:
                self.Spartan_Trainees_Dict = json.load(data_file)
            if id in self.Spartan_Trainees_Dict:
                return str(self.Spartan_Trainees_Dict[id])
            else:
                return "The spartan id is not valid."

        except Exception as ex:
            print(str(ex))
            return str(ex)

    def get_trainees(self):

        try:
            #return list(self.Spartan_Trainees_Dict.values())
            documents = self.db.employees.find()
            response_list = []
            for document in documents:
                document['_id'] = str(document['_id'])
                response_list.append(document)
            return json.dumps(response_list)
        except Exception as ex:
            print(str(ex))
            return str(ex)

    def __update_json(self):

        try:
            with open(self.DATA_FILE_NAME, self.DATA_FILE_WRITE_MODE) as jsonfile:
                jsonfile.seek(0)
                json.dump(self.Spartan_Trainees_Dict, jsonfile, default=lambda o: o.__dict__, indent=4)
                jsonfile.truncate()

            return "SUCCESS"

        except Exception as ex:
            print(str(ex))
            return str(ex)


