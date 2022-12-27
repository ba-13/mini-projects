import React from "react";

export default function MyChat({ member, i }) {
  return (
    <div key={i} className="chatbox" id="me">
      <div className="chat">{member.chat}</div>
      <div className="meta">
        {member.date} {member.time}
      </div>
    </div>
  );
}
