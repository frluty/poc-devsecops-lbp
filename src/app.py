from flask import Flask, request
import sqlite3

app = Flask(__name__)

@app.route('/user')
def get_user():
    # Vulnérabilité 1 — Injection SQL
    user_id = request.args.get('id')
    conn = sqlite3.connect('users.db')
    cursor = conn.execute(
        f"SELECT * FROM users WHERE id = {user_id}"
    )
    return str(cursor.fetchall())

@app.route('/file')
def read_file():
    # Vulnérabilité 2 — Path traversal
    filename = request.args.get('name')
    with open(f"/var/data/{filename}") as f:
        return f.read()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
