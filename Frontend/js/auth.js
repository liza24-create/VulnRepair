// Specify the port for your backend (for Live Server) or leave it as '' (if running via `dotnet run`)
const API_URL = 'http://localhost:5106';

document.addEventListener('DOMContentLoaded', async () => {
// Locate authentication button in the site header
    const authLink = document.getElementById('authLink');
    const authImg = document.getElementById('authImg');
    const loginForm = document.getElementById('loginForm');
    const DashboardItem = document.getElementById('DashboardItem');
    const DashboardLink = document.getElementById('DashboardLink');

    let isLoggedIn = false;
    let userName = '';
    let displayName = '';

// 1. Ask the server (check cookies) whether the user is currently logged in
    try {
        const res = await fetch(`${API_URL}/api/me`, {
            method: 'GET',
            credentials: 'include'
        });

        if (res.ok) {
            const data = await res.json();
            isLoggedIn = true;
            userName = data.username;
            displayName = data.name; // Store the user's name for display

            const userGreeting = document.getElementById('userGreeting');
            if (userGreeting) {
                userGreeting.textContent = displayName;
            }
        }
    } catch (err) {
        console.error('Server unavailable:', err);
    }

    // 2. Configure the button and its hint (tooltip) on the current page
    if (authLink) {
        if (isLoggedIn) {
            // If the user is ALREADY LOGGED IN -> add a link to the dashboard and change the icon to a logout icon
            if (DashboardItem) {
                DashboardItem.style.display = 'inline-block'; // Or 'list-item' / 'block' depending on your CSS
            }
            if (DashboardLink) {
                DashboardLink.title = `Dashboard (${displayName})`;
            }
            
            const logoutText = `Logout (${displayName})`;
            authLink.title = logoutText; // Hint on hover
            authLink.href = `#`; // Hint on hover

           if (authImg) {
                authImg.alt = logoutText;
                authImg.src = '/images/logout.png';
            }

            // Perform logout when the icon is clicked
            authLink.addEventListener('click', async (e) => {
                e.preventDefault();
                await fetch(`${API_URL}/api/logout`, {
                    method: 'POST',
                    credentials: 'include'
                });
                localStorage.removeItem('userName');
                localStorage.removeItem('displayName');
                
                // Redirect back to the index page
                window.location.href = '../index.html'; 
            });
        } else {
            // If the user is NOT LOGGED IN -> Hide the dashboard link and set the icon to a login icon
            if (DashboardItem) {
                DashboardItem.style.display = 'none';
            }

            authLink.title = 'Login to your account';
            if (authImg) {
                authImg.alt = 'Login to your account';
            }
        }
    }

    // 3. Handling the login form itself
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const statusText = document.getElementById('status');

            try {                
                const response = await fetch(`${API_URL}/api/login`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'include',
                    body: JSON.stringify({ username, password })
                });

                if (response.ok) {
                    const data = await response.json();
                    localStorage.setItem('userName', data.username);
                    localStorage.setItem('displayName', data.name);                    
                    
                    window.location.href = '../pages/dashboard.html'; // Go to the main page for logged-in users depending on role
                } else {
                    alert('Error: Invalid username or password!');
                }
            } catch (error) {
                alert('Error: Failed to login.');
            }
        });
    }
});
