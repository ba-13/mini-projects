import React from "react";
// import { lazy, Suspense } from "react";
// import axios from "axios";
import OtherChat from "./component/OtherChat";
import ContactBar from "./component/ContactBar";
import POV from "./component/POV";
import MyChat from "./component/MyChat";

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      yourName: "undefined",
      otherName: "undefined",
      otherChat: "undefined",
      chats: "undefined",
      availableContacts: "undefined",
      switchPos: false,
    };
  }
  url_to_data = "http://127.0.0.1:3001";

  handleSwitch = (e) => {
    const switchPos = this.state.switchPos;
    this.setState({ switchPos: !switchPos });
  };

  handleChange = (e) => {
    console.log("Seeing change in dropdown: ", e.target.value);
    this.setState(
      { otherChat: e.target.value, otherName: e.target.value },
      this.getData // callback function once state change has occured
    );
  };

  componentDidMount() {
    console.log("ComponentDidMount, now fetching chat details");
    fetch(this.url_to_data + "/chats")
      .then((res) => res.json())
      .then((data) => {
        this.setState(
          {
            otherChat: data.available_contacts[0],
            otherName: data.available_contacts[0],
            availableContacts: data.available_contacts,
          },
          this.getData
        );
      });
  }

  getData() {
    console.log("Getting data for:", this.state.otherChat);
    fetch(this.url_to_data + `/chats/` + this.state.otherChat)
      .then((res) => res.json())
      .then((data) => {
        this.setState({
          otherChat: data.contact,
          otherName: data.contact,
          chats: data.chats,
          availableContacts: data.available_contacts,
        });
      });
  }

  render() {
    return (
      <div className="app">
        <ContactBar
          contacts={this.state.availableContacts}
          selectValue={this.state.otherChat}
          handleChange={this.handleChange}
        ></ContactBar>
        <POV onClick={this.handleSwitch}></POV>
        {this.state.chats === "undefined" ? (
          <div className="loader"></div>
        ) : (
          this.state.chats.map((member, i) => {
            if (this.state.switchPos) {
              if (member.name.includes(this.state.otherName))
                return <MyChat key={i} member={member} i={i}></MyChat>;
              else return <OtherChat key={i} member={member} i={i}></OtherChat>;
            } else {
              if (member.name.includes(this.state.otherName))
                return <OtherChat key={i} member={member} i={i}></OtherChat>;
              else return <MyChat key={i} member={member} i={i}></MyChat>;
            }
          })
        )}
      </div>
    );
  }
}

export default App;
