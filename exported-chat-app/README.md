# Exported Chats Reader

A webapp in react to format exported WhatsApp chats into WA-type layout.

## Usage

Put all the exported chat `.txt` files of a particular person in his/her named directory inside `./chats`. Example, There's an exported file of a user `Tentant` as `./chats/tentant/WhatsApp Chat with Tentant.txt`. Make a folder per person. If you've multiple exported files for a single person, put all of them chronologically (name those files as `0_WhatsA...`, `1_WhatsA...` and so on) in that folder.

Assumption: Chat you exported has the first message sent by the other person. If this is not true, then your username would come up in the list of contacts instead of that person.

Run the following in a terminal:

```bash
cd server
python3 -m venv .venv
source ./.venv/bin/activate
pip3 install -r requirements.txt
python3 server.py
```

In a new terminal:

```bash
cd client
npm install
npm start
```

This should now open your default browser at `http://localhost:3000`.
