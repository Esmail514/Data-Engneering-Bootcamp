import models
import utils
import analytics

def menu():
    loop = True
    while loop:
        print("1- Add student")
        print("2- show students")
        print("3- top student")
        print("4- rank student")
        print("5- distribution")
        print("6- logout")

        choice = input("Choose: ")

        try:
            if choice == "1":
                student_id = int(input("Enter ID: "))
                name = input("Student name: ")
                grades_input = input("Enter grades (separated by comma): ")  
                grades = [int(g.strip()) for g in grades_input.split(",")]

                utils.validate_id(student_id)
                utils.validate_name(name)
                for g in grades:
                    utils.validate_grade(g)

                from models import Student
                student = Student(student_id, name, grades)
                utils.save_student(student)

            elif choice == "2":
                students = utils.load_students()
                for s in students:
                    print(f"{s.student_id} - {s.name} - Grades: {s.grades} - Avg: {s.grade_average()}")

            elif choice == "3":
                students = utils.load_students()
                top = analytics.top_student(students)
                if top:
                    print(f"Top: {top.name} - Avg: {top.grade_average()} - Grades: {top.grades}")
                else:
                    print("No students yet")

            elif choice == "4":
                students = utils.load_students()
                ranked = analytics.rank_students(students)
                for s in ranked:
                    print(f"{s.name}: {s.grades} - Avg: {s.grade_average()}")

            elif choice == "5":
                students = utils.load_students()
                dist = analytics.grade_distribution(students)
                print(dist)

            elif choice == "6":
                loop = False
                print("logout")
            else:
                print("Invalid choice")

        except Exception as e:
            print("Error:", e)

if __name__ == "__main__":
    menu()