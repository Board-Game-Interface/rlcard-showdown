#!/bin/bash

# Start the backend server
cd server
python manage.py runserver &
cd ..

# Start PVE server
cd pve_server
python run_douzero.py &
cd ..

# Start frontend
npm start &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
