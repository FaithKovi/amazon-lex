// App.js
import React, { useState, useEffect, useRef } from 'react';
import axios from 'axios';
import './App.css';

const App = () => {
  const [messages, setMessages] = useState([]);
  const [inputValue, setInputValue] = useState('');
  const messageListRef = useRef(null);

  useEffect(() => {
    // Fetch initial chatbot messages
    fetchChatbotMessages();
  }, []);
  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    if (messageListRef.current) {
      messageListRef.current.scrollTop = messageListRef.current.scrollHeight;
    }
  };


  const fetchChatbotMessages = async () => {
    try {
      const response = await axios.get('http://localhost:5000/api/chatbot/messages');
      setMessages(response.data);
    } catch (error) {
      console.error(error);
    }
  };
  

  const sendMessage = async () => {
    if (!inputValue) return;
  
    try {
      await axios.post('http://localhost:5000/api/chatbot/messages', { message: inputValue });
      fetchChatbotMessages();
      setInputValue('');
    } catch (error) {
      console.error(error);
    }
  };
  

  return (
    <div className="app">
      <div className="chat-container">
        <div className="message-list" ref={messageListRef}>
          {messages.map((message, index) => (
            <div key={index} className={`message ${message.from === 'user' ? 'user' : 'chatbot'}`}>
              {message.text}
            </div>
          ))}
        </div>
        <div className="input-container">
          <input
            type="text"
            placeholder="Type your message..."
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
          />
          <button onClick={sendMessage}>Send</button>
        </div>
      </div>
    </div>
  );
};

export default App;
