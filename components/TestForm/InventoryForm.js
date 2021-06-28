import React,{useState,useEffect} from 'react';
import { Grid, } from '@material-ui/core';
import Controls from "../../components/controls/Controls";
import { useForm, Form } from '../../components/useForm';

import Axios from 'axios';
import Inventory from './Inventory';

const genderItems = [
    { id: 'Male', title: 'Male' },
    { id: 'Female', title: 'Female' },
    { id: 'Other', title: 'Other' },
]

  const getDepartmentCollection =[
    { id: 'Development', title: 'Development' },
    { id: 'Marketing', title: 'Marketing' },
    { id: 'Accounting', title: 'Accounting' },
    { id: 'HR', title: 'HR' },
]

const initialFValues = {
    id: 0,
    name: '',
    email: '',
    phone: '',
    city: '',
    gender: 'male',
    department: '',
    newName:'',
    newEmail:'',
    newPhone:'0',
    newCity:'',
    newGender:'',
    newDepartment:''
   // date: new Date()
}

export default function InventoryForm(props){
    const {addOrEdit,setOpenPopup,recordForEdit}=props;
 
    const validate = (fieldValues = values) => {
        let temp = { ...errors }
        if ('name' in fieldValues)
            temp.name = fieldValues.name ? "" : "This field is required."
        if ('email' in fieldValues)
            temp.email = (/$^|.+@.+..+/).test(fieldValues.email) ? "" : "Email is not valid."
        if ('phone' in fieldValues)
            temp.phone = fieldValues.phone.length > 9 ? "" : "Minimum 10 numbers required."
        if ('department' in fieldValues)
            temp.department = fieldValues.department.length != 0 ? "" : "This field is required."
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
    
    //const[newName,setNewName]=useState("");
    // const[newEmail,setNewEmail]=useState("0");
    // const[newPhone,setNewPhone]=useState("0");
    // const[newCity,setNewCity]=useState("0");
    // const[newGender,setNewGender]=useState("0");
    // const[newDepartment,setNewDepartment]=useState("0");
    const[userList,setUserList]=useState([]);

   

     const addUser=()=>{
         const id=values.id;
         if(id==0){
        Axios.post('http://localhost:3001/create',
        {name:values.name,
        email:values.email,
        phone:values.phone,
        city:values.city,
        gender:values.gender,
        department:values.department
       // date:values.date
    }).then(()=>{
        console.log("success");
    });
}
else{
    console.log(id);
    console.log(values.name);
    console.log(values.email);
    console.log(values.phone);
    console.log(values.city);
    console.log(values.gender);
    console.log(values.department);
    Axios.put('http://localhost:3001/update',
    {name:values.name,email:values.email,phone:values.phone,city:values.city,gender:values.gender,department:values.department,id:id}).then((response)=>{
         setUserList(userList.map((val)=>{
           return val.id === id ? {id:val.id,name:newName,email:newEmail,phone:newPhone,city:newCity,gender:newGender,department:newDepartment}:val;
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
                        name="name"
                        label="Full Name"
                        value={values.name}
                        onChange={handleInputChange}
                        error={errors.name}
                    />
                    <Controls.Input
                        label="Email"
                        name="email"
                        value={values.email}
                        onChange={handleInputChange}
                        error={errors.email}
                    />
                    <Controls.Input
                        label="Phone"
                        name="phone"
                        value={values.phone}
                        onChange={handleInputChange}
                        error={errors.phone}
                    />
                    <Controls.Input
                        label="City"
                        name="city"
                        value={values.city}
                        onChange={handleInputChange}
                    />

                </Grid>
                <Grid item xs={6}>
                    <Controls.RadioGroup
                        name="gender"
                        label="Gender"
                        value={values.gender}
                        onChange={handleInputChange}
                        items={genderItems}
                    />
                    <Controls.Select
                        name="department"
                        label="Department"
                        value={values.department}
                        onChange={handleInputChange}
                        options={getDepartmentCollection}
                        error={errors.department}
                    />
                    {/* <Controls.DatePicker
                        name="hireDate"
                        label="Date"
                        value={values.date}
                        onChange={handleInputChange}
                    /> */}
                    {/* <Controls.Checkbox
                        name="isPermanent"
                        label="Permanent Employee"
                        value={values.isPermanent}
                        onChange={handleInputChange}
                    /> */}

                    <div>
                        <Controls.Button
                            type="submit"
                            text="Submit"
                            onClick={addUser} />
                        <Controls.Button
                            text="Reset"
                            color="default"
                            onClick={resetForm} />
                    </div>
                </Grid>
            </Grid>
        </Form>
    )

    
}