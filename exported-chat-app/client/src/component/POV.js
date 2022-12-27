import React from "react";
import "font-awesome/css/font-awesome.min.css";

export default function POV({ onClick }) {
  return (
    <button id="switch-btn" onClick={onClick}>
      <i className="fa fa-refresh fa-3x"></i>
    </button>
  );
}
