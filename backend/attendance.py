import sqlite3
from datetime import datetime

DATABASE = "attendance.db"


def mark_attendance(student_name):
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()

    today = datetime.now().strftime("%Y-%m-%d")
    now = datetime.now().strftime("%H:%M:%S")

    cursor.execute(
        """
        SELECT * FROM attendance
        WHERE student_name = ? AND attendance_date = ?
        """,
        (student_name, today)
    )

    existing = cursor.fetchone()

    if existing:
        print(f"{student_name} already marked today.")
    else:
        cursor.execute(
            """
            INSERT INTO attendance
            (student_name, attendance_date, attendance_time, status)
            VALUES (?, ?, ?, ?)
            """,
            (student_name, today, now, "Present")
        )

        conn.commit()
        print(f"{student_name} attendance saved.")

    conn.close()


if __name__ == "__main__":
    mark_attendance("shuvo")