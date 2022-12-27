import React from "react";

export default function ContactBar({ contacts, selectValue, handleChange }) {
  let output = [];
  for (let i = 0; i < contacts.length; i++) {
    output.push(contacts[i]);
  }
  return (
    <select
      name="contacts"
      id="contacts"
      defaultValue={selectValue}
      onChange={handleChange}
    >
      {output.map((o, i) => {
        return (
          <option key={i} value={o}>
            {o}
          </option>
        );
      })}
    </select>
  );
}
