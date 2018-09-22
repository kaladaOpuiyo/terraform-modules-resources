import React from "react";

const NavSidBar = () => {
  function handleClick(e) {
    e.preventDefault();
    console.log("The link was clicked.");
    $("#sidebar").toggleClass("active");
  }

  return (
    <nav id="sidebar">
      <div className="sidebar-header">
        <h3>
          <a href="#" onClick={handleClick}>
            TerraGram UI
          </a>
        </h3>
        <strong>
          <a href="#" onClick={handleClick}>
            TF
          </a>
        </strong>
      </div>

      <ul className="list-unstyled">
        <li>
          <a href="#">
            <i className="glyphicon glyphicon-home" />
            PROJECTS
          </a>
          <a href="#">
            <i className="glyphicon glyphicon-briefcase" />
            SETTINGS
          </a>
        </li>
      </ul>
    </nav>
  );
};

export default NavSidBar;
