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
let ok;

class ProjectTablePanel extends React.Component {
  constructor() {
    super();
    this.state = {
      data: " "
    };
  }
  handleClick = (e, value) => {
    e.preventDefault();
    fetch("http://localhost:8070/actions?action=" + value)
      .then(response => {
        return response.json();
      })
      .then(json => {
        this.setState({ data: json });
      });
  };

  render() {
    return (
      <div>
        <Col md={6} md={6}>
          <Panel
            style={{
              border: 0,
              boxShadow: "none"
            }}
          >
            <Panel.Body>
              <Tabs
                defaultActiveKey={1}
                id="uncontrolled-tab-example"
                style={{
                  border: 0,
                  boxShadow: "none"
                }}
              >
                <Tab eventKey={1} title="VPC">
                  <br />
                  <ButtonToolbar>
                    <Button
                      bsStyle="default"
                      onClick={e => this.handleClick(e, "vpc-init")}
                    >
                      INIT
                    </Button>

                    <Button
                      bsStyle="primary"
                      onClick={e => this.handleClick(e, "vpc-plan")}
                    >
                      PLAN
                    </Button>

                    <Button
                      bsStyle="success"
                      onClick={e => this.handleClick(e, "vpc-build")}
                    >
                      BUILD
                    </Button>

                    <Button
                      bsStyle="danger"
                      onClick={e => this.handleClick(e, "vpc-destroy")}
                    >
                      DESTROY
                    </Button>
                  </ButtonToolbar>
                  <br />

                  {this.state.data &&
                    this.state.data.Outputs && (
                      <Panel
                        style={{
                          border: 0,
                          boxShadow: "none"
                        }}
                      >
                        <Panel.Body>
                          <h3>Output:</h3>
                          {this.state.data.Outputs.Output ? (
                            <span>
                              {this.state.data.Outputs.Output.map(
                                (out, index) => {
                                  return <p key={index}>{out}</p>;
                                }
                              )}
                            </span>
                          ) : (
                            ""
                          )}
                          <h3>Errors:</h3>
                          <span>
                            {this.state.data.Outputs.Errors.map(
                              (error, index) => {
                                return <p key={index}>{error}</p>;
                              }
                            )}
                          </span>
                        </Panel.Body>
                      </Panel>
                    )}
                </Tab>
                <Tab eventKey={2} title="Network">
                  <br />
                  <ButtonToolbar>
                    <Button
                      bsStyle="default"
                      onClick={e => this.handleClick(e, "network-init")}
                    >
                      INIT
                    </Button>

                    <Button
                      bsStyle="primary"
                      onClick={e => this.handleClick(e, "network-plan")}
                    >
                      PLAN
                    </Button>

                    <Button
                      bsStyle="success"
                      onClick={e => this.handleClick(e, "network-build")}
                    >
                      BUILD
                    </Button>

                    <Button
                      bsStyle="danger"
                      onClick={e => this.handleClick(e, "network-destroy")}
                    >
                      DESTROY
                    </Button>
                  </ButtonToolbar>
                  <br />

                  {this.state.data &&
                    this.state.data.Outputs && (
                      <Panel
                        style={{
                          border: 0,
                          boxShadow: "none"
                        }}
                      >
                        <Panel.Body>
                          <h3>Output:</h3>
                          {this.state.data.Outputs.Output ? (
                            <span>
                              {this.state.data.Outputs.Output.map(
                                (out, index) => {
                                  return <p key={index}>{out}</p>;
                                }
                              )}
                            </span>
                          ) : (
                            ""
                          )}
                          <h3>Errors:</h3>
                          <span>
                            {this.state.data.Outputs.Errors.map(
                              (error, index) => {
                                return <p key={index}>{error}</p>;
                              }
                            )}
                          </span>
                        </Panel.Body>
                      </Panel>
                    )}
                </Tab>
                <Tab eventKey={3} title="Modules">
                  <br />
                  <ButtonToolbar>
                    <Button
                      bsStyle="default"
                      onClick={e => this.handleClick(e, "init")}
                    >
                      INIT
                    </Button>

                    <Button
                      bsStyle="primary"
                      onClick={e => this.handleClick(e, "plan")}
                    >
                      PLAN
                    </Button>
                    <Button
                      bsStyle="success"
                      onClick={e => this.handleClick(e, "build")}
                    >
                      BUILD
                    </Button>

                    <Button
                      bsStyle="danger"
                      onClick={e => this.handleClick(e, "destroy")}
                    >
                      DESTROY
                    </Button>
                  </ButtonToolbar>
                  <br />
                  {this.state.data &&
                    this.state.data.Outputs && (
                      <Panel
                        style={{
                          border: 0,
                          boxShadow: "0 5px 15px rgba(0,0,0,0)"
                        }}
                      >
                        <Panel.Body>
                          <h3>Output:</h3>
                          {this.state.data.Outputs.Output ? (
                            <span>
                              {this.state.data.Outputs.Output.map(
                                (out, index) => {
                                  return <p key={index}>{out}</p>;
                                }
                              )}
                            </span>
                          ) : (
                            ""
                          )}
                          <h3>Errors:</h3>
                          <span>
                            {this.state.data.Outputs.Errors.map(
                              (error, index) => {
                                return <p key={index}>{error}</p>;
                              }
                            )}
                          </span>
                        </Panel.Body>
                      </Panel>
                    )}
                </Tab>
              </Tabs>
            </Panel.Body>
          </Panel>
        </Col>
      </div>
    );
  }
}
export default ProjectTablePanel;
