import React,{useState,useEffect} from 'react';
import { Grid } from '@material-ui/core';
import Controls from '../../controls/Controls';
import { useForm, Form } from '../../useForm';

import Axios from 'axios';

export default function AdminForm(props){
    const {addOrEdit,setOpenPopup,recordForEdit}=props;

    const getRoles =[
        { id: '1', title: '1' },
        { id: '2', title: '2' },
        { id: '3', title: '3' },
      ]

      const initialFValues = {
        user_id: 0,
        user_name: '',
        password: '',
        role_id: '',
        account_address: '',
        email: '',
        location: '',
        newName:'',
        newPassword:'',
        newRole:'0',
        newAccountAddress:'',
        newEmail:'',
        newLocation:''
       // date: new Date()
    }

    const validate = (fieldValues = values) => {
        let temp = { ...errors }
        if ('user_name' in fieldValues)
            temp.user_name = fieldValues.user_name ? "" : "This field is required."
        if ('email' in fieldValues)
            temp.email = (/$^|.+@.+..+/).test(fieldValues.email) ? "" : "Email is not valid."
        if ('password' in fieldValues)
            temp.password = fieldValues.password.length > 8 ? "" : "Minimum 8 numbers required."
        if ('role_id' in fieldValues)
            temp.role_id = fieldValues.role_id.length != 0 ? "" : "This field is required."
        setErrors({
            ...temp
        })

        if (fieldValues == values)
            return Object.values(temp).every(x => x == "")
    }

    const {
        values,
        setValues,
        errors,
        setErrors,
        handleInputChange,
        resetForm
    } = useForm(initialFValues , true, validate);

    const[userList,setUserList]=useState([]);

    
    const addUser=()=>{
        const id=values.user_id;
        if(id==0){
       Axios.post('http://localhost:3001/create',
       {user_name:values.user_name,
       password:values.password,
       role_id:values.role_id,
       account_address:values.account_address,
       email:values.email,
       location:values.location
      // date:values.date
   }).then(()=>{
       console.log("success");
   });
}
else{
   console.log(id);
   console.log(values.user_name);
   console.log(values.password);
   console.log(values.role_id);
   console.log(values.account_address);
   console.log(values.email);
   console.log(values.location);
   Axios.put('http://localhost:3001/update',
   {user_name:values.user_name,password:values.password,role_id:values.role_id,account_address:values.account_address,email:values.email,location:values.location,id:id}).then((response)=>{
        setUserList(userList.map((val)=>{
          return val.user_id === id ? {id:val.user_id,user_name:newName,password:newPassword,role_id:newRole,account_address:newAccountAddress,email:newEmail,location:newLocation}:val;
        }))
       });
}
   };

 


   const handleSubmit = e => {
       e.preventDefault()
       if (validate()){
          addOrEdit(values,resetForm);
          setOpenPopup(false);
           
       }
   }

   useEffect(()=>{
       if(recordForEdit!=null)
       setValues({
           ...recordForEdit
       })
   },[recordForEdit])
  

return(

    <Form onSubmit={handleSubmit}>
            
    <Grid container>
        <Grid item xs={6}>
            <Controls.Input
                name="user_name"
                label="User Name"
                value={values.user_name}
                onChange={handleInputChange}
                error={errors.user_name}
            />
            <Controls.Input
                label="Password"
                name="password"
                value={values.password}
                onChange={handleInputChange}
                error={errors.password}
            />
            

            <Controls.Select
                label="Role"
                name="role_id"
                value={values.role_id}
                onChange={handleInputChange}
                options={getRoles}
                error={errors.role_id}
            />
            </Grid>
            <Grid item xs={6}>
            <Controls.Input
                label="Account Address"
                name="account_address"
                value={values.account_address}
                onChange={handleInputChange}
            />
         
            <Controls.Input
                name="email"
                label="Email"
                value={values.email}
                onChange={handleInputChange}
                
            />
            <Controls.Input
                name="location"
                label="Location"
                value={values.location}
                onChange={handleInputChange}
            />
            </Grid>

            <div>
                <Controls.MainButton
                    type="submit"
                    text="Submit"
                    onClick={addUser} 
                    />
                <Controls.MainButton
                    text="Reset"
                    color="default"
                    onClick={resetForm}
                     />
            </div>
        
    </Grid>
</Form>
)}