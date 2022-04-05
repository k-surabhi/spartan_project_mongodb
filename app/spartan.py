from pickle import FALSE
import unittest

class Spartan:
    
    def __init__(self):
        self._spartan_id = 0
        self._first_name = ""
        self._last_name = ""
        self._birth_year = 1900
        self._birth_month = 1
        self._birth_day = 1
        self._course = ""
        self._stream = ""

    @property
    def spartan_id(self):
        return self._spartan_id
    
    @spartan_id.setter
    def spartan_id(self, id):
        if isinstance(id, int) and id > 0:
            self._spartan_id = id
        else:
            raise ValueError("Spartan Id must be a non-negetive integer value.")

    @property
    def first_name(self):
        return self._first_name
    
    @first_name.setter
    def first_name(self, name):
        if isinstance(name, str) and len(name.strip()) > 1:
            self._first_name = name
        else:
            raise ValueError("First name must be a string value with minimum 2 characters.")

    @property
    def last_name(self):
        return self._last_name
    
    @last_name.setter
    def last_name(self, name):
        if isinstance(name, str) and len(name.strip()) > 1:
            self._last_name = name
        else:
            raise ValueError("Last name must be a string value with minimum 2 characters.")

    @property
    def birth_year(self):
        return self._birth_year
    
    @birth_year.setter
    def birth_year(self, year):
        if isinstance(year, int) and year >= 1900 and year <= 2014:
            self._birth_year = year
        else:
            raise ValueError("Birth year should be in betweeb 1900 and 2014.")

    @property
    def birth_month(self):
        return self._birth_month
    
    @birth_month.setter
    def birth_month(self, month):
        if isinstance(month, int) and month >= 1 and month <= 12:
            self._birth_month = month
        else:
            raise ValueError("Birth month should be in betweeb 1 and 12.")

    @property
    def birth_day(self):
        return self._birth_day
    
    @birth_day.setter
    def birth_day(self, day):
        if isinstance(day, int) and day >= 1 and day <= 31:
            self._birth_day = day
        else:
            raise ValueError("Birth day should be in betweeb 1 and 31.")

    @property
    def course(self):
        return self._course
    
    @course.setter
    def course(self, c):
        if isinstance(c, str):
            self._course = c
        else:
            raise ValueError("Course should be a string.")

    @property
    def stream(self):
        return self._stream
    
    @stream.setter
    def stream(self, s):
        if isinstance(s, str):
            self._stream = s
        else:
            raise ValueError("Stream should be a string.")

    def __str__(self):
        return f"Spartan ID: {self.spartan_id} - First Name: {self.first_name} - Last Name: {self.last_name} - Birth Day: {self.birth_day} - Birth Month: {self.birth_month} - Birth year: {self.birth_year} - Course: {self.course} - Stream: {self.stream}"

class SpartanTest(unittest.TestCase):
    
    def test_spartan_basic(self):
        s = Spartan()
        s.spartan_id = 1
        s.first_name = "Test"
        s.last_name = "User"
        s.birth_year = 2009
        s.birth_month = 12
        s.birth_day = 2
        s.course = "Web"
        s.stream = "Computer"

        self.assertEqual(s.spartan_id, 1)
        self.assertEqual(s.first_name, "Test")
        self.assertEqual(s.last_name, "User")
        self.assertEqual(s.birth_year, 2009)
        self.assertEqual(s.birth_month, 12)
        self.assertEqual(s.birth_day, 2)
        self.assertEqual(s.course, "Web")
        self.assertEqual(s.stream, "Computer")

    def test_spartan_id(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.spartan_id = 0

        with self.assertRaises(ValueError):
            s.spartan_id = -1
        
        with self.assertRaises(ValueError):
            s.spartan_id = 1.1

        with self.assertRaises(ValueError):
            s.spartan_id = ""

        with self.assertRaises(ValueError):
            s.spartan_id = "  "
        
        with self.assertRaises(ValueError):
            s.spartan_id = "1"

    def test_first_name(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.first_name = 0

        with self.assertRaises(ValueError):
            s.first_name = -1
        
        with self.assertRaises(ValueError):
            s.first_name = 1

        with self.assertRaises(ValueError):
            s.first_name = ""
        
        with self.assertRaises(ValueError):
            s.first_name = "A"
                
        with self.assertRaises(ValueError):
            s.first_name = "A  "

        with self.assertRaises(ValueError):
            s.first_name = None

    def test_last_name(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.last_name = 0

        with self.assertRaises(ValueError):
            s.last_name = -1
        
        with self.assertRaises(ValueError):
            s.last_name = 1

        with self.assertRaises(ValueError):
            s.last_name = ""
        
        with self.assertRaises(ValueError):
            s.last_name = "A"
                
        with self.assertRaises(ValueError):
            s.last_name = "A  "

        with self.assertRaises(ValueError):
            s.last_name = None

    def test_birth_year(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.birth_year = 0
        
        with self.assertRaises(ValueError):
            s.birth_year = 1899

        with self.assertRaises(ValueError):
            s.birth_year = 2015
        
        with self.assertRaises(ValueError):
            s.birth_year = ""

        with self.assertRaises(ValueError):
            s.birth_year = "2009"

    def test_birth_month(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.birth_month = 0
        
        with self.assertRaises(ValueError):
            s.birth_month = -1

        with self.assertRaises(ValueError):
            s.birth_month = 1.1

        with self.assertRaises(ValueError):
            s.birth_month = 13
        
        with self.assertRaises(ValueError):
            s.birth_month = ""

        with self.assertRaises(ValueError):
            s.birth_month = "6"

    def test_birth_day(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.birth_day = 0
        
        with self.assertRaises(ValueError):
            s.birth_day = -1

        with self.assertRaises(ValueError):
            s.birth_day = 1.1

        with self.assertRaises(ValueError):
            s.birth_day = 32
        
        with self.assertRaises(ValueError):
            s.birth_day = ""

        with self.assertRaises(ValueError):
            s.birth_day = "6"

    def test_course(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.course = 0

        with self.assertRaises(ValueError):
            s.course = FALSE

        with self.assertRaises(ValueError):
            s.course = None

    def test_stream(self):
        s = Spartan()

        with self.assertRaises(ValueError):
            s.stream = 0

        with self.assertRaises(ValueError):
            s.stream = FALSE

        with self.assertRaises(ValueError):
            s.stream = None

if __name__ == "__main__":
   unittest.main()