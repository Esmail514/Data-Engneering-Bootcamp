import csv
from models import Student

CSV_FILE = "student_data.csv"

def save_student(student):
    try:
        with open(CSV_FILE, mode='a', newline='') as file:
            writer = csv.writer(file)
            for g in student.grades:  
                writer.writerow([student.student_id, student.name, g])
    except Exception as e:
        print("Error in saving student:", e)

def load_students():
    students_dict = {}
    try:
        with open(CSV_FILE, mode='r', newline='') as file:
            reader = csv.DictReader(file, fieldnames=["Student_ID","Name","Grade"])
            for row in reader:
                sid = int(row["Student_ID"])
                name = row["Name"]
                grade = int(row["Grade"])
                if sid in students_dict:
                    students_dict[sid].grades.append(grade)
                else:
                    students_dict[sid] = Student(sid, name, [grade])
        return list(students_dict.values())
    except FileNotFoundError:
        return []

def validate_name(name):
    if not name or type(name) != str:
        raise ValueError("Name is required")

def validate_id(student_id):
    if student_id < 0:
        raise ValueError("ID must be positive")

def validate_grade(grade):
    if type(grade) != int or not (0 <= grade <= 100):
        raise ValueError("Grade must be 0-100")