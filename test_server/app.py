from flask import Flask, jsonify


app = Flask(__name__)


@app.route('/test')
def hello():
    return jsonify({'msg': 'hello'})


if __name__ == '__main__':
    app.run(host='0.0.0.0')
