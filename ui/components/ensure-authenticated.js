import { Component, h } from 'preact';
import linkState from 'linkstate';

import fetch from '../utils/fetch';

export default class EnsureAuthenticatedComponent extends Component {
  constructor() {
    super();

    this.state = {
      isAuthenticated: false,
      password: ''
    };
  }

  componentWillMount() {
    this.checkAuthenticated(sessionStorage.getItem('password'));
  }

  checkAuthenticated(password) {
    if (typeof password !== 'string') {
      password = this.state.password;
    }

    return fetch('/api/authenticated', {
      headers: {
        'serv-password': password
      }
    }).then(res => {
      this.setState({
        isAuthenticated: res.ok,
        password
      });

      sessionStorage.setItem('password', password);
    });
  }

  render({ children }, { isAuthenticated, password }) {
    const checkAuthenticated = this.checkAuthenticated.bind(this);

    if (isAuthenticated) {
      return <div>{children}</div>;
    } else {
      return (
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            minHeight: isAuthenticated ? 'auto' : '100vh'
          }}
        >
          <h1>Serv</h1>
          <div class="input-group" style={{ maxWidth: '300px' }}>
            <input
              type="text"
              class="form-control"
              value={password}
              placeholder="Password"
              onKeyUp={linkState(this, 'password')}
            />
            <span class="input-group-btn">
              <button
                class="btn btn-primary"
                type="button"
                onClick={checkAuthenticated}
              >
                Log In
              </button>
            </span>
          </div>
        </div>
      );
    }
  }
}
