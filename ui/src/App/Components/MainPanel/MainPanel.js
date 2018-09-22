import React from "react";
import NavBar from "../NavBar/NavBar";
import TotalsPanel from "../TotalsPanel/TotalsPanel";
import ProjectTablePanel from "../ProjectTablePanel/ProjectTablePanel";
import ActionPanel from "../ActionPanel/ActionPanel";
import { Grid, Row, Button } from "react-bootstrap";

const MainPanel = () => {
  return (
    <div id="content">
      <NavBar />
      <Grid>
        <Row className="show-grid">
          <TotalsPanel />
        </Row>

        <div>
          <Button>Refresh</Button>
        </div>

        <br />

        <Row className="show-grid">
          <div>
            <ProjectTablePanel />
            <ActionPanel />
          </div>
        </Row>
      </Grid>
    </div>
  );
};
export default MainPanel;
