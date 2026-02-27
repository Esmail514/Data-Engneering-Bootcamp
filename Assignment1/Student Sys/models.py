class Student():
    def __init__(self, student_id, name, grades=None):
        if grades is None:
            grades = []
        self.student_id = int(student_id)
        self.name = name
        self.grades = [int(g) for g in grades]

    def grade_average(self):
        if len(self.grades) == 0:
            return 0
        return sum(self.grades) / len(self.grades)
    
    def grade_category(self):
        avg = self.grade_average()
        if 90 <= avg <= 100:
            return "A"
        elif 80 <= avg < 90:
            return "B"
        elif 70 <= avg < 80:
            return "C"
        elif 60 <= avg < 70:
            return "D"
        elif 0 <= avg < 60:
            return "F"
        else:
            return "Invalid"

class Classroom():
    def __init__(self):
        self.__students = []
        
    def add_student(self, student):
        self.__students.append(student)
        
    def remove_student(self, student_id):
        self.__students = [s for s in self.__students if s.student_id != student_id]
  
    def search_student(self, student_id):
        for s in self.__students:
            if s.student_id == student_id:
                return s
        return None

    def classroom_average(self):
        if not self.__students:
            return 0
        total = sum([s.grade_average() for s in self.__students])
        return total / len(self.__students)