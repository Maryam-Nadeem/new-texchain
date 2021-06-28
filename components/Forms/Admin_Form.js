import React from 'react';

import {abi,bytecode} from '../../AdminUserartufact';
import web3 from '../../web3';
import { Button, Form, Container,Table} from 'semantic-ui-react';



class AdminForm extends React.Component {
//const AdminForm = () => {

  state={
    name:'',
    email:'',
    role:0,
    address:'',
    location:'',
    password:'',
    data:[],
    loading:false,
    hash:''
   // user:''
}

onSubmit= async(e)=>{
    e.preventDefault();
    this.setState({loading:true});
    try{

        let data=[...this.state.data];

    data.push({
       name: this.state.name,
       email: this.state.email,
       location: this.state.location,
       password:this.state.password,
       role: this.state.role,
       address: this.state.address
    });
    console.log(data);
    
   
    this.setState({data:data});
    //console.log(user[0]);
    //Router.pushRoute('/');
    
    
    const accounts = await web3.eth.getAccounts();
    console.log(accounts[0]);
    const user_contract= new web3.eth.Contract(JSON.parse(abi),'0x6c318E1001642436c76EFbE2D6e31707169eD578');
//console.log(user_contract);
const reciept = await user_contract.methods.setUser(this.state.address,this.state.name,this.state.password,this.state.email,this.state.location,this.state.role).send({
  from:accounts[0], gas:1000000
});
const log =reciept.events.LogNewUser.returnValues[6];
console.log(log)
//const output =await web3.eth.getTransactionReceipt(reciept.transactionHash.logs);
this.setState({hash:log});
const output =await  user_contract.methods.getdata(log).call();
console.log(output)

this.setState({loading:false});

    }
    catch(error){
    console.log(error)
    }

  
    };
    handleItemDelete=(i)=> {
        var data = this.state.data;
      
        data.splice(i, 1);
      
        this.setState({
          data: data
        });
      }

      // clickme =async()=>{

      // }

    render(){
      const { Header, Row, HeaderCell,Body}=Table;
      const data=this.state.data;

      return ( 

    <Container>
        <h1 style={{marginTop: '60px'}}>Add User</h1>
        <div className="formDiv" style={{backgroundColor:'#e5edf1', padding:'20px', borderRadius:'5px', border:'1px solid #2b5468'}}>
           

  <Form onSubmit={this.onSubmit}>

    <Form.Group unstackable widths={2} >

      <Form.Input type='text' value={this.state.name} 
      onChange={(event)=>{this.setState({name:event.target.value})}}
      label='Name' placeholder='Full Name' />

      <Form.Input type='text' value={this.state.email} 
      onChange={(event)=>{this.setState({email:event.target.value})}}
      label='email' placeholder='Phone No' />

    </Form.Group>

    <Form.Group widths={2}>
      
      <Form.Input  type='text' value={this.state.location} 
      onChange={(event)=>{this.setState({location:event.target.value})}}
      label='Location' placeholder='location' />

      <Form.Input type='text' value={this.state.role} 
      onChange={(event)=>{this.setState({role:event.target.value})}}
      label='User Role' placeholder='Role' />

    </Form.Group>

    <Form.Group widths={2} >
      <Form.Input  type='text' value={this.state.address} 
      onChange={(event)=>{this.setState({address:event.target.value})}}
      label='Profile Hash' placeholder='Account Address'
    />
    <Form.Input  type='text' value={this.state.password} 
      onChange={(event)=>{this.setState({password:event.target.value})}}
      label='password' placeholder='Account Address'
    />
    </Form.Group>
    
    <Button loading={this.state.loading} type='submit' style={{border:'1px solid #2b5468', marginLeft:'440px', width:'200px', backgroundColor:'#9bb4c0',color:'white'}}><b>Submit</b></Button>
  </Form>
  </div>
  


    <Table style={{marginTop:"40px",  border: '2px solid #2b5468' }}>
        <Header>
            <Row> 
                
                <HeaderCell>Name</HeaderCell>
                <HeaderCell>Phone No</HeaderCell>
                <HeaderCell>Location</HeaderCell>
                <HeaderCell>User Role</HeaderCell>
                <HeaderCell>Profile Hash</HeaderCell>
                <HeaderCell>ACTION</HeaderCell>
            </Row>
        </Header>
        <Body>
     
        {data.map((data,index) => {
            
              return (
                <Table.Row key={"item-" + index}>
        <Table.Cell>{data.name}</Table.Cell>
        <Table.Cell>{data.email}</Table.Cell>
        <Table.Cell>{data.location}</Table.Cell>
        <Table.Cell>{data.role}</Table.Cell>
        <Table.Cell>{data.address}</Table.Cell>
        {/* <Table.Cell><Button
    onClick={this.handleItemDelete(index)}>
    Delete
  </Button>
  </Table.Cell> */}
        
        </Table.Row>
         
        );
            })}
      
              
        </Body>
    </Table>
    {/* <Button onClick={this.clickme}></Button> */}
</Container>

      )}}

export default AdminForm;
