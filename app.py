from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# Set up MySQL connection
db = mysql.connector.connect(
    host="host.docker.internal",
    user="mj1",
    password="#Kinging16",
    database="todolist",
    port=3306
)
cursor = db.cursor()

@app.route('/')
def index():
    # Fetch tasks from the database
    cursor.execute("SELECT task FROM tasks")
    tasks = cursor.fetchall()
    return render_template('index.html', tasks=tasks)

@app.route('/add', methods=['POST'])
def add():
    task = request.form.get('task')
    # Insert the task into the database
    cursor.execute("INSERT INTO tasks (task) VALUES (%s)", (task,))
    db.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
