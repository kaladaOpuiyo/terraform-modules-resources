import React from "react";
import { Panel, Col, Button } from "react-bootstrap";

class TotalsPanel extends React.Component {
  constructor() {
    super();
    this.state = {
      totals: {}
    };
  }
  componentDidMount() {
    fetch("http://localhost:8070/totals")
      .then(response => {
        return response.json();
      })
      .then(json => {
        this.setState({ totals: json });
      });
  }

  render() {
    return (
      <div>
        <Col xs={6} md={4}>
          <Panel
            style={{
              border: 0,
              boxShadow: "none"
            }}
          >
            <Panel.Body>TOTAL NUMBER OF PROJECTS</Panel.Body>
            {this.state.totals && (
              <Panel.Body>{this.state.totals.TotalProjects}</Panel.Body>
            )}
          </Panel>
        </Col>
        <Col xs={6} md={4}>
          <Panel
            style={{
              border: 0,
              boxShadow: "none"
            }}
          >
            <Panel.Body>TOTAL NUMBER OF MODULES</Panel.Body>
            {this.state.totals && (
              <Panel.Body>{this.state.totals.TotalModules}</Panel.Body>
            )}
          </Panel>
        </Col>
        <Col xs={6} md={4}>
          <Panel
            style={{
              border: 0,
              boxShadow: "none"
            }}
          >
            <Panel.Body>TOTAL NUMBER OF AVAILIABLE RESORUCES</Panel.Body>
            {this.state.totals && (
              <Panel.Body>{this.state.totals.TotalResources}</Panel.Body>
            )}
          </Panel>
        </Col>
      </div>
    );
  }
}
export default TotalsPanel;
