# Test Plan for "Remember Me" Functionality

## Test Scenario 1: Login WITH "Remember Me" Checked
1. Open the app (should show login screen if first time)
2. Enter valid credentials
3. **CHECK** the "Remember me" checkbox
4. Click "Sign In"
5. Should navigate to Timer Dashboard
6. Close the app completely
7. Reopen the app
8. **Expected Result**: Should automatically navigate to Timer Dashboard (no login screen)

## Test Scenario 2: Login WITHOUT "Remember Me" Checked
1. Logout from the app (if logged in)
2. App shows login screen
3. Enter valid credentials
4. **DO NOT CHECK** the "Remember me" checkbox (leave it unchecked)
5. Click "Sign In"
6. Should navigate to Timer Dashboard
7. Close the app completely
8. Reopen the app
9. **Expected Result**: Should show the login screen (credentials not saved)

## Test Scenario 3: Explicit Logout
1. Login with "Remember me" checked
2. Navigate to Settings
3. Click Logout
4. **Expected Result**: Should show login screen
5. Close and reopen app
6. **Expected Result**: Should show login screen (saved credentials cleared)

## Changes Made
1. **splash_screen.dart**: Uncommented authentication checking code
   - Now checks for saved credentials on app startup
   - Navigates to Timer Dashboard if authenticated
   - Shows login screen if not authenticated

2. **auth_service.dart**: Modified login method to respect rememberMe parameter
   - Only saves credentials to SharedPreferences when rememberMe is true
   - Session will not persist across app restarts if rememberMe is false
   - Logout still clears all saved data

## Technical Details
- Authentication data stored in SharedPreferences (auth_token, user_data)
- Token verification performed on app startup to ensure validity
- Explicit logout always clears saved credentials
