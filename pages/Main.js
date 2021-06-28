import React,{useEffect,useState} from 'react';
import Axios from 'axios';
import Admin from './Admin';
import Manu_inventory from './Manu_inventory';
import Supp_inventory from './Supp_inventory';

export default function Main(){
    
    Axios.defaults.withCredentials=true;
    const [role,setRoleId]=useState("");
    
     useEffect(()=>{
        Axios.get("http://localhost:3001/login").then((response)=>{
            if(response.data.loggedIn==true){
              console.log(response.data.user[0].role_id)
        setRoleId(response.data.user[0].role_id);
        // console.log(response.data.user[0].account_address)
            }
        })
    },[])

    return(<div>
   
   {console.log({role})}
    
   <div>
      {(() => {
        if (role=='1') {
          return (
            <Manu_inventory/>
          )
        } else if (role=='2') {
          return (
            
            <Supp_inventory/>
          )
        } else if(role=='3'){
          return (
           <Admin/>
          )
        }
      })()}
    </div>


   {/* {role == '1' ? (
        <Supp_inventory/>
      ) : (
        {role == '2' ? (
          <Manu_inventory/>
        ) : (
          <Admin/>
        )}
        
      )} */}

   
  
   
      </div>)
}