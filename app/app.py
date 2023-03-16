from flask import Flask


app = Flask(__name__)


@app.route('/hola')
def hello_world():
    return 'Hola Mundo'


@app.route('/')
def root():
    return "I'm alive"


if __name__ == '__main__':
    app.run()

