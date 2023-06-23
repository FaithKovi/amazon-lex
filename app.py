from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Store chat messages
messages = []

@app.route('/api/chatbot/messages', methods=['GET'])
def get_messages():
    return jsonify(messages)

@app.route('/api/chatbot/messages', methods=['POST'])
def send_message():
    message = request.json.get('message')
    if message:
        # Process the message, interact with the chatbot, etc.
        # Here, we simply add the message to the list of messages
        messages.append({'from': 'user', 'text': message})
        messages.append({'from': 'chatbot', 'text': 'This is a sample response.'})
        return jsonify({'success': True})
    else:
        return jsonify({'success': False, 'error': 'No message provided.'})






# @app.route('/')
# def index():
#     return render_template('index.html', messages=messages)

# @app.route('/send', methods=['POST'])
# def send():
#     message = request.form['message']
#     messages.append(('User', message))
#     response = get_chatbot_response(message)
#     messages.append(('ChatBot', response))
#     return jsonify({'response': response})

# def get_chatbot_response(message):
#     # Replace this with your chatbot logic
#     # Here's a simple example that just echoes the user's message
#     return 'You said: ' + message

if __name__ == '__main__':
    app.run(debug=True)
