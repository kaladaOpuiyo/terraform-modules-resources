import React from "react";
import {
  Well,
  Table,
  ButtonToolbar,
  Tabs,
  Tab,
  Grid,
  Panel,
  Row,
  Col,
  Navbar,
  FormGroup,
  Button,
  FormControl,
  Nav,
  NavItem,
  NavDropdown,
  MenuItem
} from "react-bootstrap";

class ProjectTablePanel extends React.Component {
  constructor() {
    super();
    this.state = {
      projects: {}
    };
  }
  componentDidMount() {
    fetch("http://localhost:8070/projects")
      .then(response => {
        return response.json();
      })
      .then(json => {
        this.setState({ projects: json });
      });
  }

  render() {
    let projects = this.state.projects;

    return (
      <Col md={6} md={6}>
        <Panel
          style={{
            border: 0,
            boxShadow: "none"
          }}
        >
          <Panel.Body>
            <Panel.Title>Projects</Panel.Title>
            <br />
            <Table responsive>
              <thead>
                <tr>
                  <th>#</th>
                  <th>Name</th>
                  <th>Number Of Env</th>
                  <th>Number Of Modules</th>
                  <th>Azs</th>
                </tr>
              </thead>
              <tbody>
                {this.state.projects &&
                  this.state.projects.Projects &&
                  this.state.projects.Projects.map((project, i) => (
                    <tr key={i}>
                      <td>{i + 1}</td>
                      <td>{this.state.projects.Projects[i].Name}</td>
                      <td>
                        {this.state.projects.Projects[i].Environments.envTotals}
                      </td>
                      <td>
                        {this.state.projects.Projects[i].Modules.ModulesTotals}
                      </td>
                      <td>{this.state.projects.Projects[i].Azs.AzsTotals}</td>
                    </tr>
                  ))}
              </tbody>
            </Table>
          </Panel.Body>
        </Panel>
      </Col>
    );
  }
}
export default ProjectTablePanel;
