import React from "react";

export default function OtherChat({ member, i }) {
  return (
    <div key={i} className="chatbox" id="other">
      <div className="name">
        <b>{member.name}</b>
      </div>
      <div className="chat">{member.chat}</div>
      <div className="meta">
        {member.date} {member.time}
      </div>
    </div>
  );
}
