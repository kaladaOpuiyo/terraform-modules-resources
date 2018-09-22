import React from "react";
import MainPanel from "./Components/MainPanel/MainPanel";
import NavSideBar from "./Components/NavSideBar/NavSideBar";
const App = () => {
  return (
    <div className="wrapper">
      <NavSideBar />
      <MainPanel />
    </div>
  );
};
export default App;
