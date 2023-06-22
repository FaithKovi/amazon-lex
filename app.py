from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# Store chat messages
messages = []

@app.route('/')
def index():
    return render_template('index.html', messages=messages)

@app.route('/send', methods=['POST'])
def send():
    message = request.form['message']
    messages.append(('User', message))
    response = get_chatbot_response(message)
    messages.append(('ChatBot', response))
    return jsonify({'response': response})

def get_chatbot_response(message):
    # Replace this with your chatbot logic
    # Here's a simple example that just echoes the user's message
    return 'You said: ' + message

if __name__ == '__main__':
    app.run(debug=True)
