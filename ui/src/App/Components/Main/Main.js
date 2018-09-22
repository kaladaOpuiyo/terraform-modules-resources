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
import SideBar from "./Components/SideBar/SideBar";

const App = () => {
  function handleClick(e) {
    e.preventDefault();
    console.log("The link was clicked.");
    $("#sidebar").toggleClass("active");
  }

  return (
    <div className="wrapper">
      <div id="content">
        <nav className="navbar navbar-default">
          <div className="container-fluid">
            <div className="navbar-header" />

            <div
              className="collapse navbar-collapse"
              id="bs-example-navbar-collapse-1"
            >
              <ul className="nav navbar-nav navbar-right" />
            </div>
          </div>
        </nav>
        <Grid>
          <div>
            <Row className="show-grid">
              <Col xs={6} md={4}>
                <Panel>
                  <Panel.Body>TOTAL NUMBER OF PROJECTS</Panel.Body>
                  <Panel.Body>25</Panel.Body>
                </Panel>
              </Col>
              <Col xs={6} md={4}>
                <Panel>
                  <Panel.Body>TOTAL NUMBER OF MODULES</Panel.Body>
                  <Panel.Body>12</Panel.Body>
                </Panel>
              </Col>
              <Col xsHidden md={4}>
                <Panel>
                  <Panel.Body>TOTAL NUMBER OF RESORUCES</Panel.Body>
                  <Panel.Body>50</Panel.Body>
                </Panel>
              </Col>
            </Row>
          </div>

          <div>
            <Button>Refresh</Button>
          </div>
          <br />
          <div>
            <Row className="show-grid">
              <Col md={6} mdPush={6}>
                <Panel>
                  <Panel.Body>
                    <Tabs defaultActiveKey={2} id="uncontrolled-tab-example">
                      <Tab eventKey={1} title="Network">
                        <br />
                        <ButtonToolbar>
                          {/* Provides extra visual weight and identifies the primary action in a set of buttons */}
                          <Button bsStyle="default">INIT</Button>

                          {/* Indicates a successful or positive action */}
                          <Button bsStyle="primary">PLAN</Button>

                          {/* Contextual button for informational alert messages */}
                          <Button bsStyle="success">BUILD</Button>

                          {/* Indicates caution should be taken with this action */}
                          <Button bsStyle="danger">DESTROY</Button>
                        </ButtonToolbar>
                        <br />
                        <Panel>
                          <Panel.Body />
                        </Panel>
                      </Tab>
                      <Tab eventKey={2} title="Modules">
                        <br />
                        <ButtonToolbar>
                          {/* Provides extra visual weight and identifies the primary action in a set of buttons */}
                          <Button bsStyle="default">INIT</Button>

                          {/* Indicates a successful or positive action */}
                          <Button bsStyle="primary">PLAN</Button>

                          {/* Contextual button for informational alert messages */}
                          <Button bsStyle="success">BUILD</Button>

                          {/* Indicates caution should be taken with this action */}
                          <Button bsStyle="danger">DESTROY</Button>
                        </ButtonToolbar>
                        <br />

                        <Well bsSize="large" />
                      </Tab>
                    </Tabs>
                  </Panel.Body>
                </Panel>
              </Col>
              <Col md={6} mdPull={6}>
                <Panel>
                  <Panel.Body>
                    <Panel.Title>Projects</Panel.Title>
                    <br />
                    <Table responsive>
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>Name</th>
                          <th>Resources</th>
                          <th>Modules</th>
                          <th>Azs</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>1</td>
                          <td>Demo Project 1</td>
                          <td>3</td>
                          <td>2</td>
                          <td>1</td>
                        </tr>
                        <tr>
                          <td>2</td>
                          <td>Demo Project 2</td>
                          <td>12</td>
                          <td>2</td>
                          <td>4</td>
                        </tr>
                        <tr>
                          <td>3</td>
                          <td>Demo Project 3</td>
                          <td>12</td>
                          <td>2</td>
                          <td>1</td>
                        </tr>
                      </tbody>
                    </Table>
                  </Panel.Body>
                </Panel>
              </Col>
            </Row>
          </div>
        </Grid>
      </div>
    </div>
  );
};
export default App;
