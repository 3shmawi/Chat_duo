# chat_duo
New app using firebase with Salma

# docs
هدف الكورس اننا نتعامل مع الفايربيز من حيث ال {Auth, Database, Real time ،}


كنا بنوجه اليوزر يدخل يسجل دخول او يدخل على الصفحة الرئيسية بناءا على قيمة uid كنا بنحفظها في ال local database عن طريق مكتبة shared_preferences


# Auth
lib>ctrl>app_ctrl >> login(), register(), logout()
كنا بنسجل دخول بالايميل والباسورد
وكنا بنكريت حساب جديد عن طريق الايميل والباسورد

##  لو عندي بيانات اضافية عايز اخزنها كنا بنستخدم ال firestore

lib>ctrl>app_ctrl >> _createUser(String uid)

# ##################################################################
# ##################################################################
# ##################################################################
# AppCtrl Documentation

Purpose

The AppCtrl class serves as the central controller for managing authentication, user data, groups, messages, and general app states. It integrates Firebase services, including FirebaseAuth and Firestore, and uses Cubit for state management.
________________________________________________________________

Authentication (Auth)

Login

Path: lib>ctrl>app_ctrl >> login()
•	Description: Logs in a user with email and password. Validates input fields before proceeding.
•	Implementation Details:
•	Uses Firebase’s signInWithEmailAndPassword method.
•	Saves the user ID (uid) in SharedPreferences via CacheHelper.
•	Fetches user data from Firestore after successful login.
______________

Register

Path: lib>ctrl>app_ctrl >> register()
•	Description: Registers a new user using email and password. Ensures all fields are filled before proceeding.
•	Implementation Details:
•	Uses Firebase’s createUserWithEmailAndPassword method.
•	Calls _createUser to save additional user information in Firestore.
•	Saves the user ID (uid) in SharedPreferences.
______________

Logout

Path: lib>ctrl>app_ctrl >> logout()
•	Description: Logs the user out and clears local data.
•	Implementation Details:
•	Calls Firebase’s signOut method.
•	Removes the uid from SharedPreferences.
•	Resets myData to null.
______________

Additional User Data

Path: lib>ctrl>app_ctrl >> _createUser(String uid)
•	Description: Saves additional user details (e.g., name, email, avatar) to Firestore during registration.
•	Details Stored: User ID, name, email, avatar, date.
________________________________________________________________

User Data

Get User Data

Path: lib>ctrl>app_ctrl >> getMyData(String myId)
•	Description: Fetches the current user’s data from Firestore using their ID (uid).
•	Helper Function: getUserData(String uid) retrieves a specific user’s data.
________________________________________________________________

Get All Users

Path: lib>ctrl>app_ctrl >> getAllUsers()
•	Description: Fetches all users from Firestore, excluding the current user.
•	Additional Functionality: Clears the existing allUsers list before fetching new data.
________________________________________________________________

Group Management

Enable/Disable Group Mode

Path: lib>ctrl>app_ctrl >> toggleCheckBox()
•	Description: Toggles the group creation mode and clears the selectedUser list.
________________________________________________________________

Add/Remove Users

Path: lib>ctrl>app_ctrl >> addOrRemoveUser(UserModel user)
•	Description: Adds or removes a user from the selectedUser list for group creation.
________________________________________________________________

Create Group

Path: lib>ctrl>app_ctrl >> createGroup()
•	Description: Creates a new group with selected users.
•	Implementation Details:
•	Validates that at least two users and a group title are provided.
•	Saves group details to Firestore under the Salma_Groups collection.
________________________________________________________________

Fetch User’s Groups

Path: lib>ctrl>app_ctrl >> getMyGroups()
•	Description: Streams the current user’s groups from Firestore.
________________________________________________________________
Messages

Stream Messages

Path: lib>ctrl>app_ctrl >> getMessages({required String chatId, bool isGroup = false})
•	Description: Streams messages from Firestore for either a group or one-on-one chat.
•	Implementation Details:
•	Fetches messages ordered by date in ascending order.
________________________________________________________________

Send Message

Path: lib>ctrl>app_ctrl >> sendMessage(...)
•	Description: Sends a message to a specific chat (group or individual).
•	Details:
•	Creates a message object.
•	Updates the last message in the chat record.
________________________________________________________________

Fetch Chats

Path: lib>ctrl>app_ctrl >> getMyUsers()
•	Description: Streams the user’s one-on-one chats from Firestore.
________________________________________________________________

State Management

State Classes

	1.	Auth States:
	•	AuthLoadingState: Indicates authentication in progress.
	•	AuthSuccessState: Indicates authentication success.
	•	AuthFailureState: Indicates authentication failure.
	2.	User States:
	•	GetUsersLoadingState: Fetching users in progress.
	•	GetUsersSuccessState: Successfully fetched users.
	•	GetUsersFailureState: Failed to fetch users.
	3.	Group States:
	•	GroupCreateLoadingState: Group creation in progress.
	•	GroupCreateSuccessState: Successfully created a group.
	•	GroupCreateFailureState: Failed to create a group.
	4.	General States:
	•	AppInitialState: Default state.
	•	AppToggleState: Toggles app states (e.g., group mode).
________________________________________________________________

Controllers

	1.	usernameCtrl: Controls username input field.
	2.	emailCtrl: Controls email input field.
	3.	passwordCtrl: Controls password input field.
	4.	groupTitle: Controls group title input field.
	5.	messageCtrl: Controls message input field.
________________________________________________________________

Firebase Collections

	1.	Users Collection (users):
        Stores user data.
    2.	Groups Collection (Salma_Groups):
        Stores group data and messages.
    3.	Chats Collection (Salma_Chats):
        Stores individual chat data and messages.
________________________________________________________________

This structured documentation provides a clear overview of the functionality and usage of the AppCtrl file. Let me know if you need further elaboration!
________________________________________________________________
________________________________________________________________
