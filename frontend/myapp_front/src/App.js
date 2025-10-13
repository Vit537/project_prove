//import logo from "./logo.svg";
import "./App.css";

// function App() {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.js</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// }

import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';

function App() {
  const [name, setName] = useState('');
  const [date, setDate] = useState('');
  const [people, setPeople] = useState([]);
  const [loading, setLoading] = useState(true);

  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

  // Función para cargar datos del backend (memoizada)
  const loadPeople = useCallback(async () => {
    try {
      const response = await axios.get(`${API_URL}/api/person/`);
      setPeople(response.data);
      setLoading(false);
    } catch (error) {
      console.error('Error loading people:', error);
      setLoading(false);
    }
  }, [API_URL]);

  // Cargar datos al iniciar la aplicación
  useEffect(() => {
    loadPeople();
  }, [loadPeople]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post(`${API_URL}/api/person/`, {
        name,
        date,
      });
      alert('Data saved successfully!');
      console.log(response.data);
      setName('');
      setDate('');
      // Recargar la lista después de guardar
      loadPeople();
    } catch (error) {
      console.error('Error saving ', error.response?.data || error.message);
      alert('Error saving data');
    }
  };

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial', maxWidth: '800px', margin: '0 auto' }}>
      <h1>📝 My Django + React App</h1>
      <p>Conectado con el backend en Google Cloud Run</p>
      
      {/* Formulario para agregar nuevos datos */}
      <div style={{ backgroundColor: '#f5f5f5', padding: '20px', borderRadius: '8px', marginBottom: '30px' }}>
        <h2>➕ Add New Person</h2>
        <form onSubmit={handleSubmit}>
          <div style={{ marginBottom: '15px' }}>
            <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Name:</label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
              style={{ width: '100%', padding: '8px', borderRadius: '4px', border: '1px solid #ddd' }}
            />
          </div>
          <div style={{ marginBottom: '15px' }}>
            <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Date:</label>
            <input
              type="date"
              value={date}
              onChange={(e) => setDate(e.target.value)}
              required
              style={{ width: '100%', padding: '8px', borderRadius: '4px', border: '1px solid #ddd' }}
            />
          </div>
          <button 
            type="submit"
            style={{ 
              backgroundColor: '#007bff', 
              color: 'white', 
              padding: '10px 20px', 
              border: 'none', 
              borderRadius: '4px',
              cursor: 'pointer',
              fontSize: '16px'
            }}
          >
            💾 Save
          </button>
        </form>
      </div>

      {/* Lista de personas guardadas */}
      <div>
        <h2>👥 Saved People ({people.length})</h2>
        {loading ? (
          <p>🔄 Loading...</p>
        ) : people.length === 0 ? (
          <p style={{ fontStyle: 'italic', color: '#666' }}>No people saved yet. Add some using the form above!</p>
        ) : (
          <div style={{ display: 'grid', gap: '10px' }}>
            {people.map((person, index) => (
              <div 
                key={person.id || index} 
                style={{ 
                  backgroundColor: '#fff', 
                  padding: '15px', 
                  border: '1px solid #ddd', 
                  borderRadius: '8px',
                  boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
                }}
              >
                <h3 style={{ margin: '0 0 10px 0', color: '#333' }}>👤 {person.name}</h3>
                <p style={{ margin: '0', color: '#666' }}>📅 {new Date(person.date).toLocaleDateString()}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

// export default App;

export default App;
