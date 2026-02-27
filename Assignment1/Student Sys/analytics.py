def top_student(students):
    return max(students, key=lambda s: s.grade_average(), default=None)

def lowest_student(students):
    return min(students, key=lambda s: s.grade_average(), default=None)

def rank_students(students):
    return sorted(students, key=lambda s: s.grade_average(), reverse=True)

def grade_distribution(students):
    dist = {}
    for s in students:
        cat = s.grade_category()
        dist[cat] = dist.get(cat, 0) + 1
    return dist